import 'package:flutter/material.dart';

import '../services/admin_user_service.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() =>
      _AdminUserScreenState();
}

class _AdminUserScreenState
    extends State<AdminUserScreen> {
  List<Map<String, dynamic>> _users = [];

  bool _isLoading = true;
  String? _errorMessage;

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // ============================================================
  // KULLANICILARI GETİR
  // ============================================================

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users =
          await AdminUserService.getUsers();

      if (!mounted) {
        return;
      }

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            e.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    }
  }

  // ============================================================
  // FİLTRELENMİŞ KULLANICILAR
  // ============================================================

  List<Map<String, dynamic>>
      get _filteredUsers {
    if (_searchText.trim().isEmpty) {
      return _users;
    }

    final search =
        _searchText.trim().toLowerCase();

    return _users.where((user) {
      final name =
          user['name']?.toString().toLowerCase() ??
              '';

      final email =
          user['email']?.toString().toLowerCase() ??
              '';

      final role =
          user['role']?.toString().toLowerCase() ??
              '';

      return name.contains(search) ||
          email.contains(search) ||
          role.contains(search);
    }).toList();
  }

  // ============================================================
  // TARİH FORMATLA
  // ============================================================

  String _formatDate(dynamic value) {
    if (value == null) {
      return '-';
    }

    try {
      final date =
          DateTime.parse(value.toString()).toLocal();

      final day =
          date.day.toString().padLeft(2, '0');

      final month =
          date.month.toString().padLeft(2, '0');

      final year = date.year.toString();

      return '$day.$month.$year';
    } catch (_) {
      return '-';
    }
  }

  // ============================================================
  // ROL METNİ
  // ============================================================

  String _roleText(String role) {
    if (role == 'Admin') {
      return 'Yönetici';
    }

    return 'Müşteri';
  }

  // ============================================================
  // ROL RENGİ
  // ============================================================

  Color _roleBackground(String role) {
    if (role == 'Admin') {
      return const Color(0xFFF0E2D8);
    }

    return const Color(0xFFE8EFE5);
  }

  Color _roleForeground(String role) {
    if (role == 'Admin') {
      return const Color(0xFFA9826E);
    }

    return const Color(0xFF66805F);
  }

  // ============================================================
  // ROL DEĞİŞTİR
  // ============================================================

  Future<void> _changeRole(
    Map<String, dynamic> user,
  ) async {
    final userId =
        (user['id'] as num?)?.toInt();

    if (userId == null) {
      return;
    }

    final currentRole =
        user['role']?.toString() ?? 'Customer';

    String selectedRole = currentRole;

    final result =
        await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              backgroundColor:
                  const Color(0xFFFBF9F5),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
              title: const Text(
                'Kullanıcı Rolü',
                style: TextStyle(
                  color:
                      Color(0xFF383431),
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name']?.toString() ??
                        'Kullanıcı',
                    style:
                        const TextStyle(
                      color:
                          Color(0xFF66564E),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Rol',
                    style:
                        TextStyle(
                      color:
                          Color(0xFF8B827B),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(0xFFF3EEE8),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      border: Border.all(
                        color:
                            const Color(0xFFE5DED4),
                      ),
                    ),
                    child:
                        DropdownButtonHideUnderline(
                      child:
                          DropdownButton<String>(
                        value: selectedRole,
                        isExpanded: true,
                        dropdownColor:
                            const Color(
                          0xFFFBF9F5,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value:
                                'Customer',
                            child: Text(
                              'Müşteri',
                              style:
                                  TextStyle(
                                fontSize:
                                    12,
                                color:
                                    Color(
                                  0xFF383431,
                                ),
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Admin',
                            child: Text(
                              'Yönetici',
                              style:
                                  TextStyle(
                                fontSize:
                                    12,
                                color:
                                    Color(
                                  0xFF383431,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setDialogState(() {
                            selectedRole =
                                value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'Vazgeç',
                    style: TextStyle(
                      color:
                          Color(0xFF8B827B),
                      fontSize: 12,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                      selectedRole,
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFFC9A995,
                    ),
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Güncelle',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null ||
        result == currentRole) {
      return;
    }

    try {
      await AdminUserService.updateUserRole(
        userId: userId,
        role: result,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor:
                const Color(0xFF66564E),
            content: Text(
              '${user['name']} rolü güncellendi.',
              style:
                  const TextStyle(
                fontSize: 11,
              ),
            ),
            duration:
                const Duration(seconds: 2),
          ),
        );

      await _loadUsers();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor:
                const Color(0xFF66564E),
            content: Text(
              e.toString().replaceFirst(
                    'Exception: ',
                    '',
                  ),
              style:
                  const TextStyle(
                fontSize: 11,
              ),
            ),
            duration:
                const Duration(seconds: 3),
          ),
        );
    }
  }

  // ============================================================
  // KULLANICI KARTI
  // ============================================================

  Widget _buildUserCard(
    Map<String, dynamic> user,
  ) {
    final name =
        user['name']?.toString() ??
            'İsimsiz Kullanıcı';

    final email =
        user['email']?.toString() ??
            '-';

    final role =
        user['role']?.toString() ??
            'Customer';

    final userId =
        (user['id'] as num?)?.toInt() ??
            0;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            const Color(0xFFFBF9F5),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              const Color(0xFFE5DED4),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFF0E7DF),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color:
                      Color(0xFFA9826E),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Color(0xFF383431),
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      email,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color:
                            Color(0xFF8B827B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      _roleBackground(role),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                child: Text(
                  _roleText(role),
                  style:
                      TextStyle(
                    color:
                        _roleForeground(
                      role,
                    ),
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(
            height: 1,
            color:
                Color(0xFFE5DED4),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color:
                    Color(0xFFA9826E),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Kayıt: ${_formatDate(user['createdAt'])}',
                style:
                    const TextStyle(
                  color:
                      Color(0xFF8B827B),
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Text(
                'ID: $userId',
                style:
                    const TextStyle(
                  color:
                      Color(0xFFB0A69E),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () =>
                    _changeRole(user),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFFA9826E),
                  side: const BorderSide(
                    color:
                        Color(0xFFC9A995),
                  ),
                  minimumSize:
                      const Size(0, 34),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      9,
                    ),
                  ),
                ),
                child: const Text(
                  'Rolü Düzenle',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final filteredUsers =
        _filteredUsers;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F4EE),
      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF7F4EE),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color:
                Color(0xFF66564E),
            size: 20,
          ),
        ),
        title: const Text(
          'Kullanıcı Yönetimi',
          style: TextStyle(
            color:
                Color(0xFF383431),
            fontSize: 19,
            fontWeight:
                FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadUsers,
            tooltip: 'Yenile',
            icon: const Icon(
              Icons.refresh_outlined,
              color:
                  Color(0xFF66564E),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        color:
            const Color(0xFFC9A995),
        onRefresh: _loadUsers,
        child: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Color(0xFFC9A995),
                ),
              )
            : _errorMessage != null
                ? _buildError()
                : SingleChildScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(
                      parent:
                          BouncingScrollPhysics(),
                    ),
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kullanıcılar',
                          style:
                              TextStyle(
                            color:
                                Color(0xFF383431),
                            fontSize: 25,
                            fontWeight:
                                FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${_users.length} kayıtlı kullanıcı',
                          style:
                              const TextStyle(
                            color:
                                Color(0xFF8B827B),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        _buildSearchField(),
                        const SizedBox(
                          height: 18,
                        ),
                        if (filteredUsers.isEmpty)
                          _buildEmptyState()
                        else
                          ...filteredUsers.map(
                            _buildUserCard,
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }

  // ============================================================
  // ARAMA
  // ============================================================

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchText = value;
        });
      },
      style: const TextStyle(
        color:
            Color(0xFF383431),
        fontSize: 12,
      ),
      decoration:
          InputDecoration(
        hintText:
            'Ad, e-posta veya rol ara...',
        hintStyle:
            const TextStyle(
          color:
              Color(0xFFB0A69E),
          fontSize: 11,
        ),
        prefixIcon:
            const Icon(
          Icons.search,
          color:
              Color(0xFFA9826E),
          size: 20,
        ),
        filled: true,
        fillColor:
            const Color(0xFFFBF9F5),
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5DED4),
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5DED4),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFC9A995),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HATA
  // ============================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color:
                  Color(0xFFA9826E),
              size: 42,
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              _errorMessage ??
                  'Kullanıcılar yüklenemedi.',
              textAlign:
                  TextAlign.center,
              style:
                  const TextStyle(
                color:
                    Color(0xFF383431),
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed:
                  _loadUsers,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFC9A995,
                ),
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Tekrar Dene',
                style:
                    TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOŞ LİSTE
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color:
            const Color(0xFFFBF9F5),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              const Color(0xFFE5DED4),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.people_outline,
            color:
                Color(0xFFA9826E),
            size: 40,
          ),
          SizedBox(height: 12),
          Text(
            'Kullanıcı bulunamadı.',
            style:
                TextStyle(
              color:
                  Color(0xFF383431),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}