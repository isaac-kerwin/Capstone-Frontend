import 'package:flutter/material.dart';

typedef ConfirmAction = void Function();
typedef SendEmailAction = void Function();

/// A tile widget displaying registration details with an optional confirm button.
class RegistrationTile extends StatelessWidget {
  final String registrationId;
  final String primaryParticipantName;
  final int numberOfAttendees;
  final double totalAmountPaid;
  final String status;
  final ConfirmAction? onConfirm;
  final SendEmailAction? onSendEmail;

  const RegistrationTile({
    Key? key,
    required this.registrationId,
    required this.primaryParticipantName,
    required this.numberOfAttendees,
    required this.totalAmountPaid,
    required this.status,
    this.onConfirm,
    this.onSendEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text('Registration #$registrationId'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Primary: $primaryParticipantName'),
            Text('Attendees: $numberOfAttendees'),
            Text('Total Paid: ${totalAmountPaid.toStringAsFixed(2)}'),
            Text('Status: $status'),
          ],
        ),
        trailing: (onConfirm != null || onSendEmail != null)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onConfirm != null)
                    ElevatedButton(
                      onPressed: onConfirm,
                      child: const Text('Confirm'),
                    ),
                  if (onSendEmail != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        onPressed: onSendEmail,
                        child: const Text('Send Confirmation Email'),
                      ),
                    ),
                ],
              )
            : null,
      ),
    );
  }
}
