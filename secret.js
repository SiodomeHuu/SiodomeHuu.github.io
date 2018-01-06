function _exec(tp) {
	tp_md5=hex_md5(tp+"secret code's salt!!!");
	if(  tp_md5 == "894898b37be3e46c670c7d7d86daf468" ) { // change this
		window.location.href="http://home.ustc.edu.cn/~jkw/secret/"+tp+".html";
	}
	else if(tp=="") {
		// pass
	}
	else {
		alert("Secret Code is not correct!");
	}
}
