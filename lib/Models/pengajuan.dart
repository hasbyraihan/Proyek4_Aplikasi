class Pengajuan {
  final String title;
  final String institution;
  final String location;
  final String datesMulai;
  final String datesSelesai;
  final String lakiLaki;
  final String perempuan;
  final String totalPeserta;
  final String bidangPengabdian;
  final List<String> documents;

  Pengajuan({
    required this.title,
    required this.institution,
    required this.location,
    required this.datesMulai,
    required this.datesSelesai,
    required this.lakiLaki,
    required this.perempuan,
    required this.totalPeserta,
    required this.bidangPengabdian,
    required this.documents,
  });

  factory Pengajuan.fromMap(Map<String, dynamic> map) {
    int lakiLakiInt = int.tryParse(map['jumlahLakiLaki'] ?? '0') ?? 0;
    int perempuanInt = int.tryParse(map['jumlahPerempuan'] ?? '0') ?? 0;
    int totalPesertaInt = lakiLakiInt + perempuanInt;

    return Pengajuan(
      title: map['namaProgram'] ?? '',
      institution: map['perguruanTinggi'] ?? '',
      location: map['rw'] ?? '',
      datesMulai: map['tanggalAwal'] ?? '',
      datesSelesai: map['tanggalSelesai'] ?? '',
      lakiLaki: map['jumlahLakiLaki'] ?? '',
      perempuan: map['jumlahPerempuan'] ?? '',
      totalPeserta: totalPesertaInt.toString(),
      bidangPengabdian: map['bidangPengabdian'] ?? '',
      documents: List<String>.from(map['documents'] ?? []),
    );
  }
}
