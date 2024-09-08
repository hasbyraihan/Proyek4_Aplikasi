class User {
  final String uid;
  final String nama;
  final String nim;
  final String role;
  final String namaPerguruanTinggi;
  String fotoProfil;

  User({
    required this.uid,
    required this.nama,
    required this.nim,
    required this.namaPerguruanTinggi,
    required this.fotoProfil,
    required this.role,
  });

  factory User.fromMap(Map<Object?, Object?>? data) {
    if (data == null) {
      throw ArgumentError("Data cannot be null");
    }
    return User(
      uid: data['uid'].toString(),
      nama: data['nama'].toString(),
      nim: data['nim'].toString(),
      namaPerguruanTinggi: data['namaPerguruanTinggi'].toString(),
      fotoProfil: data['fotoProfilURL'].toString(),
      role: data['role'].toString(),
    );
  }

  static User loading() {
    return User(
      uid: '',
      nama: 'Loading...',
      nim: '',
      namaPerguruanTinggi: '',
      fotoProfil: '',
      role: '',
    );
  }
}
