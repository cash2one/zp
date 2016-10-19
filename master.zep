//<?
namespace Tp;
use Tp\StaticClass\Eventd;
use Tp\StaticClass\Redisd;
function Start(object config)
{
	Master::run(config);
}
class Master
{
private static	status = 0;
private static	worker;

public	static	function setServerStatus()
{
	let self::status = 2;
}

public	static	function getServerStatus()
{
	return self::status;
}

public	static	function stop()
{
	self::worker->stop();
}

public	static	function run(object config)
{
	int	workerCount;
	string libDir, cmdDir, taskDir, gmtDir;
	var e, serv, worker, gmtServ, cached, scheduled;
	var servConf, confKey, confValue, aesd, jsond;

	if self::status {
		return;
	}

	let self::status = 1;

try {
	let libDir	= getCwd()."/lib";
	let cmdDir	= libDir."/worker";
	let gmtDir	= libDir."/gmt";
	let taskDir	= libDir."/task";

	if !isset config->server {
		throw new \Exception("config server must be config");
	}

	if count(config->server) != 3 {
		throw new \Exception("config server must like ['HTTP', ip, port ]");
	}

	if !is_dir(getCwd()."/run") {
		throw new \Exception("run dir  must be config for save pid");
	}

	if !is_int(config->server[1]) {
		throw new \Exception(" port need unsign smallint ！！ ");
	}
	
	if config->server[2] === "HTTP" {
		let serv = new \swoole_http_server(config->server[0], config->server[1]);
	} elseif config->server[2] === "WEB" {
		let serv = new \swoole_websocket_server(config->server[0], config->server[1]);
	} else {
		let serv = new \swoole_server(config->server[0], config->server[1]);
	}

	if !is_dir(cmdDir) {
		throw new \Exception("worker dir unexists ");
	}

	let servConf = ["worker_num":1,"log_file":"/data/log/TP.log","open_length_check":true,"package_length_type":"n","package_max_length":65534, "package_length_offset":0, "package_body_offset":2];

	if isset config->set && typeof(config->set) == "array" {
		for confKey,confValue in config->set {
			let servConf[strtolower(confKey)] = confValue;
		}
	}

	if isset config->gmt_server {
		let gmtServ = serv->listen( config->gmt_server[0],  config->gmt_server[1], SWOOLE_SOCK_TCP);

		if !is_dir(gmtDir) {
			throw new \Exception(" gmt  need gmt dir config");
		}

		if config->gmt_server[1] == config->server[1] {
			throw new \Exception(" port repeat listen！！ ");
		}

		if !is_int(config->gmt_server[1]) {
			throw new \Exception(" port need unsign smallint ！！ ");
		}
		gmtServ->set(["open_length_check":true,"package_length_type":"n","package_max_length":65534, "package_length_offset":0, "package_body_offset":2]);
	}

	if isset servConf["task_worker_num"] {
		if !is_dir(taskDir) {
			throw new \Exception(" task worker need task dir config");
		}

		let workerCount = (int)servConf["task_worker_num"] + (int)servConf["worker_num"];
	} else {
		let workerCount = (int)servConf["worker_num"];
	}

	serv->set(servConf);

//	/////
	if isset config->cmd_aes {
		let aesd = new DynamicClass\Aesd(config->cmd_aes);
	} else {
		let aesd = new DynamicClass\Aesd("sdag54367h76#42!6%sd");
	}

	if isset config->cmd_md5 {
		let jsond = new DynamicClass\Jsond(aesd,config->cmd_md5);
	} else {
		let jsond = new DynamicClass\Jsond(aesd,"sdg6fhjuky74567833fh78$%^@(fgfdsa");
	}


	Eventd::setup();
	let cached		= new DynamicClass\Cached(workerCount);
	let scheduled	= new DynamicClass\Scheduled(serv);

	if isset config->redis {
	//	let redisd	= new DynamicClass\Redisd(config->redis);
		Redisd::setup(config->redis);
	}

	StaticClass\Log::setup(getCwd()."/log/");
	StaticClass\AutoLoader::setup(libDir);

	let worker	= new Workerd(serv, aesd, jsond);
	worker->setCmdDir(cmdDir);
	worker->setGmtDir(gmtDir);
	worker->setTaskDir(taskDir);
	let self::worker = worker;
	let serv->cached = cached;

	if isset config->gmt_server {
		gmtServ->on("receive", [worker, "dealGmtCommand"]);
	}

	serv->on("start"		, function(object serv)
	{
		swoole_set_process_name("BASE_MASTER");

		int i = 1000;

		while i {
			if serv->cached->checkStatus() {
				break;
			}

			usleep(10000);
			let i--;
		}

		if i == 0 {
			echo "[start fail]";
		} else {
			echo "[start ok]";
		}

		if isset serv->setting["daemonize"] && serv->setting["daemonize"] {
			file_put_contents(getCwd()."/run/worker_pid", $serv->master_pid);
		}
		echo "1111";

	});

	if config->server[2] === "HTTP" {
		serv->on("request"		, [worker, "dealRequest"]);
	} elseif config->server[2] === "WEB" {
		serv->on("message"		, [worker, "dealWebRequest"]);
	} else {
		serv->on("receive"		, [worker, "dealCommand"]);
	}

	serv->on("connect"		, [worker, "connect"]);
	serv->on("close"		, [worker, "close"]);
	serv->on("workerStart"	, [worker, "start"]);
	serv->on("workerStop"	, [worker, "stop"]);

	serv->on("Managerstart"	, function(serv)
	{
		swoole_set_process_name("BASE_MANAGER");
	});

	serv->on("WorkerError"	, function(serv, wid, wpid, exit_code){
		\Tp\StaticClass\Log::handle("server_err", [wid, wpid, exit_code]);
	});

	if isset servConf["task_worker_num"] {
		serv->on("task"		, [worker, "dealTaskCommand"]);
		serv->on("finish"	, [worker, "dealTaskFinish"]);
	}

} catch \Exception , e {
	echo e->getMessage();
	exit();
}

serv->start();

}

}
