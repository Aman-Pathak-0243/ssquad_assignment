const express = require("express");
const { getCategories } = require("../controllers/categoryController");

const router = express.Router();

// GET /api/categories - Get all active categories
router.get("/", getCategories);

module.exports = router;
