const { validationResult } = require("express-validator");
const Request = require("../models/Request");

// @desc    Get available event types
// @route   GET /api/requests/event-types
// @access  Public
const getEventTypes = async (req, res, next) => {
  try {
    const eventTypes = [
      "Wedding",
      "Anniversary",
      "Corporate event",
      "Other Party",
    ];

    res.json({
      success: true,
      data: eventTypes,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get available cuisines
// @route   GET /api/requests/cuisines
// @access  Public
const getCuisines = async (req, res, next) => {
  try {
    const cuisines = [
      {
        name: "Indian",
        image:
          "https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300&h=200&fit=crop",
      },
      {
        name: "Italian",
        image:
          "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=300&h=200&fit=crop",
      },
      {
        name: "Asian",
        image:
          "https://images.unsplash.com/photo-1617093727343-374698b1b08d?w=300&h=200&fit=crop",
      },
      {
        name: "Mexican",
        image:
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop",
      },
    ];

    res.json({
      success: true,
      data: cuisines,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Create new request
// @route   POST /api/requests
// @access  Public
const createRequest = async (req, res, next) => {
  try {
    // Check validation errors
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: "Validation failed",
        errors: errors.array(),
      });
    }

    const {
      eventType,
      location,
      eventDates,
      numberOfAdults,
      cateringPreference,
      cuisines,
      budget,
      getOfferWithin,
      notes,
    } = req.body;

    // Process uploaded files
    const uploadedImages = [];
    if (req.files && req.files.length > 0) {
      req.files.forEach((file) => {
        uploadedImages.push({
          filename: file.filename,
          originalName: file.originalname,
          path: file.path,
          size: file.size,
        });
      });
    }

    // Create new request
    const newRequest = new Request({
      eventType,
      location,
      eventDates: eventDates.map((date) => new Date(date)),
      numberOfAdults: parseInt(numberOfAdults),
      cateringPreference,
      cuisines: Array.isArray(cuisines) ? cuisines : [cuisines],
      budget: {
        amount: parseFloat(budget.amount),
        currency: budget.currency || "INR",
      },
      getOfferWithin: getOfferWithin || "24 hours",
      notes,
      uploadedImages,
    });

    const savedRequest = await newRequest.save();

    res.status(201).json({
      success: true,
      message: "Request submitted successfully",
      data: {
        requestId: savedRequest.requestId,
        status: savedRequest.status,
        createdAt: savedRequest.createdAt,
      },
    });
  } catch (error) {
    // If there was an error and files were uploaded, clean them up
    if (req.files && req.files.length > 0) {
      const fs = require("fs");
      req.files.forEach((file) => {
        try {
          fs.unlinkSync(file.path);
        } catch (unlinkError) {
          console.error("Error deleting uploaded file:", unlinkError);
        }
      });
    }

    next(error);
  }
};

module.exports = {
  getEventTypes,
  getCuisines,
  createRequest,
};
