import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TicketManagementPage extends StatefulWidget {
  const TicketManagementPage({super.key});

  @override
  State<TicketManagementPage> createState() => _TicketManagementPageState();
}

class _TicketManagementPageState extends State<TicketManagementPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  String? _selectedType;

  final List<Map<String, String>> _ticketList = [];

  final List<String> _ticketTypes = [
    'Adult',
    'Child',
    'Student',
    'Senior',
    'VIP',
  ];

  void _addTicket() {
    if (_selectedType != null &&
        _priceController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      setState(() {
        _ticketList.add({
          'type': _selectedType!,
          'price': _priceController.text,
          'quantity': _quantityController.text,
          'discount': _discountController.text.isEmpty ? '0' : _discountController.text,
        });

        _selectedType = null;
        _priceController.clear();
        _quantityController.clear();
        _discountController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
    }
  }

  void _removeTicket(int index) {
    setState(() {
      _ticketList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Management'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFCF7FF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Edit Ticket Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                items: _ticketTypes
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                decoration: const InputDecoration(
                  labelText: 'Edit Price (\$)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Edit Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Edit Discount (%) - Optional',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A55FF),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Ticket',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ticketList.length,
                itemBuilder: (context, index) {
                  final ticket = _ticketList[index];
                  return Card(
                    color: const Color(0xFFF5F0FF),
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text('${ticket['type']} - \$${ticket['price']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Qty: ${ticket['quantity']} • Discount: ${ticket['discount']}%'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTicket(index),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
