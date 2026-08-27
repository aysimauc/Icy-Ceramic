import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Formumuzu kontrol etmek için kullanacağımız anahtar.
  final _formKey = GlobalKey<FormState>();

  // Kullanıcının girdiği şifreleri daha sonra karşılaştıracağız.
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    // Formdaki bütün validator'ları çalıştırır.
    if (_formKey.currentState!.validate()) {
      // Şimdilik backend yok.
      // Her şey doğruysa kullanıcıya başarılı mesajı gösteriyoruz.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kayıt başarılı!'),
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
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 24,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              children: [
                const SizedBox(height: 12),

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

                const SizedBox(height: 8),

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

                const SizedBox(height: 34),

                // Başlık
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

                // Ad Soyad
                TextFormField(
                  decoration: _inputDecoration(
                    hintText: 'Adınız Soyadınız',
                    icon: Icons.person_outline,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ad soyad alanı boş bırakılamaz.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // E-posta
                TextFormField(
                  keyboardType: TextInputType.emailAddress,

                  decoration: _inputDecoration(
                    hintText: 'E-posta adresiniz',
                    icon: Icons.mail_outline,
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'E-posta alanı boş bırakılamaz.';
                    }

                    if (!value.contains('@')) {
                      return 'Geçerli bir e-posta adresi girin.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // Şifre
                TextFormField(
                  controller: _passwordController,

                  obscureText: !_passwordVisible,

                  decoration: _inputDecoration(
                    hintText: 'Şifreniz',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
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

                // Şifre Tekrar
                TextFormField(
                  controller: _confirmPasswordController,

                  obscureText: !_confirmPasswordVisible,

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

                // Kayıt Ol
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _register,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC9A995),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      'Kayıt Ol',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login'e dön
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

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

  // Input tasarımını tek yerde tutuyoruz.
  // Böylece dört TextField için aynı kodu tekrar tekrar yazmıyoruz.
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