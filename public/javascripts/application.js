// Put your application scripts here


var socket;

var wsurl = window.location.href.replace(/^http(s?:\/\/.*)\/.*$/, 'ws$1/channel')

$(document).ready(() => {

    socket = new ReconnectingWebSocket(wsurl);

    //socket.debug = true;
    socket.timeoutInterval = 5400;

    socket.addEventListener('open', (event) => {
        console.log("socket opened");
        $('#wsstatus').removeClass("closed");
        $('#wsstatus').addClass("opened");
    });

    socket.addEventListener('close', (event) => {
        console.log("socket closed");
        $('#wsstatus').removeClass("opened");
        $('#wsstatus').addClass("closed");
    });

    socket.addEventListener('message', (event) => {
        console.log("ws message: " + event.data);
        var data = JSON.parse(event.data);
        $.notify(data.message, data.severity);
    });

    $('#ping_button').on('click', (e) => {
        socket.send(JSON.stringify({ event: "ping", data: { f: "and then what" } }));
    });

    console.log("ready ran");
});