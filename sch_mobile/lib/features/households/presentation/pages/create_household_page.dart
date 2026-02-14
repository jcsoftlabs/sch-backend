import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/services/location_service.dart';
import '../../data/models/household_model.dart';
import '../providers/households_provider.dart';

class CreateHouseholdPage extends ConsumerStatefulWidget {
  const CreateHouseholdPage({super.key});

  @override
  ConsumerState<CreateHouseholdPage> createState() =>
      _CreateHouseholdPageState();
}

class _CreateHouseholdPageState extends ConsumerState<CreateHouseholdPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationService = LocationService();

  // Form controllers
  final _householdHeadController = TextEditingController();
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _communeController = TextEditingController();
  final _phoneController = TextEditingController();

  // GPS data
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  String? _locationError;

  // Form data
  String? _housingType;
  int? _numberOfRooms;
  String? _waterSource;
  String? _sanitationType;
  bool _hasElectricity = false;

  @override
  void initState() {
    super.initState();
    _captureGPS();
  }

  @override
  void dispose() {
    _householdHeadController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _communeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _captureGPS() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentPosition = position;
          _isLoadingLocation = false;
        });
      } else {
        setState(() {
          _locationError = 'Impossible d\'obtenir la localisation';
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez activer le GPS pour continuer'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final household = HouseholdModel(
        householdHeadName: _householdHeadController.text.trim(),
        address: _addressController.text.trim(),
        neighborhood: _neighborhoodController.text.trim().isEmpty
            ? null
            : _neighborhoodController.text.trim(),
        commune: _communeController.text.trim().isEmpty
            ? null
            : _communeController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        gpsAccuracy: _currentPosition!.accuracy,
        housingType: _housingType,
        numberOfRooms: _numberOfRooms,
        waterSource: _waterSource,
        sanitationType: _sanitationType,
        hasElectricity: _hasElectricity,
        createdAt: DateTime.now(),
        isSynced: false,
      );

      await ref.read(householdsNotifierProvider.notifier).createHousehold(household);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ménage enregistré avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Ménage'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // GPS Status Card
            Card(
              color: _currentPosition != null
                  ? Colors.green[50]
                  : _locationError != null
                      ? Colors.red[50]
                      : Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _currentPosition != null
                              ? Icons.gps_fixed
                              : _locationError != null
                                  ? Icons.gps_off
                                  : Icons.gps_not_fixed,
                          color: _currentPosition != null
                              ? Colors.green
                              : _locationError != null
                                  ? Colors.red
                                  : Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _currentPosition != null
                                ? 'GPS capturé: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}'
                                : _locationError != null
                                    ? 'Erreur GPS: $_locationError'
                                    : 'Capture GPS en cours...',
                            style: TextStyle(
                              color: _currentPosition != null
                                  ? Colors.green[900]
                                  : _locationError != null
                                      ? Colors.red[900]
                                      : Colors.blue[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_isLoadingLocation) ...[
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(),
                    ],
                    if (_locationError != null) ...[
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _captureGPS,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Household Head Name
            TextFormField(
              controller: _householdHeadController,
              decoration: const InputDecoration(
                labelText: 'Nom du chef de ménage *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Address
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Neighborhood
            TextFormField(
              controller: _neighborhoodController,
              decoration: const InputDecoration(
                labelText: 'Quartier',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 16),

            // Commune
            TextFormField(
              controller: _communeController,
              decoration: const InputDecoration(
                labelText: 'Commune',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.map),
              ),
            ),
            const SizedBox(height: 16),

            // Phone
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            // Housing Type
            DropdownButtonFormField<String>(
              value: _housingType,
              decoration: const InputDecoration(
                labelText: 'Type de logement',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
              items: const [
                DropdownMenuItem(value: 'Maison', child: Text('Maison')),
                DropdownMenuItem(value: 'Appartement', child: Text('Appartement')),
                DropdownMenuItem(value: 'Cabane', child: Text('Cabane')),
                DropdownMenuItem(value: 'Autre', child: Text('Autre')),
              ],
              onChanged: (value) {
                setState(() {
                  _housingType = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Electricity
            SwitchListTile(
              title: const Text('Accès à l\'électricité'),
              value: _hasElectricity,
              onChanged: (value) {
                setState(() {
                  _hasElectricity = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Enregistrer le Ménage',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
