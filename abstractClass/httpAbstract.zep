//<?
namespace Tp\AbstractClass;
abstract class HttpAbstract implements \Tp\InterfaceClass\HttpInterface
{
	public	static	function setup(object worker) -> boolean
	{
		var cmd, arg;

		let cmd	= get_called_class()."::init";
		let arg	= {cmd}();

		if count(arg) != 2 {
			return false;
		}

		worker->registerCommand([arg[0],arg[1],get_called_class()."::handler"]);
		return true;
	}
}
