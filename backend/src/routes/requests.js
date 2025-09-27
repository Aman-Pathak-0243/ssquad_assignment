const express = require("express");
const { body } = require("express-validator");
const {
  createRequest,
  getEventTypes,
  getCuisines,
} = require("../controllers/requestController");
const { upload } = require("../middlewares/upload");

const router = express.Router();

// Validation rules for request creation
const requestValidation = [
  body("eventType")
    .isIn(["Wedding", "Anniversary", "Corporate event", "Other Party"])
    .withMessage("Invalid event type"),
  body("location.country").notEmpty().withMessage("Country is required"),
  body("location.state").notEmpty().withMessage("State is required"),
  body("location.city").notEmpty().withMessage("City is required"),
  body("eventDates")
    .isArray({ min: 1 })
    .withMessage("At least one event date is required"),
  body("numberOfAdults")
    .isInt({ min: 1 })
    .withMessage("Number of adults must be at least 1"),
  body("cateringPreference")
    .isIn(["veg", "non-veg"])
    .withMessage("Invalid catering preference"),
  body("cuisines").isArray().withMessage("Cuisines must be an array"),
  body("budget.amount")
    .isNumeric()
    .withMessage("Budget amount must be a number"),
];

// GET /api/requests/event-types - Get available event types
router.get("/event-types", getEventTypes);

// GET /api/requests/cuisines - Get available cuisines
router.get("/cuisines", getCuisines);

// POST /api/requests - Create new request with optional file uploads
router.post("/", upload.array("images", 10), requestValidation, createRequest);

module.exports = router;
