"use strict";

const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });

function heartbeat() { this.isAlive = true; }

const parseMsg = (msg) => {
  try {
    return JSON.parse(msg);
  }catch(e) {
    console.log(e);
    return {};
  }
};

const sendMsgToChannel = (msg, channel, sender) => {
  wss.clients.forEach(ws => {
    if(ws.channels.includes(channel)) {
      ws.send(JSON.stringify({event: 'MSG',source:sender, target: channel, data: msg}));
    }
  });
};

const sendMsgToClient = (msg, nick, sender) => {
  // client.some + return true ?
  wss.clients.forEach(ws => {
    if(ws.nick === nick) {
      ws.send(JSON.stringify({event: 'PM',source:sender, data: msg}));
    }
  });
};

const sendMsg = (destination) => {
  if(destination.startsWith('#')) {
    return sendMsgToChannel;
  } else {
    return sendMsgToClient;
  }
};

const getChannels = () => {
  let channels = [];
  wss.clients.forEach(ws => {
    channels = channels.concat(ws.channels);
  });
  return [...new Set(channels)];
};

const getChannelMembers = (channel) => {
  let nicks = [];
  wss.clients.forEach(ws => {
    if(ws.channels.includes(channel)){
      nicks.push(ws.nick);
    }
  });
  return nicks;
}

function handleMessage(message) {
  var client = this;
  console.log(typeof message);
  var msg = parseMsg(message);
  console.log(message, msg);
  switch(msg.event) {
    case 'NICK':
      client.nick = msg.data;
    break;
    case 'JOIN':
      client.channels.push(msg.target);
    break;
    case 'PART':
      client.channels = client.channels.filter(c => c !== msg.target);
    break;
    case 'MSG':
      sendMsg(msg.target)(msg.data, msg.target, client.nick);
    break;
    case 'LISTCHAN':
      let channels = getChannels();
      client.send(JSON.stringify({event: 'CHANNELS', data:channels}));
      break;
    case 'LISTNICKS':
      let nicks = getChannelMembers(msg.target);
      client.send(JSON.stringify({event: 'NICKS', target: msg.target, data: nicks}));
      break;
    default:
      console.log(`Unknown event ${msg.event}`);
      break;
  }
}

wss.on('connection', function connection(ws) {
  ws.on('message', handleMessage);
  ws.isAlive = true;
  ws.channels = [];
  ws.on('pong', heartbeat);

  ws.send(JSON.stringify({event: 'MSG', data:'something'}));
});

setInterval(function ping() {
  wss.clients.forEach(function each(ws) {
    if (ws.isAlive === false) {return ws.terminate();}

    ws.isAlive = false;
    ws.ping('', false, true);
  });
}, 30000);