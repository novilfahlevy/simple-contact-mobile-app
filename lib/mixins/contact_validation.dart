mixin ContactValidation {
  String? validateInputName(final String? name) {
    if (name == null || name.isEmpty) {
      return 'Nama harus diisi.';
    }

    if (name.split(' ').length < 2) {
      return 'Nama harus terdiri dari 2 kata.';
    }

    if (name.split(' ').where((String word) => word[0] == word[0].toLowerCase()).isNotEmpty) {
      return 'Huruf awal setiap kata harus berbentuk huruf kapital.';
    }

    final RegExp invalidNamePattern = RegExp(r'[0-9@#$%^&*()_+\-=\[\]{};:",.<>?]');

    if (invalidNamePattern.allMatches(name).isNotEmpty) {
      return 'Nama tidak boleh mengandung angka dan karakter spesial.';
    }

    return null;
  }

  String? validateInputPhone(final String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Nomor telepon harus diisi.';
    }

    final RegExp invalidPhoneNumberPattern = RegExp(r'[a-zA-Z@#$%^&*()_+\-=\[\]{};:",.<>?]');

    if (invalidPhoneNumberPattern.allMatches(phone).isNotEmpty) {
      return 'Nomor telepon tidak valid.';
    }

    if (phone.length < 8 || phone.length > 15) {
      return 'Panjang nomor telepon harus minimal 8 digit dan maksimal 15 digit.';
    }

    if (phone[0] != '0') {
      return 'Nomor telepon harus dimulai dari angka 0.';
    }

    return null;
  }
}