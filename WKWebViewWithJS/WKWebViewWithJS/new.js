function dofirst(){
	//先跟畫面產生關聯，在建立事件聆聽的功能
	//表單名：theForm
	document.getElementById('theForm').onsubmit = calculate;
}
function calculate(){
	var quantity = document.getElementById('quantity').value;
	var price = document.getElementById('price').value;
	var tax = document.getElementById('tax').value;
	var discount = document.getElementById('discount').value;

	var total = quantity * price;
	tax = tax/100 ;
	tax ++ ;
	total = total*tax;
	total -=  discount ;
	// 取小數後二位 	
	total = total.toFixed(2);
    //將算出的值顯示
	document.getElementById('total').value = total;
    // 經由 註冊的Code 傳送 Value 到 WkWebView 中
    window.webkit.messageHandlers.autoLayout.postMessage(total);
	return false;
}
// 可讓 Xcode 呼叫
function sayHi(){
    alert('Hi');
    document.getElementById('total2').value = 'Hi';
}
window.addEventListener('load',dofirst,false);
/*在js呼叫函數：
	1. 事件聆聽
	2. 計時器 setInterual(函式,毫秒)
*/
/*
HTML DOM
document.
方法
{
	getElementById()
	getElementsByName()
	getElementByTagName()
	getElementByClassName()

	querySelector()    id:#xxx class: .xxx  tag: xxx 
	querySelectorAll()
}
*/ 
