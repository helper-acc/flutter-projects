import 'package:flutter/material.dart';

class GenderDropdownMenu extends StatefulWidget {
  const GenderDropdownMenu({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  State<StatefulWidget> createState() => _GenderDropdownMenuState();
}

class _GenderDropdownMenuState extends State<GenderDropdownMenu> {
  final List<Map<String, String>> dropdownItems = const[
    {'gender': 'Чоловік', 'color': 'blue'},
    {'gender': 'Жінка', 'color': 'pink'},
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: widget.controller.text.isEmpty
          ? 'Чоловік' : widget.controller.text,
      requestFocusOnTap: false,
      controller: widget.controller,
      label: const Text('Стать'),
      onSelected: (String? value) {
        setState(() {
          selectedValue = value;
        });
      },
      dropdownMenuEntries:
      dropdownItems.map<DropdownMenuEntry<String>>((item) {
        return DropdownMenuEntry<String>(
          value: item['gender']!,
          label: item['gender']!,
          style: MenuItemButton.styleFrom(
            foregroundColor: item['color'] == 'blue'
                ? Colors.blue : Colors.pink,
          ),
        );
      }).toList(),
    );
  }
}
