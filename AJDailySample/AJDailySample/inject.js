var nodeList = document.querySelectorAll('li');
function parseNodeList() {
	result = [];
	for(var i=0; i < nodeList.length; i++) {
	    var list = nodeList[i];
	    var name = list.querySelector('h3').textContent;
	    var url = list.querySelector('a').href;
	    result.push({'name' : name, 'url' : url});
	}
	return result;
}

var links = parseNodeList();

var buff = new ArrayBuffer(1024 * 1024);
var u8 = new Uint8Array(buff);

for (var i = 0; i < u8.length; i++) {
	u8[i] = Math.floor(Math.random() * 255);
};

// webkitMessage();
// xhrMessage();

function webkitMessage()
{
    webkit.messageHandlers.ShowLinkList.postMessage(Array.prototype.slice.call(u8));
    //webkit.messageHandlers.ShowLinkList.postMessage(links);
}

function xhrMessage()
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", "http://localhost/ShowLinkList", true);
    xmlHttp.send();
}
