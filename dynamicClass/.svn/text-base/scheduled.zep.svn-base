//<?
namespace Tp\DynamicClass;
use Tp\StaticClass\Eventd;
class Scheduled 
{
private status = 0;
private	serv;
private	nextHourTimestamp;
private	nextDayTimestamp;

public	function __construct(object serv, int event = 1)
{
	var now = time();
	let this->nextHourTimestamp	= mktime(date("H",now)+1,0,0,date("m",now), date("j",now), date("Y",now));
	let this->nextDayTimestamp	= mktime(0,0,0,date("m",now), date("j",now)+1, date("Y",now));
	let this->serv = serv;
	if event == 1 {
		Eventd::attach(EVENT_SERVER_START, [this, "start"]);
	}
}

public	function start()
{
	if this->status {
		return;
	}

	let this->status = 1;
	var now = time();

	let this->nextHourTimestamp	= mktime(date("H",now)+1,0,0,date("m",now), date("j",now), date("Y",now));
	this->serv->after((this->nextHourTimestamp - now)*1000, [this, "onHour"]);
	let this->nextDayTimestamp	= mktime(0,0,0,date("m",now), date("j",now)+1, date("Y",now));
	this->serv->after((this->nextDayTimestamp - now)*1000, [this, "onDay"]);
}

public	function onHour() -> void
{
	var now = time();
	if this->nextHourTimestamp <= now {
		let this->nextHourTimestamp = mktime(date("H",now)+1,0,0,date("m",now), date("j",now), date("Y",now));
		this->serv->after((this->nextHourTimestamp - now)*1000, [this, "onHour"]);
		Eventd::dispatch(EVENT_TIME_CROSS_HOUR);
	}
}

public	function onDay() -> void
{
	var now = time();
	if this->nextDayTimestamp <= now {
		let this->nextDayTimestamp = mktime(0,0,0,date("m",now), date("j",now)+1, date("Y",now));
		this->serv->after((this->nextDayTimestamp - now)*1000, [this, "onDay"]);
		Eventd::dispatch(EVENT_TIME_CROSS_DAY);
	}
}

}
