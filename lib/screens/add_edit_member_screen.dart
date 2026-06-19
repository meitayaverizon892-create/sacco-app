import 'package:flutter/material.dart';
import '../models/member.dart';
import '../database/db_helper.dart';
import '../services/auth_service.dart';

class AddEditMemberScreen extends StatefulWidget {
  final Member? member;

  const AddEditMemberScreen({super.key, this.member});

  @override
  State<AddEditMemberScreen> createState() => _AddEditMemberScreenState();
}

class _AddEditMemberScreenState extends State<AddEditMemberScreen> {
  final _nameController = TextEditingController();
  final _memberNumberController = TextEditingController();
  final _savingsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  bool get isEditing => widget.member != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.member!.name;
      _memberNumberController.text = widget.member!.memberNumber;
      _savingsController.text = widget.member!.savings.toString();
      _phoneController.text = widget.member!.phone;
    }
  }

  Future<void> _saveMember() async {
    if (_nameController.text.isEmpty ||
        _memberNumberController.text.isEmpty ||
        _savingsController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Password is required when registering a new member,
    // optional when editing (leave blank to keep the current password)
    if (!isEditing && _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set a password for this member'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String? passwordHash = _passwordController.text.isNotEmpty
        ? AuthService.hashPassword(_passwordController.text)
        : (isEditing ? widget.member!.passwordHash : null);

    final member = Member(
      id: isEditing ? widget.member!.id : null,
      name: _nameController.text,
      memberNumber: _memberNumberController.text,
      savings: double.tryParse(_savingsController.text) ?? 0,
      phone: _phoneController.text,
      passwordHash: passwordHash,
    );

    if (isEditing) {
      await DBHelper.updateMember(member);
    } else {
      await DBHelper.insertMember(member);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Member updated' : 'Member added'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isEditing ? 'Edit Member' : 'Add Member',
                    style: const TextStyle(
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
                  const Text('Full Name',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C5E))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Full Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon:
                          const Icon(Icons.person, color: Color(0xFF1A3C5E)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Member Number',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C5E))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _memberNumberController,
                    decoration: InputDecoration(
                      hintText: 'e.g. 006',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon:
                          const Icon(Icons.badge, color: Color(0xFF1A3C5E)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Savings (KSH)',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C5E))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _savingsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Savings Amount',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon: const Icon(Icons.attach_money,
                          color: Color(0xFF1A3C5E)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Phone Number',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C5E))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'e.g. 0712345678',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon:
                          const Icon(Icons.phone, color: Color(0xFF1A3C5E)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isEditing
                        ? 'Password (leave blank to keep unchanged)'
                        : 'Set Password',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3C5E)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: isEditing
                          ? 'Leave blank to keep current password'
                          : 'Enter Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                      ),
                      prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFF1A3C5E)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF1A3C5E),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveMember,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A3C5E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'UPDATE MEMBER' : 'SAVE MEMBER',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
