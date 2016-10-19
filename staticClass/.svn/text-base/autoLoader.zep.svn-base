//<?
namespace Tp\StaticClass;
class AutoLoader
{
private static rootDir;

public	static	function setup(rootDir)
{
	let self::rootDir = rootDir;
}

public	static	function dirMatch(string dir, string match = ".php", object ob) -> void
{
	var file;
	int len = match->length();
	var d = opendir(dir);
	var_dump("load dir: ". dir);

	loop {
		let file = readdir(d);

		if file == false {
			break;
		}

		if strpos(file,".") === 0 {
			continue;
		}

		if is_dir(dir."/".file) {
			self::dirMatch(dir, match);
			continue;
		}

		if substr(file, -len) !== match {
			continue;
		}

		self::active(dir."/".file, ob);
	}
}

public	static	function dirMatchAndResp(string dir, string match) -> array
{
	var file;
	var content, data = [];
	int len = match->length();
	var d = opendir(dir);

	loop {
		let file = readdir(d);

		if file == false {
			break;
		}

		if strpos(file,".") === 0 {
			continue;
		}

		if is_dir(dir."/".file) {
			let data = array_merge(data,self::dirMatch(dir, match));
			continue;
		}

		if substr(file, -len) !== match {
			continue;
		}

		let content = file_get_contents(dir."/".file);

		if !content {
			continue;
		}

		let file	= strtoupper(str_replace(".", "_", file));
		let data[file] = content;
	}

	return data;
}

private	static	function active(string file, object ob)
{
	require file;
	var data = pathinfo(file);

	let file = data["dirname"]."/".data["filename"];
	let file = str_replace([self::rootDir,"/"], ["","\\"], file);
	
	if !is_callable([file,"setup"]) {
		throw new \Exception(file . ": must be extend CmdAbstract or other");
	}
	
	call_user_func_array([file,"setup"],[ob]);
}

}
