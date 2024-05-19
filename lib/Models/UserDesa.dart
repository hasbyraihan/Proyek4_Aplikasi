class UserDesa {
  final String uid;
  final String nama;
  final String nip;
  final String role;
  final String jabatan;
  String fotoProfil;
  final String email;
  final String password;

  UserDesa({
    required this.uid,
    required this.nama,
    required this.nip,
    required this.jabatan,
    required this.fotoProfil,
    required this.role,
    required this.email,
    required this.password,
  });

  factory UserDesa.fromMap(Map<Object?, Object?>? data, String key) {
    if (data == null) {
      throw ArgumentError("Data cannot be null");
    }
    return UserDesa(
      uid: data['uid'].toString(),
      nama: data['nama'].toString(),
      nip: data['nip'].toString(),
      jabatan: data['jabatan'].toString(),
      fotoProfil: data['fotoProfilURL'].toString(),
      role: data['role'].toString(),
      email: data['email'].toString(),
      password: data['password'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nama': nama,
      'nip': nip,
      'jabatan': jabatan,
      'role': role,
      'email': email,
      'password': password,
    };
  }

  static UserDesa loading() {
    return UserDesa(
      uid: '',
      nama: 'Loading...',
      nip: '',
      jabatan: '',
      fotoProfil: '',
      role: '',
      email: '',
      password: '',
    );
  }
}
