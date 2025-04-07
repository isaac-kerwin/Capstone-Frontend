import 'package:flutter/material.dart';

class RegistrationFormGenerator extends StatelessWidget {
  const RegistrationFormGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _receiveEmailUpdates = false;
  bool _isSubmitting = false;
  bool _isGroupRegistration = false;
  int _groupSize = 1;
  final List<Map<String, TextEditingController>> _controllers = [];
  // This list will store the registration type for each member.
  List<String> _selectedTypes = [];

  final List<String> _fieldNames = [
    'First Name',
    'Last Name',
    'Email Address',
    'Phone Number',
    'Time Slot',
    'Allergies / Dietary Requirements',
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _controllers.clear();
    _selectedTypes.clear();
    for (int i = 0; i < _groupSize; i++) {
      _controllers.add({
        'firstname': TextEditingController(),
        'lastname': TextEditingController(),
        'email': TextEditingController(),
        'phone': TextEditingController(),
        'timeslot': TextEditingController(),
        'allergies': TextEditingController(),
      });
      // Set default registration type to "Adult" for each member.
      _selectedTypes.add('Adult');
    }
  }

  // Calculate the total price based on each member's type.
  int getTotalPrice() {
    int total = 0;
    for (String type in _selectedTypes) {
      if (type == 'Adult') {
        total += 80;
      } else {
        total += 40; // 50% off for Senior and Minor
      }
    }
    return total;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      // Process form submission here (for example, send data to a server)
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildTextFormField(String field, int memberIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: _controllers[memberIndex][field.toLowerCase().replaceAll(' ', '')],
        decoration: InputDecoration(
          labelText: field,
          border: const OutlineInputBorder(),
        ),
        keyboardType: field == 'Phone Number'
            ? TextInputType.phone
            : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $field';
          }
          if (field == 'Phone Number' && !RegExp(r'^\d{10}$').hasMatch(value)) {
            return 'Enter valid phone number (10 digits)';
          }
          if (field == 'Email Address' &&
              !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                  .hasMatch(value)) {
            return 'Enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRegistrationTypeDropdown(int memberIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        value: _selectedTypes[memberIndex],
        items: ['Adult', 'Senior', 'Minor']
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedTypes[memberIndex] = value!;
          });
        },
        decoration: const InputDecoration(
          labelText: 'Registration Type',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register for Melbourne Italian Festa 2024"),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            SwitchListTile(
              title: const Text("Group Registration"),
              value: _isGroupRegistration,
              onChanged: (value) {
                setState(() {
                  _isGroupRegistration = value;
                  // Reset group size to 1 if group registration is disabled.
                  _groupSize = value ? _groupSize : 1;
                  _initializeControllers();
                });
              },
            ),
            if (_isGroupRegistration)
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of People in Group',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _groupSize = int.tryParse(value) ?? 1;
                    _initializeControllers();
                  });
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null ||
                      int.parse(value) < 1) {
                    return 'Enter a valid group size';
                  }
                  return null;
                },
              ),
            ...List.generate(_groupSize, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Member ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._fieldNames.map((field) => _buildTextFormField(field, index)),
                  _buildRegistrationTypeDropdown(index),
                  const SizedBox(height: 20),
                ],
              );
            }),
            // Display the total price based on the registration type for each member.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Total Price: \$${getTotalPrice()}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SwitchListTile(
              title: const Text('Receive Email Updates?'),
              value: _receiveEmailUpdates,
              onChanged: (value) {
                setState(() {
                  _receiveEmailUpdates = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 102, 89, 175),
                  foregroundColor: Colors.white,
                ),
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text('PROCEED TO PAYMENT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
