//<?
namespace Tp\DynamicClass;
class Aesd 
{
private status = 0;
private	secretKey;

public	function __construct(string secretKey)
{
	let this->secretKey = secretKey;
}

public	function encode(string msg)
{
	var td, iv, encrypted;
	let td = mcrypt_module_open(MCRYPT_RIJNDAEL_256,"",MCRYPT_MODE_CBC,"");
	let iv = mcrypt_create_iv(mcrypt_enc_get_iv_size(td), MCRYPT_DEV_URANDOM);
	mcrypt_generic_init(td,this->secretKey,iv);
	let encrypted = mcrypt_generic(td,msg);
	mcrypt_generic_deinit(td);
	mcrypt_module_close(td);
	return iv . encrypted;
}

public	function decode(string msg)
{
	var td, iv, data;
	let td = mcrypt_module_open(MCRYPT_RIJNDAEL_256,"",MCRYPT_MODE_CBC,"");
	let iv = mb_substr(msg,0,32,"latin1");
	mcrypt_generic_init(td,this->secretKey,iv);
	let data = mb_substr(msg,32,mb_strlen(msg,"latin1"),"latin1");
	let data = mdecrypt_generic(td,data);
	mcrypt_generic_deinit(td);
	mcrypt_module_close(td);
	return trim(data);
}

}
