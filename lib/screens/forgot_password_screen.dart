import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Şifre sıfırlama bağlantısı gönderildi.',
          ),
          backgroundColor: Color(0xFFC9A995),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            28,
            20,
            28,
            28,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                // Geri butonu
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

                const SizedBox(height: 12),

                // Logo
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

                const SizedBox(height: 50),

                // Başlık
                const Text(
                  'Şifrenizi mi unuttunuz?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF383431),
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'E-posta adresinizi girin.\n'
                  'Size şifrenizi yenilemeniz için bir bağlantı gönderelim.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8B827B),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // E-posta
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(
                    hintText: 'E-posta adresiniz',

                    hintStyle: const TextStyle(
                      color: Color(0xFFB0A69E),
                      fontSize: 12,
                    ),

                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      size: 18,
                      color: Color(0xFF796C64),
                    ),

                    filled: true,
                    fillColor: const Color(0xFFFBF9F5),

                    contentPadding:
                        const EdgeInsets.symmetric(
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

                const SizedBox(height: 24),

                // Link gönder
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _sendResetLink,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9A995),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'Şifre Sıfırlama Linki Gönder',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login'e dön
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

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}