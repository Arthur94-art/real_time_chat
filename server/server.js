const WebSocket = require('ws');

const PORT = 8080; 
const INTERVAL_MS = 1 * 60 * 1000; 

const wss = new WebSocket.Server({ port: PORT });

console.log(`WebSocket server is running on ws://localhost:${PORT}`);

wss.on('connection', (ws) => {
  console.log('New client connected');

  const intervalId = setInterval(() => {
    const randomMessages = [
      "Hello from server!",
      "Random server message.",
      "How are you today?",
      "Keep up the great work!",
      "This is another random message.",
    ];

    const randomMessage =
      randomMessages[Math.floor(Math.random() * randomMessages.length)];
    const randomNumber = Math.floor(Math.random() * 1000) + 1;

    const message = {
      id: randomNumber, 
      text: randomMessage,
      timestamp: new Date().toISOString(),
    };

    ws.send(JSON.stringify(message));
    console.log(`Sent message: ${JSON.stringify(message)}`);
  }, INTERVAL_MS);

  ws.on('close', () => {
    console.log('Client disconnected');
    clearInterval(intervalId);
  });

  ws.on('message', (message) => {
    console.log(`Received from client: ${message}`);
  });
});
