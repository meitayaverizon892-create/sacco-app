import 'package:flutter/material.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _durationController = TextEditingController();
  final _guarantorController = TextEditingController();

  void _submitLoan() {
    if (_amountController.text.isEmpty ||
        _purposeController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _guarantorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loan Application Submitted Successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              color: const Color(0xFF1A3C5E),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Apply for Loan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Loan Amount
                  const Text(
                    'Loan Amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C5E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Amount',
                      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: Color(0xFF1A3C5E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Loan Purpose
                  const Text(
                    'Loan Purpose',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C5E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _purposeController,
                    decoration: InputDecoration(
                      hintText: 'Enter Purpose',
                      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon: const Icon(
                        Icons.description,
                        color: Color(0xFF1A3C5E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Loan Duration
                  const Text(
                    'Loan Duration',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C5E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Months',
                      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon: const Icon(
                        Icons.calendar_month,
                        color: Color(0xFF1A3C5E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Guarantor Name
                  const Text(
                    'Guarantor Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3C5E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _guarantorController,
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF1A3C5E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitLoan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A3C5E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'SUBMIT LOAN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Terms
                  const Center(
                    child: Text(
                      '⚠️ Terms and conditions apply',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
