// Put your application scripts here

var wsurl = window.location.href.replace(/^http(s?:\/\/.*)\/.*$/, 'ws$1/channel')


const socket = new ReconnectingWebSocket(wsurl);
//socket.debug = true;
socket.timeoutInterval = 5400;


socket.addEventListener('open', function(event) {
    console.log("socket opened");
    $('#wsstatus').removeClass("closed");
    $('#wsstatus').addClass("opened");
});

socket.addEventListener('close', function(event) {
    console.log("socket closed");
    $('#wsstatus').removeClass("opened");
    $('#wsstatus').addClass("closed");

});

socket.addEventListener('message', function(event) {
    $.notify("channel closed");
});


function startUpdatePolling() {

    //    function reloadPage() {
    //        document.location.reload();
    //    }

    //    setInterval(reloadPage, 3000);

}