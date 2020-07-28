
**Welcome to HMX's Blog!~**

<h1><strong>铭记：某件事情后的</strong></h1>

<script>
let temp = self.setInterval("clock()",1000);
function clock() {
	let prev = new Date();
	prev.setFullYear(2020);
	prev.setMonth(4); // May
	prev.setDate(16);
	prev.setHours(12);
	prev.setMinutes(28);
	prev.setSeconds(0);
	let now = new Date();

	let timeDiff = (now-prev)/1000;
	let dayCount = Math.floor(timeDiff / 86400);
	timeDiff = timeDiff - dayCount * 86400;
	let hours = Math.floor(timeDiff / 3600);
	timeDiff = timeDiff - hours * 3600;
	let minutes = Math.floor(timeDiff / 60);
	let seconds = timeDiff - minutes * 60;

	document.getElementById("warn").innerText = dayCount + '天' + hours + '时' + minutes + '分' + seconds + '秒'
}
</script>

<h1 id="warn"> </h1>

<br/>
<br/>
<br/>

这个博客大概会涉及许多计算机相关的学科和心得吧，大概。

说不定也有其他的奇奇怪怪的东西。


<h1 id="index"> 索引 </h1>

* [学科心得](#course)

* [尝试写的教程](#article)

* [我的部分代码](#mycode)

<br><br><br><br><br>

---

<h2 id="course"><em>学过的科目及其心得</em></h2>

[程序设计语言(C语言)](/course/CLanguage.md)

[随机过程](/course/Randproc.md)

[算法导论(还在维护)](/course/Algorithm.md)

[编译原理](/course/Compiler.md)

<!--

[算法导论](/course/Algorithm.md)

[数字电路与模拟电路](#)

[计算机系统概论](#)

[计算机系统详解(csapp)](#)

[复变函数](#)

[数理方程](#)

[概率论与数理统计](#)

-->


[回到索引](#index)


---

<br><br><br><br><br>

---

<h2 id="article"><em>奇怪的教程</em></h2>



[回到索引](#index)

---

<br><br><br><br><br>

---

<h2 id="mycode"><em>项目</em></h2>

### **C++**

### **Java**

* [LC3模拟器及其简易操作系统](https://github.com/jikaiwen/lc3-sti-and-os/)

### **Verilog**

* [简易的打地鼠](https://github.com/jikaiwen/jikaiwen.github.io/tree/master/mycode/Whac-A-Mole/)

* [单周期，多周期，流水线(有Bug)的Mips](https://github.com/jikaiwen/jikaiwen.github.io/tree/master/mycode/Mips/)

	流水线就中断的时候有问题。另外，因为似乎内部要求的时钟频率太快，fpga没法运行(也就是仿真和烧写结果不一致)。

### **Python**

* [基于pygame实现的简易版东方弹幕射击类游戏](https://github.com/jikaiwen/pygame-touhou)

    因为素材权限可能有问题，所以只放上了原创的代码。

[回到索引](#index)


---

神秘对话框

<input type="text" id="inputstr" onkeypress="boxKey()"/>
<input type="button" value="神秘按钮" onclick="exec()"/>


<script type="text/javascript" src="md5.js"></script>
<script type="text/javascript" src="secret.js"></script>

<script>
	function boxKey() {
		if(window.event.keyCode==13) {
			exec();
		}
	}
	function exec() {
		tp=document.getElementById("inputstr").value;
		_exec(tp);
	}
</script>



---


<a href="/inner"> <font color="white">里</font> </a>

# Contact Me

戳下面的头像。
