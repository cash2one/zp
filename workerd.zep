//<?
namespace Tp;
use Tp\StaticClass\Eventd;
final class Workerd
{
private status		= 0;
private cmdData		= [];
private cmdArgs		= [];
private gmtData		= [];
private gmtArgs		= [];
private taskData	= [];
private services	= [];
private serv;
private jsond {set,get};
private cmdDir {set, get};
private gmtDir {set, get};
private taskDir {set, get};

public	function __construct(object serv, object aesd, object jsond) -> void
{
	let this->serv		= serv;
	let this->jsond 	= jsond;
}

public	function dealWebRequest(object request, object response) -> void
{
	return;
}

public	function dealRequest(object request, object response) -> void
{
	string cmd;

	let cmd = (string)request->server["request_uri"];

	var cmdCall;

	if fetch cmdCall , this->cmdData[cmd] {
		{cmdCall}(request,response);
	}

}

public	function dealCommand(object serv, int fd, int fromId, string msg) -> void
{
	string cmd;
	array data = (array)this->jsond->decode(msg);

	if empty data || empty data[2] {
		return;
	}

	let cmd = (string)data[0];

	var cmdCall;

	if fetch cmdCall , this->cmdData[cmd] {
		{cmdCall}(serv, this,fd,data[2]);
	}

}

public	function dealGmtCommand(object serv, int fd, int fromId, string msg) -> void
{
	string cmd;
	array data = (array)this->jsond->decode(msg);

	if empty data || empty data[2] {
		return;
	}

	let cmd = (string)data[0];

	var cmdCall;

	if fetch cmdCall , this->gmtData[cmd] {
		{cmdCall}(serv,this,fd,data[2]);
	}
}

public	function dealTaskCommand(object serv, int taskId, int fromId, array data) -> void
{
	if !isset(data[0]) {
		return;
	}

	var cmdCall;

	if fetch cmdCall, this->cmdData[data[0]] {
		if isset(data[1]) {
			{cmdCall}(serv,this,taskId,data[1]);
		} else {
			{cmdCall}(serv,this,taskId, []);
		}
	}


}

public	function dealTaskFinish()
{
	return;
}

public	function afterSecond(int timer, callable callback)
{
	this->serv->after(timer, callback);
}


public	function send(int fd, array data)
{
	this->serv->send(fd, this->jsond->encode(data));
}

public	function start(object serv, int workerId)
{
	Eventd::dispatch(EVENT_SERVER_PRE_START, [this]);

	if !serv->taskworker {
		swoole_set_process_name("BASE_WORKER_".workerId);
		StaticClass\AutoLoader::dirMatch(this->cmdDir, ".php", this);
		if is_dir(this->gmtDir) {
			StaticClass\AutoLoader::dirMatch(this->gmtDir, ".php", this);
		}
		echo "worker".workerId;
	} else {
		swoole_set_process_name("BASE_TASK_".workerId);
		StaticClass\AutoLoader::dirMatch(this->taskDir, ".php", this);
		echo "task".workerId;
	}

	Eventd::dispatch(EVENT_SERVER_START, [this]);
	Eventd::dispatch(EVENT_SERVER_SUF_START, [this]);
}

public	function stop()
{
	Master::setServerStatus();
	Eventd::dispatch(EVENT_SERVER_STOP, [this]);
}

public	function connect()
{
}

public	function close()
{
}

public	function registerCommand(array data) -> void
{
	string cmd;

	if this->status {
		return;
	}

	let cmd = (string)data[0];

	if isset this->cmdData[cmd] {
		throw new \Exception(" repeat cmd register :".cmd);
	}

	let this->cmdData[cmd] = data[2];
	let this->cmdArgs[cmd] = data[1];
}

public	function registerGmtCommand(array data) -> void
{
	string cmd;

	if this->status {
		return;
	}

	let cmd = (string)data[0];

	if isset this->gmtData[cmd] {
		throw new \Exception(" repeat cmd register :".cmd);
	}

	let this->gmtData[cmd] = data[2];
	let this->gmtArgs[cmd] = data[1];

}

public	function registerServiceCommand(string service) -> void
{	
	if this->status {
		return;
	}

	let this->services[] = service;
}


}
