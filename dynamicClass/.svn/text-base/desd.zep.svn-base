//<?
namespace Tp\DynamicClass;
class Desd 
{
private	secretKey;
private iv;

public	function __construct(string secretKey)
{
	let this->secretKey = secretKey;
	let this->iv = "12345678";
}

public	function encrypt(string msg)
{
	return base64_encode(this->encode(msg));
}

public	function encode(string msg)
{
	var td, ret;
	let td = mcrypt_module_open(MCRYPT_3DES,"",MCRYPT_MODE_ECB,"");
	let ret = this->PaddingPKCS7(msg);
	mcrypt_generic_init(td,this->secretKey,this->iv);
	let ret = mcrypt_generic(td,ret);
	mcrypt_generic_deinit(td);
	mcrypt_module_close(td);
	return ret;
}

public	function decrypt(string msg)
{
	return this->decode(base64_decode(msg));
}

public	function decode(string msg)
{
	var td, ret;
	let td = mcrypt_module_open(MCRYPT_3DES,"",MCRYPT_MODE_ECB,"");
	mcrypt_generic_init(td,this->secretKey,this->iv);
	let ret = trim(mdecrypt_generic(td,msg));
	let ret = this->UnPaddingPKCS7(ret);
	mcrypt_generic_deinit(td);
	mcrypt_module_close(td);
	return ret;
}

private	function PaddingPKCS7(string msg)
{
	int padlen = 8 - strlen( msg ) % 8 ;

	return msg.str_repeat(chr(padlen), padlen);
}

private	function UnPaddingPKCS7(string msg)
{
	int padlen  = (int)ord(substr(msg,strlen(msg) - 1,1));

	if padlen > 8 {
		return msg;
	}

	if unlikely strspn(msg, chr(padlen), strlen(msg) - padlen) != padlen {
		return "";
	}

	return substr(msg, 0, -padlen);
}

}
