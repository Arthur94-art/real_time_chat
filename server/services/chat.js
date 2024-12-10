const WebSocket = require('ws');

const INTERVAL_MS = 1 * 60 * 1000; 
const ONLINE_DELAY_MS = 2000; 
const OFFLINE_DELAY_MS = 1000; 

function websocketService(server) {
  const wss = new WebSocket.Server({ server });

  console.log('WebSocket server is running');

  wss.on('connection', (ws) => {
    console.log('New client connected');
    let intervalId;
    let isTyping = false;
    let lastOnline = null;

    setTimeout(() => {
      sendMessage(ws, "Hello! Welcome to the server!");
      setOnline(ws);
    }, 1000);

    ws.on('message', (message) => {
      console.log(`Received from client: ${message}`);
      isTyping = true;

      sendMessage(ws, `You said: ${message}`);
      setOnline(ws);

      if (intervalId) clearInterval(intervalId);
      startInterval();
    });

    function startInterval() {
      intervalId = setInterval(() => {
        if (!isTyping) {
          sendMessage(ws, getRandomMessage());
          setOnline(ws);
        }
      }, INTERVAL_MS);
    }

    startInterval();

    ws.on('close', () => {
      console.log('Client disconnected');
      clearInterval(intervalId);
    });

    function sendMessage(ws, text) {
      setTimeout(() => {
        const message = {
          text,
          timestamp: new Date().toISOString(),
        };
        ws.send(JSON.stringify(message));
        console.log(`Sent message: ${JSON.stringify(message)}`);

        setTimeout(() => {
          setOffline(ws);
        }, OFFLINE_DELAY_MS);
      }, ONLINE_DELAY_MS);
    }

    function setOnline(ws) {
      lastOnline = new Date().toISOString();
      ws.send(JSON.stringify({ status: "online", lastOnline}));
      console.log('Server is online');
    }

    function setOffline(ws) {
      lastOnline = new Date().toISOString();
      ws.send(JSON.stringify({ status: "offline", lastOnline }));
      console.log(`Server is offline. Last online at: ${lastOnline}`);
    }

    function getRandomMessage() {
      const randomMessages = [
        "Hello from server!",
        "Random server message.",
        "How are you today?",
        "Keep up the great work!",
        "This is another random message.",
      ];
      return randomMessages[Math.floor(Math.random() * randomMessages.length)];
    }
  });
}

module.exports = websocketService;
