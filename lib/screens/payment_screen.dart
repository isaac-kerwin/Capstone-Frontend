import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: const Center(
        child: Text(
          'Payment form will go here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
