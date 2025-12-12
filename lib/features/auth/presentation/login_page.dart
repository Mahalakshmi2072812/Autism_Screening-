import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../animations/animation_utils.dart';
import '../../../assets/assets_paths.dart';
import '../../../core/presentation/gradient_background.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/morphic/glass_card.dart';
import '../../../widgets/morphic/morphic_button.dart';
import '../../../widgets/safe_lottie.dart';
import '../../home/presentation/home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } on FirebaseAuthException catch (e) {
      final message = e.message ?? 'Login failed';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login failed')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
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
                            'Welcome back',
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Colors.white, // required for ShaderMask
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
                          'Sign in to continue the நெற்றிக்கண் questionnaire.',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeSlide(
                        delay: const Duration(milliseconds: 180),
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
                        delay: const Duration(milliseconds: 220),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeSlide(
                        delay: const Duration(milliseconds: 260),
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
                                    : const Text('Login'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeSlide(
                        delay: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed:
                                  _isSubmitting
                                      ? null
                                      : () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          RegisterPage.routeName,
                                        );
                                      },
                              child: const Text('Create a new account'),
                            ),
                            const SizedBox(height: 8),
                            // Text(
                            //   'or continue with',
                            //   style: Theme.of(context).textTheme.bodySmall,
                            // ),
                            // const SizedBox(height: 8),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: OutlinedButton(
                            //         onPressed: _isSubmitting
                            //             ? null
                            //             : () {
                            //                 ScaffoldMessenger.of(context)
                            //                     .showSnackBar(
                            //                   const SnackBar(
                            //                     content: Text(
                            //                       'Social sign-in coming soon',
                            //                     ),
                            //                   ),
                            //                 );
                            //               },
                            //         child: const Text('Google'),
                            //       ),
                            //     ),
                            //     const SizedBox(width: 8),
                            //     Expanded(
                            //       child: OutlinedButton(
                            //         onPressed: _isSubmitting
                            //             ? null
                            //             : () {
                            //                 ScaffoldMessenger.of(context)
                            //                     .showSnackBar(
                            //                   const SnackBar(
                            //                     content: Text(
                            //                       'Social sign-in coming soon',
                            //                     ),
                            //                   ),
                            //                 );
                            //               },
                            //         child: const Text('Apple'),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
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
