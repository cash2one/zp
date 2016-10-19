//<?
namespace Tp\DynamicClass;
use Tp\StaticClass\Eventd;
class Cached
{
private	status;
private serverStatus;
private serverCount = 0;
public	function __construct(int workerCount, int event = 1)
{
	let this->serverCount = workerCount;
	let this->serverStatus = new \swoole_atomic(2);
	this->serverStatus->set(0);

	if event == 1 {
		Eventd::attach(EVENT_SERVER_SUF_START, [this,"start"]);
	}
}

public	function start() -> void
{
	if this->status {
		return;
	}

	let this->status = 1;

	this->serverStatus->add();
}

public	function checkStatus() -> boolean
{
	if this->serverCount != this->serverStatus->get() {
		return false;
	} 

	return true;
}

}
