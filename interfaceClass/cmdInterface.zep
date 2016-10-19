//<?
namespace Tp\InterfaceClass;
interface CmdInterface
{
	public	static	function init();
	public	static	function handler(object serv, object workerd, int fd, array args);
}
