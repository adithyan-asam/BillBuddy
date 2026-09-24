const mongoose = require('mongoose');

const billSchema = new mongoose.Schema(
  {
    savedBillerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'SavedBiller',
      required: true,
    },
    amount: {
      type: Number,
      required: true,
    },
    dueDate: {
      type: Date,
      required: true,
    },
    billingPeriod: {
      type: String,
      required: true,
    },
    isDue: {
      type: Boolean,
      required: true,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Bill', billSchema);