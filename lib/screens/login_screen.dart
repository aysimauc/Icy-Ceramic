import 'package:flutter/material.dart';

import '../services/auth_api_service.dart';
import '../services/auth_session_service.dart';
import '../services/cart_service.dart';
import '../services/product_api_service.dart';

import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _login() async {
    final email =
        _emailController.text.trim();

    final password =
        _passwordController.text;

    if (email.isEmpty) {
      _showMessage(
        'Lütfen e-posta adresinizi girin.',
      );
      return;
    }

    if (password.isEmpty) {
      _showMessage(
        'Lütfen şifrenizi girin.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ----------------------------------------------------------
      // 1. API üzerinden giriş yap
      // ----------------------------------------------------------

      final result =
          await AuthApiService.login(
        email: email,
        password: password,
      );

      // ----------------------------------------------------------
      // 2. Kullanıcı oturumunu kaydet
      // ----------------------------------------------------------

      final userId =
          int.parse(
        result['userId'].toString(),
      );

      AuthSessionService.setUser(
        userId: userId,
        name:
            result['name']?.toString() ?? '',
        email:
            result['email']?.toString() ??
                email,
      );

      // ----------------------------------------------------------
      // 3. SQL Server'daki sepeti getir
      // ----------------------------------------------------------

      try {
        final products =
            await ProductApiService
                .getProducts();

        await CartService.loadFromApi(
          userId: userId,
          products: products,
        );
      } catch (cartError) {
        // Sepet yüklenemezse giriş tamamen
        // başarısız olmasın.
        //
        // Kullanıcı yine de uygulamaya
        // giriş yapabilsin.
        debugPrint(
          'Sepet yüklenemedi: $cartError',
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        result['message']?.toString() ??
            'Giriş başarılı.',
      );

      await Future.delayed(
        const Duration(
          milliseconds: 400,
        ),
      );

      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------
      // 4. Kullanıcı rolüne göre yönlendir
      // ----------------------------------------------------------

      final role =
          result['role']?.toString().trim().toLowerCase();

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const AdminDashboardScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      String message =
          e.toString();

      if (message.startsWith(
        'Exception: ',
      )) {
        message =
            message.substring(11);
      }

      _showMessage(message);
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              const Color(0xFF66564E),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
          duration:
              const Duration(
            seconds: 3,
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F4EE),
      resizeToAvoidBottomInset:
          true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            28,
            20,
            28,
            28,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              // ==================================================
              // LOGO
              // ==================================================

              const Text(
                'Icy',
                style: TextStyle(
                  color:
                      Color(0xFF66564E),
                  fontSize: 28,
                  fontStyle:
                      FontStyle.italic,
                  fontWeight:
                      FontWeight.w400,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(
                height: 2,
              ),

              const Text(
                'CERAMIC',
                style: TextStyle(
                  color:
                      Color(0xFF8B827B),
                  fontSize: 8,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // ==================================================
              // ÜRÜN GÖRSELİ
              // ==================================================

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.asset(
                    'assets/tablo.png',
                    width:
                        double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // ==================================================
              // BAŞLIK
              // ==================================================

              const Text(
                'Hoş Geldiniz',
                style: TextStyle(
                  color:
                      Color(0xFF383431),
                  fontSize: 25,
                  fontWeight:
                      FontWeight.w400,
                ),
              ),

              const SizedBox(
                height: 7,
              ),

              const Text(
                'Hesabınıza giriş yapın',
                style: TextStyle(
                  color:
                      Color(0xFF8B827B),
                  fontSize: 12,
                ),
              ),

              const SizedBox(
                height: 22,
              ),

              // ==================================================
              // E-POSTA
              // ==================================================

              TextField(
                controller:
                    _emailController,
                keyboardType:
                    TextInputType.emailAddress,
                decoration:
                    _inputDecoration(
                  hintText:
                      'E-posta adresiniz',
                  icon:
                      Icons.mail_outline,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================================
              // ŞİFRE
              // ==================================================

              TextField(
                controller:
                    _passwordController,
                obscureText:
                    !_passwordVisible,
                keyboardType:
                    TextInputType
                        .visiblePassword,
                textInputAction:
                    TextInputAction.done,
                onSubmitted: (_) {
                  if (!_isLoading) {
                    _login();
                  }
                },
                decoration:
                    _inputDecoration(
                  hintText:
                      'Şifreniz',
                  icon:
                      Icons.lock_outline,
                  suffixIcon:
                      IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible =
                            !_passwordVisible;
                      });
                    },
                    icon: Icon(
                      _passwordVisible
                          ? Icons
                              .visibility_outlined
                          : Icons
                              .visibility_off_outlined,
                      size: 18,
                      color:
                          const Color(
                        0xFF796C64,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 2,
              ),

              // ==================================================
              // ŞİFREMİ UNUTTUM
              // ==================================================

              Align(
                alignment:
                    Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  style:
                      TextButton.styleFrom(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    minimumSize:
                        Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize
                            .shrinkWrap,
                  ),
                  child:
                      const Text(
                    'Şifremi unuttum',
                    style:
                        TextStyle(
                      color:
                          Color(
                        0xFFA9826E,
                      ),
                      fontSize: 10,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================================
              // GİRİŞ YAP
              // ==================================================

              SizedBox(
                width:
                    double.infinity,
                height: 52,
                child:
                    ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : _login,
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        const Color(
                      0xFFC9A995,
                    ),
                    disabledBackgroundColor:
                        const Color(
                      0xFFD8C8BC,
                    ),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2,
                            valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                              Colors
                                  .white,
                            ),
                          ),
                        )
                      : const Text(
                          'Giriş Yap',
                          style:
                              TextStyle(
                            fontSize:
                                13,
                            fontWeight:
                                FontWeight
                                    .w500,
                          ),
                        ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              // ==================================================
              // KAYIT OL
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  const Text(
                    'Hesabınız yok mu? ',
                    style:
                        TextStyle(
                      color:
                          Color(
                        0xFF8B827B,
                      ),
                      fontSize: 11,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const RegisterScreen(),
                        ),
                      );
                    },
                    child:
                        const Text(
                      'Kayıt ol',
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFFA9826E,
                        ),
                        fontSize: 11,
                        fontWeight:
                            FontWeight
                                .w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText:
          hintText,
      hintStyle:
          const TextStyle(
        color:
            Color(0xFFB0A69E),
        fontSize: 12,
      ),
      prefixIcon: Icon(
        icon,
        size: 18,
        color:
            const Color(
          0xFF796C64,
        ),
      ),
      suffixIcon:
          suffixIcon,
      filled: true,
      fillColor:
          const Color(
        0xFFFBF9F5,
      ),
      contentPadding:
          const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 14,
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        borderSide:
            const BorderSide(
          color:
              Color(0xFFE5DED4),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
        borderSide:
            const BorderSide(
          color:
              Color(0xFFC9A995),
          width: 1.5,
        ),
      ),
    );
  }
}