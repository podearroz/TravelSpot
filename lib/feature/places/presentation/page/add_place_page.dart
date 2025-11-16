import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:travelspot/core/di/application_container.dart';
import 'package:travelspot/core/services/supabase_service.dart';
import 'package:travelspot/core/theme/app_theme.dart';
import 'package:travelspot/feature/places/domain/entity/place_type.dart';
import 'package:travelspot/generated/l10n/app_localizations.dart';
import 'package:travelspot/feature/places/domain/entity/cuisine.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_bloc.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_event.dart';
import 'package:travelspot/feature/places/presentation/bloc/places_state.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:travelspot/feature/auth/presentation/bloc/auth_state.dart';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final deviceInfoPlugin = DeviceInfoPlugin();

  XFile? _imageFile;
  bool _isUploading = false;

  PlaceType? _selectedPlaceType;
  List<Cuisine> _selectedCuisines = [];
  List<PlaceType> _placeTypes = [];
  List<Cuisine> _availableCuisines = [];

  @override
  void initState() {
    super.initState();
    // Carregar tipos de lugar e culinárias
    context.read<PlacesBloc>().add(LoadPlaceTypesEvent());
    context.read<PlacesBloc>().add(LoadCuisinesEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addPlace),
        actions: [
          BlocBuilder<PlacesBloc, PlacesState>(
            builder: (context, state) {
              final isLoading = state is PlacesLoadingState;
              return TextButton(
                onPressed: isLoading ? null : _savePlace,
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(AppLocalizations.of(context).save),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<PlacesBloc, PlacesState>(
        listener: (context, state) {
          if (state is PlaceAddedState) {
            // Recarregar a lista de places na tela anterior
            context.read<PlacesBloc>().add(LoadPlacesEvent());

            final palette = AppTheme.paletteOf(Theme.of(context));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context).placeAddedSuccess),
                backgroundColor: palette.success(),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is PlacesErrorState) {
            final palette = AppTheme.paletteOf(Theme.of(context));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context).errorPrefix(state.message)),
                backgroundColor: palette.error(),
              ),
            );
          } else if (state is PlacesLoadedState) {
            setState(() {
              _placeTypes = state.placeTypes;
              _availableCuisines = state.cuisines;
            });
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImagePicker(),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context).placeName} *',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context).placeNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).description,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<PlaceType>(
                    value: _selectedPlaceType,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).placeType,
                      border: const OutlineInputBorder(),
                    ),
                    items: _placeTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (type) {
                      setState(() {
                        _selectedPlaceType = type;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context).address} *',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context).addressRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              AppTheme.paletteOf(Theme.of(context)).border()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context).coordinatesOptional,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _latitudeController,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context).latitude,
                                  border: const OutlineInputBorder(),
                                  hintText: AppLocalizations.of(context)
                                      .latitudeExample,
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _longitudeController,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context).longitude,
                                  border: const OutlineInputBorder(),
                                  hintText: AppLocalizations.of(context)
                                      .longitudeExample,
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _selectLocationOnMap,
                            icon: const Icon(Icons.map, size: 18),
                            label:
                                Text(AppLocalizations.of(context).selectOnMap),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).cuisineTypes,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _availableCuisines.map((cuisine) {
                      final isSelected = _selectedCuisines.contains(cuisine);
                      return FilterChip(
                        label: Text(cuisine.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCuisines.add(cuisine);
                            } else {
                              _selectedCuisines.remove(cuisine);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    final palette = AppTheme.paletteOf(Theme.of(context));
    return Center(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: palette.background(),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.border()),
            ),
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_imageFile!.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: palette.textSecondary(),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _pickAndCropImage,
            icon: const Icon(Icons.image),
            label: Text(AppLocalizations.of(context).selectImage),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndCropImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context).gallery),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(AppLocalizations.of(context).camera),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        print('Nenhuma imagem selecionada');
        return;
      }

      print('Imagem selecionada: ${pickedFile.path}');

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: AppLocalizations.of(context).cropImage,
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
          ),
          IOSUiSettings(
            title: AppLocalizations.of(context).cropImage,
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        print('Imagem recortada: ${croppedFile.path}');
        setState(() {
          _imageFile = XFile(croppedFile.path);
        });
      } else {
        print('Crop cancelado pelo usuário');
      }
    } catch (e, stackTrace) {
      print('ERRO ao selecionar/recortar imagem: $e');
      print('Stack trace: $stackTrace');
      
      if (!mounted) return;
      final palette = AppTheme.paletteOf(Theme.of(context));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).imageProcessingError(e.toString())),
          backgroundColor: palette.error(),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _savePlace() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String? imageUrl;
    if (_imageFile != null) {
      try {
        final bytes = await _imageFile!.readAsBytes();
        final fileName = _imageFile!.name;
        final supabaseService = ApplicationContainer.resolve<SupabaseService>();
        imageUrl = await supabaseService.uploadPlaceImage(bytes, fileName);
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        final palette = AppTheme.paletteOf(Theme.of(context));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context).uploadImageError(e.toString())),
            backgroundColor: palette.error(),
          ),
        );
        return;
      }
    }

    // Pegar ID do usuário logado
    String? userId;
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    }

    // Usar BLoC para salvar o lugar
    context.read<PlacesBloc>().add(AddPlaceEvent(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
          latitude: _latitudeController.text.trim().isEmpty
              ? null
              : double.tryParse(_latitudeController.text.trim()),
          longitude: _longitudeController.text.trim().isEmpty
              ? null
              : double.tryParse(_longitudeController.text.trim()),
          placeTypeId: _selectedPlaceType?.id,
          cuisineIds: _selectedCuisines.map((c) => c.id).toList(),
          ownerId: userId,
          imageUrl: imageUrl,
        ));

    setState(() {
      _isUploading = false;
    });
  }

  void _selectLocationOnMap() {
    // TODO: Implementar seleção de coordenadas no mapa
    // Sugestões de implementação:
    // 1. Adicionar dependência: google_maps_flutter: ^2.5.0
    // 2. Criar modal com mapa interativo
    // 3. Permitir ao usuário clicar para selecionar coordenadas
    // 4. Atualizar os controllers de latitude e longitude

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).coordinatesSelector),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map, size: 64, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              'Funcionalidade de mapa será implementada em breve!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Para implementar:\n'
              '• Adicionar google_maps_flutter ao pubspec.yaml\n'
              '• Configurar API Keys do Google Maps\n'
              '• Criar widget de seleção interativa',
              style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.paletteOf(Theme.of(context)).textSecondary()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).close),
          ),
          ElevatedButton(
            onPressed: () {
              // Exemplo de coordenadas (São Paulo)
              _latitudeController.text = '-23.5505';
              _longitudeController.text = '-46.6333';
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(AppLocalizations.of(context).exampleCoordinatesSet),
                ),
              );
            },
            child: Text(AppLocalizations.of(context).useExampleSP),
          ),
        ],
      ),
    );
  }
}
