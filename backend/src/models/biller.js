const mongoose = require('mongoose');

const billerFieldSchema = new mongoose.Schema(
  {
    key: {
      type: String,
      required: true,
    },

    label: {
      type: String,
      required: true,
    },

    regex: {
      type: String,
      required: true,
    },
  },
  {
    _id: false,
  }
);

const billerSchema = new mongoose.Schema(
  {
    id: {
      type: String,
      required: true,
      unique: true,
    },

    name: {
      type: String,
      required: true,
    },

    category: {
      type: String,
      required: true,
      enum: [
        'electricity',
        'water',
        'gas',
        'broadband',
        'mobile',
        'dth',
        'creditCard',
      ],
    },

    state: {
      type: String,
      required: true,
    },

    fields: {
      type: [billerFieldSchema],
      required: true,
    },

    allowsPartial: {
      type: Boolean,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model('Biller', billerSchema);