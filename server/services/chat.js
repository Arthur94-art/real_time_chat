const WebSocket = require('ws');

const ONLINE_DELAY_MS = 2000; 
const OFFLINE_DELAY_MS = 2000; 
const RANDOM_MESSAGE_INTERVAL_MS = 20000; 
const USER_ONLINE_DELAY_MS = 1000; 

function websocketService(server) {
  const wss = new WebSocket.Server({ server });

  console.log('WebSocket server is running');

  wss.on('connection', (ws) => {
    console.log('New client connected');
    let intervalId;
    let isProcessing = false; 

    setTimeout(() => {
      sendOnlineStatus(ws);
      setTimeout(() => {
        sendRandomMessage(ws);
        setTimeout(() => {
          sendOfflineStatus(ws);
          startRandomMessageCycle(ws);
        }, OFFLINE_DELAY_MS);
      }, ONLINE_DELAY_MS);
    }, ONLINE_DELAY_MS);

    ws.on('message', (message) => {
      console.log(`Received from client: ${message}`);

      try {
        const parsedMessage = JSON.parse(message);
        if (parsedMessage.message) {
          console.log(`User message: ${parsedMessage.message}`);

          ws.send(
            JSON.stringify({
              type: 'client',
              text: parsedMessage.message,
              timestamp: new Date().toISOString(),
            })
          );

          setTimeout(() => {
            sendOnlineStatus(ws);
            setTimeout(() => {
              ws.send(
                JSON.stringify({
                  type: 'server',
                  text: `This is answer on your sms: ${parsedMessage.message}`,
                  timestamp: new Date().toISOString(),
                })
              );
              setTimeout(() => {
                sendOfflineStatus(ws);
                resetRandomMessageCycle(ws);
              }, OFFLINE_DELAY_MS);
            }, ONLINE_DELAY_MS);
          }, USER_ONLINE_DELAY_MS);
        }
      } catch (e) {
        console.error('Error parsing message:', e);
      }
    });

    ws.on('close', () => {
      console.log('Client disconnected');
      clearInterval(intervalId);
    });

    function resetRandomMessageCycle(ws) {
      clearInterval(intervalId); 
      startRandomMessageCycle(ws); 
    }

    function startRandomMessageCycle(ws) {
      intervalId = setInterval(() => {
        if (!isProcessing) {
          isProcessing = true;

          sendOnlineStatus(ws);

          setTimeout(() => {
            sendRandomMessage(ws);

            setTimeout(() => {
              sendOfflineStatus(ws);
              isProcessing = false;
            }, OFFLINE_DELAY_MS);
          }, ONLINE_DELAY_MS);
        }
      }, RANDOM_MESSAGE_INTERVAL_MS);
    }

    function sendOnlineStatus(ws) {
      const lastOnline = new Date().toISOString();
      const statusMessage = {
        status: 'online',
        lastOnline,
      };
      ws.send(JSON.stringify(statusMessage));
      console.log(`Sent online status: ${JSON.stringify(statusMessage)}`);
    }

    function sendOfflineStatus(ws) {
      const lastOnline = new Date().toISOString();
      const statusMessage = {
        status: 'offline',
        lastOnline,
      };
      ws.send(JSON.stringify(statusMessage));
      console.log(`Sent offline status: ${JSON.stringify(statusMessage)}`);
    }

    function sendRandomMessage(ws) {
      const randomMessages = [
        'Hello from server!',
        'Random server message.',
        'How are you today?',
        'Keep up the great work!',
        'This is another random message.',
      ];
      const randomText =
        randomMessages[Math.floor(Math.random() * randomMessages.length)];
      const randomMessage = {
        type: 'server',
        text: randomText,
        timestamp: new Date().toISOString(),
      };
      ws.send(JSON.stringify(randomMessage));
      console.log(`Sent random message: ${JSON.stringify(randomMessage)}`);
    }
  });
}

module.exports = websocketService;