import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../animations/animation_utils.dart';
import '../../../assets/assets_paths.dart';
import '../../../core/presentation/gradient_background.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/morphic/glass_card.dart';
import '../../../widgets/morphic/morphic_button.dart';
import '../../../widgets/safe_lottie.dart';
import '../../home/presentation/home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  DateTime? _selectedDob;
  String? _selectedSex;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _guardianNameController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      final credential = await auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final user = credential.user;

      if (user != null) {
        final fullName =
            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                .trim();
        await firestore.collection('users').doc(user.uid).set({
          'name': fullName,
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': user.email,
          'dateOfBirth': _selectedDob,
          'sex': _selectedSex,
          'guardianName': _guardianNameController.text.trim(),
          'contactNumber': _contactNumberController.text.trim(),
          'address': _addressController.text.trim(),
          'createdAt': DateTime.now().toUtc(),
        });
      }

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } on FirebaseAuthException catch (e) {
      final message = e.message ?? 'Registration failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration failed')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate =
        _selectedDob ?? DateTime(now.year - 3, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(title: 'நெற்றிக்கண்'), 


      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GlassCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const FadeSlide(
                        offset: Offset(0, 18),
                        child: SafeLottie(
                          asset: AppIcons.appLogo,
                          height: 140,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeSlide(
                        delay: const Duration(milliseconds: 80),
                        child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF8F94FB),
                            Color(0xFF4E54C8),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        child: Text(
                          'Create account',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.white, // required for shader mask
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      ),
                      const SizedBox(height: 6),
                      FadeSlide(
                        delay: const Duration(milliseconds: 140),
                        child: Text(
                          'Set up an account so you can complete and review screenings.',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeSlide(
                        delay: const Duration(milliseconds: 180),
                        child: TextFormField(
                          controller: _firstNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'First name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 210),
                        child: TextFormField(
                          controller: _lastNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter last name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 230),
                        child: TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Date of birth',
                            hintText: 'Select date of birth',
                          ),
                          onTap: _pickDateOfBirth,
                          validator: (value) {
                            if (_selectedDob == null) {
                              return 'Please select date of birth';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 250),
                        child: DropdownButtonFormField<String>(
                          value: _selectedSex,
                          decoration: const InputDecoration(labelText: 'Sex'),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                            // DropdownMenuItem(
                            //   value: 'Other',
                            //   child: Text('Other'),
                            // ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSex = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select sex';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 270),
                        child: TextFormField(
                          controller: _guardianNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Guardian name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter guardian name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 290),
                        child: TextFormField(
                          controller: _contactNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Contact number',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter contact number';
                            }
                            if (value.trim().length < 7) {
                              return 'Please enter a valid contact number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 310),
                        child: TextFormField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 330),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 350),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeSlide(
                        delay: const Duration(milliseconds: 380),
                        child: SizedBox(
                          width: double.infinity,
                          child: MorphicButton(
                            onPressed: _isSubmitting ? () {} : _submit,
                            child:
                                _isSubmitting
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                    : const Text('Register'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 410),
                        child: TextButton(
                          onPressed:
                              _isSubmitting
                                  ? null
                                  : () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      LoginPage.routeName,
                                    );
                                  },
                          child: const Text('Already have an account? Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
