const express = require("express");
const {
  getCountries,
  getStatesByCountry,
  getCitiesByState,
} = require("../controllers/locationController");

const router = express.Router();

// GET /api/locations/countries - Get all countries
router.get("/countries", getCountries);

// GET /api/locations/states/:countryId - Get states by country
router.get("/states/:countryId", getStatesByCountry);

// GET /api/locations/cities/:stateId - Get cities by state
router.get("/cities/:stateId", getCitiesByState);

module.exports = router;
