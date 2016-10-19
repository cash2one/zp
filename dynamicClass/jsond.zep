//<?
namespace Tp\DynamicClass;
class Jsond 
{
//@md5 encrypt share key
private proKey;
//@protocol length like 2 or 4
private proLen;
//@protocol pack type  like n or N
private proType;
//@ MD5 SIGN last position
private md5Len;
//@ data start position
private dataLen;
//@ encrypt class 
private	encryptd {set, get};

public	function __construct(object encryptd, string proKey, string type = "n")
{
	if type == "N" {
		let this->proLen	= 2;
		let this->proType	= "n";
		let this->md5Len	= 34;
		let this->dataLen	= 35;
	} else {
		let this->proLen	= 2;
		let this->proType	= "n";
		let this->md5Len	= 34;
		let this->dataLen	= 35;
	}

	let this->proKey	= proKey;
	let this->encryptd	= encryptd;
}

public	function encode(array data, int compress = 1) -> string
{
	int tkey = 1;
	var msg = json_encode(data);

	switch(compress)
	{
		case 1:
			let msg = base64_encode(msg);
			break;
		case 2:
			let tkey = 2;
			let msg = base64_encode(gzcompress(msg));
			break;
		case 3:
			let tkey = 3;
			let msg = base64_encode(gzcompress(this->encryptd->encode(msg)));
			break;
		default:
			let msg = base64_encode(msg);
			break;
	}

	let msg = md5(this->proKey.msg).msg.tkey;
	return pack(this->proType, strlen(msg)).msg;
}

public	function decode(string msg) -> array
{
	var e,res,data;
	int compress;
	string sign;

	try {
		if unlikely msg->length() < 54 {
			throw new \Exception("收到过短字符串".msg);
		}

		let sign		= substr(msg, this->proLen, 32);
		let data 		= substr(msg, this->md5Len, -1);

		if unlikely md5(this->proKey.data) !== sign {
			throw new \Exception("sign check err!");
		}

		let compress	= (int)substr(msg,-1,1);

		switch(compress)
		{
			case 1:
				let data = base64_decode(data);
				break;
			case 2:
				let data = gzuncompress(base64_decode(data));
				break;
			case 3:
				let data = this->encryptd->decode(gzuncompress(base64_decode(data)));
				break;
			default:
				throw new \Exception(" undefined protocol compress format ");
		}

		let res = json_decode(data,true);

		if unlikely !is_array(res) {
			throw new \Exception(" undefined protocol json format ");
		}

		return res;

	} catch \Exception, e {
		\Tp\StaticClass\RuntimeError::handle(e);
	}

	return [];
}

}
