const express = require('express');
const { v4: uuidv4 } = require('uuid'); 
const router = express.Router();

let userIdCounter = 1; 
const users = new Map(); 

router.post('/login', (req, res) => {
  try {
    const { username } = req.body;

    // Перевірка: чи передано username
    if (!username || username.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Username is required',
      });
    }

    const id = userIdCounter++;
    const token = uuidv4();

    users.set(token, { id, username });

    return res.status(200).json({
      success: true,
      id,
      username,
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
