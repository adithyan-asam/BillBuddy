const SavedBiller = require('../models/savedBiller');

const addSavedBiller = async (req, res) => {
  try {
    const { billerId, nickname, fields } = req.body;

    if (!billerId || !nickname || !fields) {
      return res.status(400).json({
        success: false,
        message: 'Biller ID, nickname and fields are required.',
      });
    }

    const savedBiller = await SavedBiller.create({
      userId: req.userId,
      billerId,
      nickname,
      fields,
    });

    return res.status(201).json({
      success: true,
      data: savedBiller,
    });
  } catch (error) {
    console.error('Error adding saved biller:', error);

    return res.status(500).json({
      success: false,
      message: 'Failed to add biller.',
    });
  }
};

const getSavedBillers = async (req, res) => {
  try {
    const savedBillers = await SavedBiller.find({
      userId: req.userId,
    });

    return res.status(200).json({
      success: true,
      data: savedBillers,
    });
  } catch (error) {
    console.error('Error fetching saved billers:', error);

    return res.status(500).json({
      success: false,
      message: 'Failed to fetch saved billers.',
    });
  }
};

module.exports = {
  addSavedBiller,
  getSavedBillers,
};