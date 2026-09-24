const mongoose = require('mongoose');
const connectDB = require('./db');
const Biller = require('../models/biller');
require('dotenv').config();

const billers = [
  {
    id: 'electricity_001',
    name: 'Maharashtra Electricity Board',
    category: 'electricity',
    state: 'Maharashtra',
    fields: [
      {
        key: 'consumerNumber',
        label: 'Consumer Number',
        regex: '^\\d{10}$',
      },
    ],
    allowsPartial: true,
  },

  {
    id: 'water_001',
    name: 'Mumbai Water Supply',
    category: 'water',
    state: 'Maharashtra',
    fields: [
      {
        key: 'consumerNumber',
        label: 'Consumer Number',
        regex: '^\\d{8}$',
      },
    ],
    allowsPartial: false,
  },

  {
    id: 'gas_001',
    name: 'Mahanagar Gas',
    category: 'gas',
    state: 'Maharashtra',
    fields: [
      {
        key: 'customerNumber',
        label: 'Customer Number',
        regex: '^\\d{10}$',
      },
    ],
    allowsPartial: false,
  },

  {
    id: 'broadband_001',
    name: 'JioFiber',
    category: 'broadband',
    state: 'All India',
    fields: [
      {
        key: 'accountNumber',
        label: 'Account Number',
        regex: '^\\d{10}$',
      },
    ],
    allowsPartial: true,
  },

  {
    id: 'mobile_001',
    name: 'Airtel',
    category: 'mobile',
    state: 'All India',
    fields: [
      {
        key: 'mobileNumber',
        label: 'Mobile Number',
        regex: '^[6-9]\\d{9}$',
      },
    ],
    allowsPartial: false,
  },

  {
    id: 'dth_001',
    name: 'Tata Play',
    category: 'dth',
    state: 'All India',
    fields: [
      {
        key: 'subscriberId',
        label: 'Subscriber ID',
        regex: '^\\d{10}$',
      },
    ],
    allowsPartial: false,
  },

  {
    id: 'credit_card_001',
    name: 'ICICI Credit Card',
    category: 'creditCard',
    state: 'All India',
    fields: [
      {
        key: 'cardNumber',
        label: 'Card Number',
        regex: '^\\d{16}$',
      },
    ],
    allowsPartial: true,
  },
];

const seedBillers = async () => {
  try {
    await connectDB();

    await Biller.deleteMany({});

    await Biller.insertMany(billers);

    console.log('Billers seeded successfully.');

    await mongoose.connection.close();
  } catch (error) {
    console.error('Error seeding billers:', error);
    await mongoose.connection.close();
    process.exit(1);
  }
};

seedBillers();

module.exports = seedBillers;