const express = require('express');

const {
  addSavedBiller,
  getSavedBillers,
} = require('../controllers/savedBillerController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/', authMiddleware, getSavedBillers);

router.post('/', authMiddleware, addSavedBiller);

module.exports = router;