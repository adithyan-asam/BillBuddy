const authRoutes = require('./src/routes/authRoutes');
const billerRoutes = require('./src/routes/billerRoutes');
const savedBillerRoutes = require('./src/routes/savedBillerRoutes');
const billRoutes = require('./src/routes/billRoutes');

require('dotenv').config();

const express = require('express');
const cors = require('cors');

const connectDatabase = require('./src/config/db');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/billers', billerRoutes);
app.use('/api/my-billers', savedBillerRoutes);
app.use('/api/my-billers', billRoutes);

app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'BillBuddy backend is running',
  });
});

const PORT = process.env.PORT || 5000;

const startServer = async () => {
  await connectDatabase();

  app.listen(PORT, () => {
    console.log(`BillBuddy backend running on port ${PORT}`);
  });
};

startServer();