//<?
namespace Tp\StaticClass;
class Eventd
{
private static status	= 0;
private static events	= [];

public	static	function setup()
{
	if self::status == 0 {
		define("EVENT_SERVER_PRE_START"	, 1,1);
		define("EVENT_SERVER_START"		, 2,1);
		define("EVENT_SERVER_SUF_START"	, 3,1);
		define("EVENT_SERVER_STOP"		, 4,1);
		define("EVENT_DATA_LOG"			, 5,1);
		define("EVENT_TIME_CROSS_HOUR"	, 6,1);
		define("EVENT_TIME_CROSS_DAY"	, 7,1);
		let self::events = array_fill(0, 8, []);
	}
}

public	static	function attach(int event, callable callback, string flag = "") -> void
{
	if unlikely event == 0 {
		throw new \Exception("未初始化 Eventd !!!! ");
	}
	if unlikely !isset self::events[event] {
		let self::events[event] = [];
	}

	if flag == "" {
		let self::events[event][]		= callback;
	} else {
		let self::events[event][flag]	= callback;
	}
}

public	static	function detach(int event, string flag) -> void
{
	if isset self::events[event][flag] {
		unset(self::events[event][flag]);
	}
}

public	static	function dispatch(int event, array contents = []) -> void
{
	var callback;

	if unlikely !isset self::events[event] {
		return;
	}

	for callback in self::events[event] {
		call_user_func_array(callback,contents);
	}
}

}
