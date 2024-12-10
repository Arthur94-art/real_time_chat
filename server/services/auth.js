const express = require('express');
const router = express.Router();

const users = new Map(); 

router.post('/login', (req, res) => {
  try {
    const { username } = req.body;

    if (!username) {
      return res.status(400).json({
        success: false,
        message: 'Username is required',
      });
    }

    const token = `auth_token_${username}`;
    users.set(token, username);

    return res.status(200).json({
      success: true,
      token,
    });
  } catch (error) {
    console.error('Login error:', error);

    return res.status(500).json({
      success: false,
      message: 'Internal server error',
    });
  }
});

module.exports = router;
