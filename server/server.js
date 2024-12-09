const express = require('express');
const { createServer } = require('http');
const authRoutes = require('./services/auth');
const websocketService = require('./services/chat');

const app = express();
const PORT = 3000;

app.use(express.json());

app.use('/auth', authRoutes);

const server = createServer(app);

websocketService(server);

server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
