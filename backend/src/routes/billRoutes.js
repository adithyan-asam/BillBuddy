const express = require('express');

const { getBill } = require('../controllers/billController');

const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

router.get(
  '/:savedBillerId/bill',
  authMiddleware,
  getBill
);

module.exports = router;