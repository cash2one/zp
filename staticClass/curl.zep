//<?
namespace Tp\StaticClass;
class Curl
{
public static function ssl(string url, string post = "", int timeout = 5, array options = [])
{
	var defaults, ch, result;
	let defaults = [CURLOPT_HEADER:0,CURLOPT_FRESH_CONNECT:1,CURLOPT_RETURNTRANSFER:1,CURLOPT_SSL_VERIFYHOST:0,CURLOPT_SSL_VERIFYPEER:0,CURLOPT_FORBID_REUSE:1,CURLOPT_TIMEOUT:timeout];

	if post != "" {
		let defaults[CURLOPT_POST]			= 1;
		let defaults[CURLOPT_URL]			= url;
		let defaults[CURLOPT_POSTFIELDS]	= post;
		let ch = curl_init();
	} else {
		let ch = curl_init(url);
	}

	if !empty options {
		var ook, oov;

		for ook,oov in options {
			let defaults[ook] = oov;
		}
	}

	curl_setopt_array(ch, defaults);

	let result =  curl_exec($ch);

	if unlikely result === false {
		curl_close(ch);
		return false;
	}

	curl_close(ch);
	return result;
}

public	static	function send(string url, string post = "", int port = 80, array options = [])
{
	var defaults, result, ch;

	let defaults = [CURLOPT_HEADER:0,CURLOPT_FRESH_CONNECT:1,CURLOPT_RETURNTRANSFER:1,CURLOPT_FORBID_REUSE:1,CURLOPT_TIMEOUT:3,CURLOPT_PORT:port];

	if post != "" {
		let defaults[CURLOPT_POST]			= 1;
		let defaults[CURLOPT_URL]			= url;
		let defaults[CURLOPT_POSTFIELDS]	= post;
		let ch = curl_init();
	} else {
		let ch = curl_init(url);
	}

	if !empty options {
		var ook, oov;

		for ook,oov in options {
			let defaults[ook] = oov;
		}
	}

	curl_setopt_array(ch, defaults);

	let result =  curl_exec($ch);

	if unlikely result === false {
		curl_close(ch);
		return false;
	}

	curl_close(ch);
	return result;

}

}
