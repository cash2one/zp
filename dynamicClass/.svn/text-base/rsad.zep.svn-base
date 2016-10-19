//<?
namespace Tp\DynamicClass;
class Rsad 
{
private	priKey;
private	pubKey;

//@init private key and public key
public	function __construct(string priKey, string pubKey)
{
	let this->priKey = priKey;
	let this->pubKey = pubKey;
}

//@公钥加密
public	function encodePu(string msg) -> string
{
	var res, encrypted = "";

	let res = openssl_get_publickey(this->pubKey);

	if unlikely is_bool(res) {
		return "";
	}

	openssl_public_encrypt(msg,encrypted,res);
	openssl_free_key(res);

	return base64_encode(encrypted);
}

//@私钥解密
public	function decodePr(string msg) -> string
{
	var res, decrypted = "";

	let res = openssl_get_privatekey(this->priKey);

	if unlikely is_bool(res) {
		return "";
	}

	openssl_private_decrypt(base64_decode(msg),decrypted,res);
	openssl_free_key(res);

	return decrypted;
}

//@私钥加密
public	function encodePr(string msg) -> string
{
	var res, encrypted = "";

	let res = openssl_get_privatekey(this->priKey);

	if unlikely is_bool(res) {
		return "";
	}

	openssl_private_encrypt(msg,encrypted,res);
	openssl_free_key(res);

	return base64_encode(encrypted);
}

//@公钥解密
public	function decodePu(string msg) -> string
{
	var res, decrypted="";

	let res = openssl_get_publickey(this->pubKey);

	if unlikely is_bool(res) {
		return "";
	}

	openssl_public_decrypt(base64_decode(msg),decrypted,res);
	openssl_free_key(res);

	return decrypted;
}

//@私钥加签
public	function sign(string msg) -> string
{
	var res, sign="";
	let res = openssl_get_privatekey(this->priKey);

	if unlikely is_bool(res) {
		return "";
	}

	openssl_sign(msg, sign, res);

	openssl_free_key(res);

	return base64_encode(sign);
}

//@公钥验签
public	function verify(string msg, string sign) -> boolean
{
	var res, result;

	let res = openssl_get_publickey(this->pubKey);

	if unlikely is_bool(res) {
		return false;
	}

	let result = (bool)openssl_verify(msg, base64_decode(sign), res);

	openssl_free_key(res);

	return result;
}


}
