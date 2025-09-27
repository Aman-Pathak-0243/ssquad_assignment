const mongoose = require("mongoose");

const locationSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    type: {
      type: String,
      enum: ["country", "state", "city"],
      required: true,
    },
    code: {
      type: String,
      trim: true,
    },
    parentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Location",
      default: null,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// Index for faster queries
locationSchema.index({ type: 1, parentId: 1 });
locationSchema.index({ name: 1, type: 1 });

module.exports = mongoose.model("Location", locationSchema);
