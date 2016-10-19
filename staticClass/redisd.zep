//<?
namespace Tp\StaticClass;
class Redisd
{
private static status		= 0;
//private	static dbStart;
//private	static dbCount;
//private	static passwd;
//private static ports;
private	static conf;
private	static instances	= [];
private	static scripts		= [];

public	static function setup(array config, int event = 1) -> boolean
{
	if self::status {
		return false;
	}
//	var value, confKey = ["dbStart", "dbCount", "passwd", "ports"];
//
//	for value in confKey {
//		if !isset(config[value]) {
//			throw new \Exception(" need config redis : ". value);
//		}
//
//		let self::{value} = config[value];
//	}
	var conf;
	let conf = new \stdClass();

	if isset config["ports"] {
		if !is_array(config["ports"]) {
			throw new \Exception(" redis ports like this ['127.0.0.1:6379',] or ['/tmp/redis6379.sock',]");
		}
		//let self::ports		= config["ports"];
		let conf->ports		= config["ports"];
	} else {
		throw new \Exception("redis need config ports like ['/tmp/redis6379.sock','127.0.0.1:6379'] ");
	}


	if isset config["dbStart"] {
		if !is_int(config["dbStart"]) {
			throw new \Exception("redis dbStart Must be int ");
		}
		//let self::dbStart	= config["dbStart"];
		let conf->dbStart	= config["dbStart"];
	} else {
		throw new \Exception("redis need config dbStart ");
	}

	if isset config["dbCount"] {
		if !is_int(config["dbCount"]) {
			throw new \Exception("redis dbCount Must be int ");
		}
		//let self::dbCount	= config["dbCount"];
		let conf->dbCount	= config["dbCount"];
	} else {
		throw new \Exception("redis need config dbCount ");
	}

	if isset config["passwd"] {
		//let self::passwd	= config["passwd"];
		let conf->passwd	= config["passwd"];
	} else {
		throw new \Exception("redis need config passwd ");
	}

	if isset config["script"] {
		if !is_dir(getCwd()."/script") {
			throw new \Exception("redis lua script need config dir script ");
		}
		let conf->script	= config["script"];
	}

	let self::conf = conf;

	if event == 1 {
		Eventd::attach(EVENT_SERVER_START	, [__CLASS__, "start"]);
		Eventd::attach(EVENT_SERVER_STOP	, [__CLASS__, "stop"]);
	}

	return true;
}


public	static	function __callStatic(string func, array args)
{
	var e, instance;
	try{
		if !isset(args[0]) || !isset(args[1]) || !is_array(args[1]) {
			throw new \Exception("redis:".func."->".var_export(args,true));
		}

		let instance = self::getInstance(args[0]);

		if instance === false {
			throw new \Exception("redis: wrong instance");
		}

		return call_user_func_array([instance, func], args[1]);

	} catch \Exception, e {
		\Tp\StaticClass\RuntimeError::handle(e);
	}

	return false;
}

private	static	function getInstance(int db)
{
	if !isset(self::instances[db]) {
		throw new \Exception(" unexists db for redis:" . db);
	}

	return self::instances[db];
}

public	static	function start()
{
	if self::status {
		return;
	}

	int port, db;
	var instance, file, contents, scriptData = [];

	if isset self::conf->script {
		let scriptData = Autoloader::dirMatchAndResp(getCwd()."/script", ".lua");
	}

	let self::status = 1;

	for port in range(0, self::conf->dbCount) {
		let db = self::conf->dbStart + port;
		let instance = self::connectTo(port);

		if is_bool(instance) {
			throw new \Exception(" cannot connect to redis ! ");
		}
		let self::instances[port] = instance;

		if !empty scriptData {
			for file, contents in scriptData {
				if defined(file) {
					continue;
				}

				define( file, instance->script("load", $contents), 1);
			}
		}
	}
}

public	static	function stop()
{
	var instance;

	for instance in self::instances {
		instance->close();
	}
}

private	static	function connectTo(int port)
{
	if self::status == 0 {
		return false;
	}

	var e, instance;
	int size = count(self::conf->ports);
	int tport= port%size;

	let instance = new \Redis();

try{
	if !instance->pconnect(self::conf->ports[tport]) {
		throw new \Exception("can not connect redis:".(self::conf->ports[tport]));
	}

	if !instance->auth(self::conf->passwd) {
		throw new \Exception(" redis passwd is incorrect");
	}

	if !instance->select(port + self::conf->dbStart) {
		throw new \Exception(" redis select db err");
	}

	return instance;

} catch \Exception , e{
	RuntimeError::handle(e);
}

	return false;
}

}
