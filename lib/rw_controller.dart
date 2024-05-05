class RWController {
  List<RWData> rwDataList = [];

  // Method untuk menambahkan data RW
  void addRW(RWData rwData) {
    rwDataList.add(rwData);
  }

  // Method untuk menambahkan kebutuhan pada RW tertentu
  void addNeed(int rwNumber, String need) {
    rwDataList[rwNumber - 1].needs.add(need);
  }

  // Method untuk mengupdate kebutuhan pada RW tertentu
  void updateNeed(int rwNumber, int index, String newValue) {
    rwDataList[rwNumber - 1].needs[index] = newValue;
  }
}

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
