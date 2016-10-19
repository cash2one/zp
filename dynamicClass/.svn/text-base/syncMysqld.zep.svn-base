//<?
namespace Tp\DynamicClass;
class syncMysqld 
{
private config;

public	function __construct(object config)
{
	let this->config = config;
}

private	function query(string sql, string db)
{
	int rowCount;
	var e,  mysqli, result, grid;

	let mysqli = mysqli_connect("p:". this->config->hostName, this->config->userName, this->config->password);

	if mysqli->connect_errno {
		return false;
	}

	mysqli->set_charset("utf8");

	if !mysqli->select_db(db) {
		return false;
	}

	let result = mysqli->query(sql);

	if is_bool(result) {
		if unlikely result == false {
			return false;
		}

		return true;
	}
	
	let grid		= [];
	let rowCount	= (int)mysqli_num_rows(result);

	if rowCount <= 0 {
		return [];
	}

	while rowCount {
		let grid[] = mysqli_fetch_assoc( result );
		let rowCount-- ;
	}

	mysqli->close();

	return grid;
}

}
