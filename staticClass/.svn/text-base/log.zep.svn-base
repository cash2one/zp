//<?
namespace Tp\StaticClass;
class Log
{
private static rootDir;

public	static	function setup(rootDir)
{
	let self::rootDir = rootDir;
	self::checkWriteable();
	error_reporting(E_ALL);
	set_error_handler([__CLASS__, "errorHandle"]);
	register_shutdown_function( [__CLASS__, "fatalHandle"] );
}

public	static function handle(string file, var msg)
{
	string logDir = self::rootDir. date("Y-m-d/");

	if !is_dir(logDir) {
		umask(0);
		mkdir(logDir, 0700, true);
	}

	let logDir .= file;

	if is_array(msg) {
		file_put_contents(logDir, date("[H:i:s]"). " array |".var_export(msg, true). PHP_EOL, FILE_APPEND);
	} elseif unlikely is_object(msg) {
		file_put_contents(logDir, date("[H:i:s]"). " class |".var_export(msg, true). PHP_EOL, FILE_APPEND);
	} else {
		file_put_contents(logDir, date("[H:i:s]"). " others |".msg. PHP_EOL, FILE_APPEND);
	}
}

public	static	function errorHandle( int errno, string errstr, string errfile, int errline)
{
	var arr = [errno,errstr,errfile,errline];

	self::handle("error", implode(" ", arr));
}

public	static	function fatalHandle()
{
	var error;

	if \Tp\Master::getServerStatus() == 1 {
		\Tp\Master::stop();
	} else {
		self::handle("final_error", " after stop notice ");
	}

	let error = error_get_last();

	self::handle("final_error", error_get_last());

}

private static function checkWriteable()
{
	umask(0);
	if !is_dir(self::rootDir) {
		if !mkdir(self::rootDir, 0700) {
			throw new \Exception(" LOG DIR can not create ");
		}
	}
	if !is_readable(self::rootDir) || !is_writeable(self::rootDir) {
		throw new \Exception(" LOG DIR can not read or write");
	}
}

}
