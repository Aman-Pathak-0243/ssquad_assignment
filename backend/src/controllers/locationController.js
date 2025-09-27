const Location = require("../models/Location");

// @desc    Get all countries
// @route   GET /api/locations/countries
// @access  Public
const getCountries = async (req, res, next) => {
  try {
    const countries = await Location.find({
      type: "country",
      isActive: true,
    })
      .sort({ name: 1 })
      .select("-__v");

    res.json({
      success: true,
      count: countries.length,
      data: countries,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get states by country
// @route   GET /api/locations/states/:countryId
// @access  Public
const getStatesByCountry = async (req, res, next) => {
  try {
    const { countryId } = req.params;

    const states = await Location.find({
      type: "state",
      parentId: countryId,
      isActive: true,
    })
      .sort({ name: 1 })
      .select("-__v");

    res.json({
      success: true,
      count: states.length,
      data: states,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get cities by state
// @route   GET /api/locations/cities/:stateId
// @access  Public
const getCitiesByState = async (req, res, next) => {
  try {
    const { stateId } = req.params;

    const cities = await Location.find({
      type: "city",
      parentId: stateId,
      isActive: true,
    })
      .sort({ name: 1 })
      .select("-__v");

    res.json({
      success: true,
      count: cities.length,
      data: cities,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getCountries,
  getStatesByCountry,
  getCitiesByState,
};
