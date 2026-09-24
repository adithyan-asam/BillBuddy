const mongoose = require('mongoose');

const savedBillerSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },

    billerId: {
      type: String,
      required: true,
    },

    nickname: {
      type: String,
      required: true,
      trim: true,
    },

    fields: {
      type: Map,
      of: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model(
  'SavedBiller',
  savedBillerSchema
);