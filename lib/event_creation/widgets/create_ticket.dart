import 'package:first_app/fundamental_widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/tickets.dart';

class CreateTicketDialog extends StatefulWidget {
  final DateTime salesStart;
  final DateTime salesEnd;

  const CreateTicketDialog({
    super.key,
    required this.salesStart,
    required this.salesEnd,
  });

  @override
  State<CreateTicketDialog> createState() => _CreateTicketDialogState();
}

class _CreateTicketDialogState extends State<CreateTicketDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();


  String? _ticketNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter ticket name';
    }
    return null;
  } 

  String? _descriptionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter description';
    }
    return null;
  }

  String? _priceValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter price';
    }
    if (double.tryParse(value.trim()) == null) {
      return 'Enter a valid number';
    }
    return null;
  }

  String? _quantityValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter quantity';
    }
    if (int.tryParse(value.trim()) == null) {
      return 'Enter a valid integer';
    }
    return null;
  }

  _createTicketDTO(){
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();
    String price = _priceController.text.trim();
    String quantity = _quantityController.text.trim();
    
    return TicketDTO(
      name: name,
      description: description,
      price: double.parse(price),
      quantityTotal: int.parse(quantity),
      salesStart: widget.salesStart,
      salesEnd: widget.salesEnd,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Ticket'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ticket Name
              buildTextField(label: "name", validator: _ticketNameValidator, controller: _nameController,),
              const SizedBox(height: 8),
              // Description
              buildTextField(label: "description", validator: _descriptionValidator, controller: _descriptionController),
              const SizedBox(height: 8),
              // Price
              buildTextField(label: "price", validator: _priceValidator, controller: _priceController, isNumber: true),
              const SizedBox(height: 8),
              // Quantity
              buildTextField(label: "quantity", validator: _quantityValidator, controller: _quantityController, isNumber: true),
              const SizedBox(height: 8),  
            ],
          ),
        ),
      ),
      actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cancel
            },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 24.0), 
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState!.save();
              final ticket = _createTicketDTO();
              Navigator.pop(context, ticket);
            }
          },
          child: const Text('Create'),
        ),
      ],
    ),
  ],
);
  }
}