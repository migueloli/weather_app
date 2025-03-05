import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    required this.currentLanguage,
    required this.onLanguageChanged,
    super.key,
  });

  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  static const _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'pt', 'name': 'Português'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          _languages.map((language) {
            final isSelected = language['code'] == currentLanguage;

            return RadioListTile<String>(
              title: Text(language['name']!),
              value: language['code']!,
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  onLanguageChanged(value);
                }
              },
              activeColor: Theme.of(context).primaryColor,
              selected: isSelected,
              dense: true,
            );
          }).toList(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('currentLanguage', currentLanguage));
    properties.add(
      ObjectFlagProperty<ValueChanged<String>>.has(
        'onLanguageChanged',
        onLanguageChanged,
      ),
    );
  }
}
