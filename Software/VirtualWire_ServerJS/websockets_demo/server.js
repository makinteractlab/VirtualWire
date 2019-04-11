"use strict";
process.title = 'WebSocket_Demo';

var webSocketsServerPort = 1337;
var webSocketServer = require('websocket').server;
var http = require('http');
var net = require('net');
var ARDUINO_PORT = 8080;
var ARDUINO_IP = '192.168.0.1';



// TCP client (communciate with Arduino)
var client = new net.Socket();
client.setEncoding('utf8');


// HTTP server
var server = http.createServer(function(request, response) {});

server.listen(webSocketsServerPort, function() {
    console.log((new Date()) + " Server is listening on port " +
        webSocketsServerPort);
});

// WebSocket server
var wsServer = new webSocketServer({
    httpServer: server
});


wsServer.on('request', function(request) {
    console.log((new Date()) + ' Connection from origin ' + request.origin + '.');
    var connection = request.accept(null, request.origin);
    console.log('Connection accepted.');


    client.connect(ARDUINO_PORT, ARDUINO_IP, function() {
        console.log("Connecting");
    });


    client.on('data', function(msg) {
        var json = JSON.stringify({
            type: 'message',
            data: msg
        });
        console.log("Receiving " + msg);
        connection.sendUTF(json);
    });

    client.on('close', function() {});


    // user sent some message
    connection.on('message', function(message) {
        if (message.type === 'utf8') {
            client.write(message.utf8Data + '\n');
        }
    });

    // user disconnected
    connection.on('close', function(connection) {
        console.log("Disconnected");
    });
});