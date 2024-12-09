const express = require('express');
const router = express.Router();

const users = new Map();

router.post('/login', (req, res) => {
  const { username } = req.body;

  if (!username) {
    return res.status(400).json({ success: false, message: 'Username is required' });
  }

  const token = `auth_token_${username}`;
  users.set(token, username);

  res.json({ success: true, token });
});

module.exports = router;
