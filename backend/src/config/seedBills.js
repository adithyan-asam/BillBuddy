require('dotenv').config();

const mongoose = require('mongoose');

const connectDB = require('./db');
const SavedBiller = require('../models/savedBiller');
const Bill = require('../models/bill');

const seedBills = async () => {
  try {
    await connectDB();

    const savedBillers = await SavedBiller.find();

    if (savedBillers.length === 0) {
      console.log('No saved billers found. Add a biller first.');
      process.exit(0);
    }

    await Bill.deleteMany();

    const bills = savedBillers.map((savedBiller) => ({
      savedBillerId: savedBiller._id,
      amount: 1240,
      dueDate: new Date('2026-09-28'),
      billingPeriod: 'August 2026'  ,
      isDue: true,
    }));

    await Bill.insertMany(bills);

    console.log(`${bills.length} bills seeded successfully.`);

    await mongoose.connection.close();
  } catch (error) {
    console.error('Error seeding bills:', error);
    process.exit(1);
  }
};

seedBills();