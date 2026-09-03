class AddressService {
  static final List<String> _addresses = [];

  static List<String> get addresses {
    return List.unmodifiable(_addresses);
  }

  static bool contains(String address) {
    return _addresses.contains(address);
  }

  static void addAddress(String address) {
    final cleanedAddress =
        address.trim();

    if (cleanedAddress.isEmpty) {
      return;
    }

    if (!contains(cleanedAddress)) {
      _addresses.add(cleanedAddress);
    }
  }

  static void removeAddress(String address) {
    _addresses.remove(address);
  }
}