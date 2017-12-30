function _exec(tp) {
	tp_md5=hex_md5(tp);
	if(  tp_md5 == "0fadf2c580496ffce264bb6e7ffb1f99" ) { // change this
		window.location.href="https://home.ustc.edu.cn/~jkw/secret/"+tp+".html";
	}
	else {
		alert("Secret Code is not correct!");
	}
}
