import 'package:flutter/foundation.dart';
import '../models/category.dart' as models;
import '../models/location.dart';
import '../models/cuisine.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService;

  AppState({required ApiService apiService}) : _apiService = apiService;

  // Loading states
  bool _isLoadingCategories = false;
  bool _isLoadingCountries = false;
  bool _isLoadingStates = false;
  bool _isLoadingCities = false;
  bool _isLoadingEventTypes = false;
  bool _isLoadingCuisines = false;
  bool _isSubmittingRequest = false;

  // Data
  List<models.Category> _categories = [];
  List<Location> _countries = [];
  List<Location> _states = [];
  List<Location> _cities = [];
  List<String> _eventTypes = [];
  List<Cuisine> _cuisines = [];

  // Error states
  String? _error;

  // Getters
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingCountries => _isLoadingCountries;
  bool get isLoadingStates => _isLoadingStates;
  bool get isLoadingCities => _isLoadingCities;
  bool get isLoadingEventTypes => _isLoadingEventTypes;
  bool get isLoadingCuisines => _isLoadingCuisines;
  bool get isSubmittingRequest => _isSubmittingRequest;

  List<models.Category> get categories => _categories;
  List<Location> get countries => _countries;
  List<Location> get states => _states;
  List<Location> get cities => _cities;
  List<String> get eventTypes => _eventTypes;
  List<Cuisine> get cuisines => _cuisines;

  String? get error => _error;

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // Fetch countries
  Future<void> fetchCountries() async {
    _isLoadingCountries = true;
    _error = null;
    notifyListeners();

    try {
      _countries = await _apiService.getCountries();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingCountries = false;
      notifyListeners();
    }
  }

  // Fetch states by country
  Future<void> fetchStatesByCountry(String countryId) async {
    _isLoadingStates = true;
    _error = null;
    _states = []; // Clear existing states
    _cities = []; // Clear cities when country changes
    notifyListeners();

    try {
      _states = await _apiService.getStatesByCountry(countryId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingStates = false;
      notifyListeners();
    }
  }

  // Fetch cities by state
  Future<void> fetchCitiesByState(String stateId) async {
    _isLoadingCities = true;
    _error = null;
    _cities = []; // Clear existing cities
    notifyListeners();

    try {
      _cities = await _apiService.getCitiesByState(stateId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingCities = false;
      notifyListeners();
    }
  }

  // Fetch event types
  Future<void> fetchEventTypes() async {
    _isLoadingEventTypes = true;
    _error = null;
    notifyListeners();

    try {
      _eventTypes = await _apiService.getEventTypes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingEventTypes = false;
      notifyListeners();
    }
  }

  // Fetch cuisines
  Future<void> fetchCuisines() async {
    _isLoadingCuisines = true;
    _error = null;
    notifyListeners();

    try {
      _cuisines = await _apiService.getCuisines();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingCuisines = false;
      notifyListeners();
    }
  }

  // Submit request
  Future<Map<String, dynamic>?> submitRequest(
    Map<String, dynamic> requestData, {
    List<String> filePaths = const [],
  }) async {
    _isSubmittingRequest = true;
    _error = null;
    notifyListeners();

    try {
      Map<String, dynamic> response;
      if (filePaths.isNotEmpty) {
        response =
            await _apiService.submitRequestWithFiles(requestData, filePaths);
      } else {
        response = await _apiService.submitRequest(requestData);
      }
      return response;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isSubmittingRequest = false;
      notifyListeners();
    }
  }

  // Reset location data
  void resetLocationData() {
    _countries = [];
    _states = [];
    _cities = [];
    notifyListeners();
  }
}
