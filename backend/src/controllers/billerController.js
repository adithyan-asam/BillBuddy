const Biller = require('../models/biller');

const getBillers = async (req, res) => {
  try {
    const billers = await Biller.find();

    res.status(200).json({
      success: true,
      data: billers,
    });
  } catch (error) {
    console.error('Error fetching billers:', error);

    res.status(500).json({
      success: false,
      message: 'Failed to fetch billers.',
    });
  }
};

module.exports = {
  getBillers,
};