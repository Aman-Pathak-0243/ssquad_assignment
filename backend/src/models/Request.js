const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const requestSchema = new mongoose.Schema(
  {
    requestId: {
      type: String,
      default: () =>
        `REQ-${Date.now()}-${Math.random()
          .toString(36)
          .substr(2, 6)
          .toUpperCase()}`,
      unique: true,
    },
    eventType: {
      type: String,
      required: true,
      enum: ["Wedding", "Anniversary", "Corporate event", "Other Party"],
    },
    location: {
      country: {
        type: String,
        required: true,
      },
      state: {
        type: String,
        required: true,
      },
      city: {
        type: String,
        required: true,
      },
    },
    eventDates: [
      {
        type: Date,
        required: true,
      },
    ],
    numberOfAdults: {
      type: Number,
      required: true,
      min: 1,
    },
    cateringPreference: {
      type: String,
      enum: ["veg", "non-veg"],
      required: true,
    },
    cuisines: [
      {
        type: String,
        enum: ["Indian", "Italian", "Asian", "Mexican"],
      },
    ],
    budget: {
      amount: {
        type: Number,
        required: true,
      },
      currency: {
        type: String,
        default: "INR",
      },
    },
    getOfferWithin: {
      type: String,
      enum: ["24 hours", "48 hours", "72 hours", "1 week"],
      default: "24 hours",
    },
    notes: {
      type: String,
      trim: true,
    },
    uploadedImages: [
      {
        filename: String,
        originalName: String,
        path: String,
        size: Number,
      },
    ],
    status: {
      type: String,
      enum: ["pending", "processing", "completed", "cancelled"],
      default: "pending",
    },
  },
  {
    timestamps: true,
  }
);

// Index for faster queries
requestSchema.index({ requestId: 1 });
requestSchema.index({ createdAt: -1 });
requestSchema.index({ status: 1 });

module.exports = mongoose.model("Request", requestSchema);
