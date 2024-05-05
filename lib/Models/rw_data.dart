class RWData {
  final int rwNumber;
  final List<String> needs;

  RWData({
    required this.rwNumber,
    required this.needs,
  });
}

RWData rwData1 = RWData(
  rwNumber: 1,
  needs: ['Tidak ada Bak sampah', 'Kurang gizi', 'Minim Teknologi'],
);

RWData rwData2 = RWData(
  rwNumber: 2,
  needs: ['Kurang Air bersih', 'Kurang Pendidikan', 'Minim Akses Transportasi'],
);
