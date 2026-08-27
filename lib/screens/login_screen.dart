import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            28,
            20,
            28,
            28,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // LOGO

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

              const SizedBox(height: 24),

              // ÜRÜN GÖRSELİ

              ClipRRect(
                borderRadius: BorderRadius.circular(14),

                child: AspectRatio(
                  aspectRatio: 4 / 3,

                  child: Image.asset(
                    'assets/tablo.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // BAŞLIK

              const Text(
                'Hoş Geldiniz',
                style: TextStyle(
                  color: Color(0xFF383431),
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Hesabınıza giriş yapın',
                style: TextStyle(
                  color: Color(0xFF8B827B),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 22),

              // E-POSTA

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,

                decoration: _inputDecoration(
                  hintText: 'E-posta adresiniz',
                  icon: Icons.mail_outline,
                ),
              ),

              const SizedBox(height: 12),

              // ŞİFRE

              TextField(
                controller: _passwordController,

                obscureText: !_passwordVisible,

                keyboardType: TextInputType.visiblePassword,

                textInputAction: TextInputAction.done,

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
              ),

              const SizedBox(height: 2),

              // ŞİFREMİ UNUTTUM

              Align(
                alignment: Alignment.centerRight,

                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            const ForgotPasswordScreen(),
                      ),
                    );
                  },

                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),

                    minimumSize: Size.zero,

                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),

                  child: const Text(
                    'Şifremi unuttum',

                    style: TextStyle(
                      color: Color(0xFFA9826E),
                      fontSize: 10,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // GİRİŞ YAP

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            const HomeScreen(),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFC9A995),

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    'Giriş Yap',

                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // KAYIT OL

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  const Text(
                    'Hesabınız yok mu? ',

                    style: TextStyle(
                      color: Color(0xFF8B827B),
                      fontSize: 11,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              const RegisterScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'Kayıt ol',

                      style: TextStyle(
                        color: Color(0xFFA9826E),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
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
    );
  }
}