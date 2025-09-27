import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/app_state.dart';
import '../models/location.dart';
import '../models/cuisine.dart';
import '../widgets/cuisine_selector.dart';
import '../widgets/success_dialog.dart';

class BanquetFormScreen extends StatefulWidget {
  const BanquetFormScreen({Key? key}) : super(key: key);

  @override
  State<BanquetFormScreen> createState() => _BanquetFormScreenState();
}

class _BanquetFormScreenState extends State<BanquetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form fields
  String? _selectedEventType;
  Location? _selectedCountry;
  Location? _selectedState;
  Location? _selectedCity;
  List<DateTime> _eventDates = [];
  final _adultsController = TextEditingController();
  String _cateringPreference = 'veg';
  List<String> _selectedCuisines = [];
  final _budgetController = TextEditingController();
  String _getOfferWithin = '24 hours';
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _adultsController.dispose();
    _budgetController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final appState = context.read<AppState>();
    appState.fetchEventTypes();
    appState.fetchCountries();
    appState.fetchCuisines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2), // Bluish background
      appBar: AppBar(
        title: const Text(
          'Banquets & Venues',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tell Us Your Venue Requirements',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildEventTypeField(appState),
                          const SizedBox(height: 16),

                          _buildLocationFields(appState),
                          const SizedBox(height: 16),

                          _buildEventDatesField(),
                          const SizedBox(height: 16),

                          _buildNumberOfAdultsField(),
                          const SizedBox(height: 16),

                          _buildCateringPreferenceField(),
                          const SizedBox(height: 16),

                          _buildCuisineSelectionField(appState),
                          const SizedBox(height: 16),

                          _buildBudgetField(),
                          const SizedBox(height: 16),

                          _buildGetOfferWithinField(),
                          const SizedBox(height: 16),

                          _buildNotesField(),
                          const SizedBox(height: 80), // Extra space for FAB
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Consumer<AppState>(
        builder: (context, appState, child) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: appState.isSubmittingRequest ? null : _submitRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // More rounded
                ),
                elevation: 4,
              ),
              child: appState.isSubmittingRequest
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Submitting Request...'),
                      ],
                    )
                  : const Text(
                      'Submit Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildEventTypeField(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedEventType,
          decoration: InputDecoration(
            hintText: 'Select event type',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) =>
              value == null ? 'Please select an event type' : null,
          items: appState.eventTypes.map((eventType) {
            return DropdownMenuItem<String>(
              value: eventType,
              child: Text(eventType),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEventType = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildLocationFields(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country
        const Text(
          'Country',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Location>(
          value: _selectedCountry,
          decoration: InputDecoration(
            hintText: 'Select country',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) =>
              value == null ? 'Please select a country' : null,
          items: appState.countries.map((country) {
            return DropdownMenuItem<Location>(
              value: country,
              child: Text(country.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
              _selectedState = null;
              _selectedCity = null;
            });
            if (value != null) {
              appState.fetchStatesByCountry(value.id);
            }
          },
        ),

        const SizedBox(height: 16),

        // State
        const Text(
          'State',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Location>(
          value: _selectedState,
          decoration: InputDecoration(
            hintText:
                appState.isLoadingStates ? 'Loading states...' : 'Select state',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: appState.states.isEmpty
              ? []
              : appState.states.map((state) {
                  return DropdownMenuItem<Location>(
                    value: state,
                    child: Text(state.name),
                  );
                }).toList(),
          onChanged: (appState.states.isEmpty)
              ? null
              : (value) {
                  setState(() {
                    _selectedState = value;
                    _selectedCity = null;
                  });
                  if (value != null) {
                    appState.fetchCitiesByState(value.id);
                  }
                },
        ),

        const SizedBox(height: 16),

        // City
        const Text(
          'City',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Location>(
          value: _selectedCity,
          decoration: InputDecoration(
            hintText: 'Select city',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) => value == null ? 'Please select a city' : null,
          items: appState.cities.map((city) {
            return DropdownMenuItem<Location>(
              value: city,
              child: Text(city.name),
            );
          }).toList(),
          onChanged: _selectedState == null
              ? null
              : (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
        ),
      ],
    );
  }

  Widget _buildEventDatesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Dates',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_eventDates.isEmpty)
                const Text(
                  'No dates selected',
                  style: TextStyle(color: Colors.grey),
                )
              else
                ...(_eventDates.map((date) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy').format(date),
                            style: const TextStyle(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _eventDates.remove(date);
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ))),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectEventDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Add Date',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_eventDates.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Please select at least one event date',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildNumberOfAdultsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Adults',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _adultsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter number of adults',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter number of adults';
            }
            final number = int.tryParse(value);
            if (number == null || number < 1) {
              return 'Please enter a valid number (minimum 1)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCateringPreferenceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catering Preference',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _cateringPreference == 'veg'
                        ? Colors.green
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _cateringPreference == 'veg'
                      ? Colors.green[50]
                      : Colors.white,
                ),
                child: RadioListTile<String>(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Flexible(
                        child: Text(
                          'Veg',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  value: 'veg',
                  groupValue: _cateringPreference,
                  onChanged: (value) {
                    setState(() {
                      _cateringPreference = value!;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _cateringPreference == 'non-veg'
                        ? Colors.red
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _cateringPreference == 'non-veg'
                      ? Colors.red[50]
                      : Colors.white,
                ),
                child: RadioListTile<String>(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Flexible(
                        child: Text(
                          'Non-veg',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  value: 'non-veg',
                  groupValue: _cateringPreference,
                  onChanged: (value) {
                    setState(() {
                      _cateringPreference = value!;
                    });
                  },
                  activeColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCuisineSelectionField(AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Please select your Cuisines',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        if (appState.cuisines.isNotEmpty)
          CuisineSelector(
            cuisines: appState.cuisines,
            selectedCuisines: _selectedCuisines,
            onSelectionChanged: (selected) {
              setState(() {
                _selectedCuisines = selected;
              });
            },
          )
        else
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildBudgetField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                color: Colors.grey[100],
              ),
              child: const Text(
                'INR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter budget amount',
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter budget amount';
                  }
                  final number = double.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGetOfferWithinField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get offer within (optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _getOfferWithin,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: const [
            DropdownMenuItem(value: '24 hours', child: Text('24 hours')),
            DropdownMenuItem(value: '48 hours', child: Text('48 hours')),
            DropdownMenuItem(value: '72 hours', child: Text('72 hours')),
            DropdownMenuItem(value: '1 week', child: Text('1 week')),
          ],
          onChanged: (value) {
            setState(() {
              _getOfferWithin = value!;
            });
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Normal response time is within 2 days',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes (optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Any special requirements or additional information...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Future<void> _selectEventDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      // Check if date is already selected
      bool alreadySelected = _eventDates.any((date) =>
          date.year == picked.year &&
          date.month == picked.month &&
          date.day == picked.day);

      if (!alreadySelected) {
        setState(() {
          _eventDates.add(picked);
          _eventDates.sort(); // Keep dates sorted
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This date is already selected'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_eventDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one event date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedCuisines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one cuisine'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final requestData = {
      'eventType': _selectedEventType,
      'location': {
        'country': _selectedCountry!.name,
        'state': _selectedState!.name,
        'city': _selectedCity!.name,
      },
      'eventDates': _eventDates.map((date) => date.toIso8601String()).toList(),
      'numberOfAdults': int.parse(_adultsController.text),
      'cateringPreference': _cateringPreference,
      'cuisines': _selectedCuisines,
      'budget': {
        'amount': double.parse(_budgetController.text),
        'currency': 'INR',
      },
      'getOfferWithin': _getOfferWithin,
      'notes': _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    };

    final appState = context.read<AppState>();
    final response = await appState.submitRequest(requestData);

    if (response != null && response['success']) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SuccessDialog(
            requestId: response['data']['requestId'],
            onClose: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to home
            },
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appState.error ?? 'Failed to submit request'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
