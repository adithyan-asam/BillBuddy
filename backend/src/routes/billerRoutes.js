const express = require('express');

const {
  getBillers,
} = require('../controllers/billerController');

const router = express.Router();

router.get('/', getBillers);

module.exports = router;