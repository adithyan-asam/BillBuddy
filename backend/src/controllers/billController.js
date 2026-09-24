const Bill = require('../models/bill');
const SavedBiller = require('../models/savedBiller');

const getBill = async (req, res) => {
  try {
    const { savedBillerId } = req.params;

    const savedBiller = await SavedBiller.findOne({
      _id: savedBillerId,
      userId: req.userId,
    });

    if (!savedBiller) {
      return res.status(404).json({
        success: false,
        message: 'Saved biller not found.',
      });
    }

    const bill = await Bill.findOne({
      savedBillerId,
    });

    return res.status(200).json({
      success: true,
      data: bill,
    });
  } catch (error) {
    console.error('Error fetching bill:', error);

    return res.status(500).json({
      success: false,
      message: 'Failed to fetch bill.',
    });
  }
};

module.exports = {
  getBill,
};