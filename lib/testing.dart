// import 'package:flutter/material.dart';

// class CustomDropdownScreen extends StatefulWidget {
//   const CustomDropdownScreen({super.key});

//   @override
//   _CustomDropdownScreenState createState() => _CustomDropdownScreenState();
// }

// class _CustomDropdownScreenState extends State<CustomDropdownScreen> {
//   String? _selectedValue;
//   final List<String> _dropdownItems = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Custom Dropdown Button'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _selectedValue,
//               hint: const Text(
//                 'Select an item',
//                 style: TextStyle(color: Colors.blue),
//               ),
//               items: _dropdownItems.map((String item) {
//                 return DropdownMenuItem<String>(
//                   value: item,
//                   child: CustomDropdownItem(item: item),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedValue = newValue;
//                 });
//               },
//               icon: const Icon(
//                 Icons.arrow_drop_down,
//                 color: Colors.blue,
//               ),
//               dropdownColor: Colors.white,
//               style: const TextStyle(
//                 color: Colors.blue,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CustomDropdownItem extends StatelessWidget {
//   final String item;

//   const CustomDropdownItem({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blue),
//         borderRadius: BorderRadius.circular(5),
//         color: Colors.blue.withOpacity(0.1),
//       ),
//       child: Text(
//         item,
//         style: const TextStyle(
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }
// }

