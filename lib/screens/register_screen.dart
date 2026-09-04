import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2:5151/api/auth/register',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Kayıt başarılı! Giriş yapabilirsiniz.',
            ),
            backgroundColor: Color(0xFFC9A995),
          ),
        );

        await Future.delayed(
          const Duration(milliseconds: 700),
        );

        if (!mounted) {
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } else {
        String message =
            'Kayıt sırasında bir hata oluştu.';

        try {
          final data = jsonDecode(response.body);

          if (data is Map<String, dynamic>) {
            if (data['message'] != null) {
              message = data['message'].toString();
            }
          }
        } catch (_) {
          // API'den JSON dönmezse varsayılan mesajı kullan.
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF8B6F63),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sunucuya bağlanılamadı. Backend çalışıyor mu kontrol edin.',
          ),
          backgroundColor: Color(0xFF8B6F63),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: Color(0xFF66564E),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Icy',
                  style: TextStyle(
                    color: Color(0xFF66564E),
                    fontSize: 28,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'CERAMIC',
                  style: TextStyle(
                    color: Color(0xFF8B827B),
                    fontSize: 8,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 34),

                const Text(
                  'Hesap Oluştur',
                  style: TextStyle(
                    color: Color(0xFF383431),
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'ICY Ceramic ailesine katılın',
                  style: TextStyle(
                    color: Color(0xFF8B827B),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 28),

                // AD SOYAD
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    hintText: 'Adınız Soyadınız',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Ad soyad alanı boş bırakılamaz.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // E-POSTA
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    hintText: 'E-posta adresiniz',
                    icon: Icons.mail_outline,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'E-posta alanı boş bırakılamaz.';
                    }

                    if (!value.contains('@')) {
                      return 'Geçerli bir e-posta adresi girin.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // ŞİFRE
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    hintText: 'Şifreniz',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible =
                              !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: const Color(0xFF796C64),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre alanı boş bırakılamaz.';
                    }

                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // ŞİFRE TEKRAR
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  textInputAction: TextInputAction.done,
                  decoration: _inputDecoration(
                    hintText: 'Şifrenizi tekrar girin',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible =
                              !_confirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 18,
                        color: const Color(0xFF796C64),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifrenizi tekrar girin.';
                    }

                    if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // KAYIT OL
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFC9A995),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color(0xFFDCCFC5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Kayıt Ol',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // LOGIN'E DÖN
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Zaten hesabınız var mı? ',
                      style: TextStyle(
                        color: Color(0xFF8B827B),
                        fontSize: 11,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(
                          color: Color(0xFFA9826E),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFFB0A69E),
        fontSize: 12,
      ),
      prefixIcon: Icon(
        icon,
        size: 18,
        color: const Color(0xFF796C64),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFFBF9F5),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5DED4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFC9A995),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFB88A7A),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFB88A7A),
          width: 1.5,
        ),
      ),
    );
  }
}