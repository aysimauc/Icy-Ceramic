import 'package:flutter/material.dart';

import 'favorites_screen.dart';
import 'order_history_screen.dart';
import 'coupon_wallet_screen.dart';
import 'mini_game_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  // ============================================================
  // SİPARİŞLERİM
  // ============================================================

  void openOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderHistoryScreen(),
      ),
    );
  }

  // ============================================================
  // FAVORİLERİM
  // ============================================================

  void openFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
  }

  // ============================================================
  // KUPONLARIM
  // ============================================================

  void openCoupons(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CouponWalletScreen(),
      ),
    );
  }

  // ============================================================
  // MİNİ OYUN
  // ============================================================

  void openMiniGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MiniGameScreen(),
      ),
    );
  }

  // ============================================================
  // HESABIM
  // ============================================================

  void openAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFBF9F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Hesabım',
            style: TextStyle(
              color: Color(0xFF383431),
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AccountInfoRow(
                icon: Icons.person_outline,
                title: 'Ad Soyad',
                value: 'ICY Ceramic Kullanıcısı',
              ),
              SizedBox(height: 16),
              _AccountInfoRow(
                icon: Icons.email_outlined,
                title: 'E-posta',
                value: 'kullanici@icyceramic.com',
              ),
              SizedBox(height: 16),
              _AccountInfoRow(
                icon: Icons.phone_outlined,
                title: 'Telefon',
                value: '+90 5XX XXX XX XX',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Kapat',
                style: TextStyle(
                  color: Color(0xFFA9826E),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // AYARLAR
  // ============================================================

  void openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFBF9F5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8CEC4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ayarlar',
                    style: TextStyle(
                      color: Color(0xFF383431),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const _SettingsIcon(
                    icon: Icons.notifications_none,
                  ),
                  title: const Text(
                    'Bildirimler',
                    style: TextStyle(
                      color: Color(0xFF66564E),
                      fontSize: 13,
                    ),
                  ),
                  subtitle: const Text(
                    'Bildirim tercihlerini yönet',
                    style: TextStyle(
                      color: Color(0xFF9B9189),
                      fontSize: 10,
                    ),
                  ),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeThumbColor: const Color(0xFFA9826E),
                    activeTrackColor: const Color(0xFFE9D9CC),
                  ),
                ),

                const Divider(
                  color: Color(0xFFE5DED4),
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const _SettingsIcon(
                    icon: Icons.lock_outline,
                  ),
                  title: const Text(
                    'Gizlilik ve Güvenlik',
                    style: TextStyle(
                      color: Color(0xFF66564E),
                      fontSize: 13,
                    ),
                  ),
                  subtitle: const Text(
                    'Hesap ve güvenlik ayarları',
                    style: TextStyle(
                      color: Color(0xFF9B9189),
                      fontSize: 10,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFB0A69E),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Gizlilik ve güvenlik ayarları yakında eklenecek.',
                        ),
                      ),
                    );
                  },
                ),

                const Divider(
                  color: Color(0xFFE5DED4),
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const _SettingsIcon(
                    icon: Icons.info_outline,
                  ),
                  title: const Text(
                    'Uygulama Hakkında',
                    style: TextStyle(
                      color: Color(0xFF66564E),
                      fontSize: 13,
                    ),
                  ),
                  subtitle: const Text(
                    'ICY Ceramic',
                    style: TextStyle(
                      color: Color(0xFF9B9189),
                      fontSize: 10,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFB0A69E),
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'ICY Ceramic',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                          'El yapımı seramik ürünler için modern e-ticaret uygulaması.',
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // ÇIKIŞ YAP
  // ============================================================

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFBF9F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Çıkış Yap',
            style: TextStyle(
              color: Color(0xFF383431),
              fontSize: 17,
            ),
          ),
          content: const Text(
            'Hesabından çıkış yapmak istediğine emin misin?',
            style: TextStyle(
              color: Color(0xFF796C64),
              fontSize: 12,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Vazgeç',
                style: TextStyle(
                  color: Color(0xFF9B9189),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  color: Color(0xFFA9826E),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EE),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4EE),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF66564E),
            size: 19,
          ),
        ),

        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF383431),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          physics: const BouncingScrollPhysics(),

          children: [
            // =================================================
            // PROFİL BAŞLIĞI
            // =================================================

            Center(
              child: Column(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFE5DC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFFA9826E),
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Hoş Geldin 👋',
                    style: TextStyle(
                      color: Color(0xFF383431),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'ICY Ceramic',
                    style: TextStyle(
                      color: Color(0xFF9B9189),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =================================================
            // HESABIM
            // =================================================

            _profileOption(
              icon: Icons.person_outline,
              title: 'Hesabım',
              subtitle: 'Kişisel bilgilerini görüntüle',
              onTap: () {
                openAccount(context);
              },
            ),

            // =================================================
            // SİPARİŞLERİM
            // =================================================

            _profileOption(
              icon: Icons.receipt_long_outlined,
              title: 'Siparişlerim',
              subtitle: 'Geçmiş siparişlerini görüntüle',
              onTap: () {
                openOrders(context);
              },
            ),

            // =================================================
            // FAVORİLER
            // =================================================

            _profileOption(
              icon: Icons.favorite_border,
              title: 'Favorilerim',
              subtitle: 'Beğendiğin ürünler',
              onTap: () {
                openFavorites(context);
              },
            ),

            // =================================================
            // KUPONLAR
            // =================================================

            _profileOption(
              icon: Icons.local_offer_outlined,
              title: 'Kuponlarım',
              subtitle: 'Kazandığın indirim kuponları',
              onTap: () {
                openCoupons(context);
              },
            ),

            // =================================================
            // MİNİ OYUN
            // =================================================

            _profileOption(
              icon: Icons.extension_outlined,
              title: 'Mini Oyun',
              subtitle: 'Oyna ve kupon kazan',
              onTap: () {
                openMiniGame(context);
              },
            ),

            // =================================================
            // AYARLAR
            // =================================================

            _profileOption(
              icon: Icons.settings_outlined,
              title: 'Ayarlar',
              subtitle: 'Uygulama ayarları',
              onTap: () {
                openSettings(context);
              },
            ),

            const SizedBox(height: 10),

            // =================================================
            // ÇIKIŞ
            // =================================================

            _profileOption(
              icon: Icons.logout,
              title: 'Çıkış Yap',
              subtitle: 'Hesabından çıkış yap',
              onTap: () {
                showLogoutDialog(context);
              },
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFİL KARTI
  // ============================================================

  Widget _profileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE5DED4),
        ),
      ),
      child: ListTile(
        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),

        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFEFE5DC),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isLogout
                ? const Color(0xFF9A6F62)
                : const Color(0xFFA9826E),
            size: 20,
          ),
        ),

        title: Text(
          title,
          style: TextStyle(
            color: isLogout
                ? const Color(0xFF9A6F62)
                : const Color(0xFF66564E),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF9B9189),
            fontSize: 9,
          ),
        ),

        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFFB0A69E),
          size: 19,
        ),
      ),
    );
  }
}

// ============================================================
// HESAP BİLGİ SATIRI
// ============================================================

class _AccountInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _AccountInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFEFE5DC),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Color(0xFFA9826E),
            size: 18,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF9B9189),
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF66564E),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// AYARLAR İKONU
// ============================================================

class _SettingsIcon extends StatelessWidget {
  final IconData icon;

  const _SettingsIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFEFE5DC),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Color(0xFFA9826E),
        size: 19,
      ),
    );
  }
}