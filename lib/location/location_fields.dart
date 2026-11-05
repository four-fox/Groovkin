import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/location/location_contract.dart';
import 'package:groovkin/location/location_controller.dart';

LocationAvailabilityController ensureLocationController() {
  if (Get.isRegistered<LocationAvailabilityController>()) {
    return Get.find<LocationAvailabilityController>();
  }
  return Get.put(LocationAvailabilityController(), permanent: true);
}

class LocationFields extends StatefulWidget {
  const LocationFields({super.key});

  @override
  State<LocationFields> createState() => _LocationFieldsState();
}

class _LocationFieldsState extends State<LocationFields> {
  late final LocationAvailabilityController _location;

  @override
  void initState() {
    super.initState();
    _location = ensureLocationController();
    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();
      if (_location.draft.postalCode.isEmpty &&
          auth.zipController.text.trim().isNotEmpty) {
        _location.applySaved(
          countryName: auth.countryController.text,
          stateName: auth.stateController.text,
          postalCode: auth.zipController.text,
          city: _location.draft.city,
          countryCode: _location.draft.countryCode,
          stateCode: _location.draft.stateCode,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationAvailabilityController>(
      builder: (location) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dropdown<LocationPlace>(
              context: context,
              label: 'Country',
              value: _selected(location.countries, location.draft.countryCode),
              items: location.countries,
              itemLabel: (place) => place.name,
              enabled: !location.loadingCountries,
              error: location.fieldErrorTarget == 'country'
                  ? location.fieldError
                  : null,
              onChanged: (value) {
                location.selectCountry(value);
              },
            ),
            if (location.loadingCountries)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            if (location.catalogsFailed) ...[
              _hint(
                context,
                'Location lists could not be loaded. You can continue and try again.',
              ),
              TextButton(
                onPressed: location.loadCountries,
                child: Text(
                  'Reload places',
                  style: poppinsRegularStyle(
                    context: context,
                    fontSize: 12,
                    color: DynamicColor.lightRedClr,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            _dropdown<LocationPlace>(
              context: context,
              label: 'State',
              value: _selected(location.states, location.draft.stateCode),
              items: location.states,
              itemLabel: (place) => place.name,
              enabled: location.draft.countryCode != null &&
                  !location.loadingStates,
              error: location.fieldErrorTarget == 'state'
                  ? location.fieldError
                  : null,
              onChanged: (value) {
                location.selectState(value);
              },
            ),
            if (location.cities.isNotEmpty) ...[
              const SizedBox(height: 15),
              _dropdown<String>(
                context: context,
                label: 'City',
                value: location.cities.contains(location.draft.city)
                    ? location.draft.city
                    : null,
                items: location.cities,
                itemLabel: (city) => city,
                enabled: !location.loadingCities,
                error: location.fieldErrorTarget == 'city'
                    ? location.fieldError
                    : null,
                onChanged: location.selectCity,
              ),
            ],
            const SizedBox(height: 15),
            TextFormField(
              controller: location.postalController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 \-]')),
              ],
              onChanged: location.setPostal,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
              decoration: _decoration(
                context,
                'ZIP / postal code',
                error: location.fieldErrorTarget == 'postal'
                    ? location.fieldError
                    : null,
              ),
              validator: (value) {
                if (!location.catalogsReady) return null;
                if (normalizePostal(value ?? '').isEmpty) {
                  return 'Enter your ZIP or postal code.';
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  LocationPlace? _selected(List<LocationPlace> places, String? code) {
    for (final place in places) {
      if (place.code == code) return place;
    }
    return null;
  }

  Widget _hint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: poppinsRegularStyle(
          context: context,
          fontSize: 12,
          color: DynamicColor.grayClr,
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required BuildContext context,
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T item) itemLabel,
    required bool enabled,
    required ValueChanged<T?> onChanged,
    String? error,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel(item),
                overflow: TextOverflow.ellipsis,
                style: poppinsRegularStyle(
                  context: context,
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
      decoration: _decoration(context, label, error: error),
      hint: Text(
        label,
        style: poppinsRegularStyle(
          context: context,
          fontSize: 14,
          color: DynamicColor.grayClr,
        ),
      ),
    );
  }

  InputDecoration _decoration(BuildContext context, String label, {String? error}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          BorderSide(color: DynamicColor.grayClr.withValues(alpha: 0.6)),
    );
    return InputDecoration(
      labelText: label,
      errorText: error,
      labelStyle: poppinsRegularStyle(
        context: context,
        fontSize: 14,
        color: DynamicColor.grayClr,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: border,
    );
  }
}
