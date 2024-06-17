import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminDetailPengajuan extends StatefulWidget {
  @override
  _AdminDetailPengajuanState createState() => _AdminDetailPengajuanState();
}

class _AdminDetailPengajuanState extends State<AdminDetailPengajuan> {
  int _selectedIndex = 1;

  void _onDownloadPressed(String fileName) {
    // Tambahkan logika mendownload di sini
    print('Download $fileName');
    // Misalnya, Anda bisa menggunakan plugin seperti 'dio' atau 'http' untuk mendownload file
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC5E0CD),
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.question_answer_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQ()),
                ); // Fungsi untuk menu FAQ
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 54,
              height: 52,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFE9F0EB),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: 16), // Tambahkan padding horizontal di sini
        children: [
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'PENGMAS BUMI',
            topLeftText: 'Politeknik Negeri Bandung',
            additionalText: 'Sinumbra',
            TanggalText: '21 Maret - 24 Maret',
            TahunText: '2023',
            logoPath:
                'assets/images/logopolban.png', // Memberikan path gambar logo
          ),
          SizedBox(height: 20),
          Container(
            child: Wrap(
              spacing: 70.0,
              runSpacing: 10.0,
              children: [
                _buildDownloadContainer('Surat Izin Desa'),
                _buildDownloadContainer('Surat Izin Kec.'),
                _buildDownloadContainer('Surat Izin PTPN'),
                _buildDownloadContainer('Surat Izin Kor.'),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 110.0), // Tambahkan padding kiri
                  child: _buildDownloadContainer('Surat Izin Kep.'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BarNavigasi.NavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildDownloadContainer(String text) {
    return InkWell(
      onTap: () => _onDownloadPressed(text),
      borderRadius: BorderRadius.circular(
          10), // Pastikan borderRadius sama dengan yang ada di container
      child: Ink(
        width: 151,
        height: 69,
        decoration: BoxDecoration(
          color: Color(0xFF60AD77),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign
                  .center, // Menambahkan textAlign agar teks berada di tengah secara horizontal
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Icon(
              Icons.download,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String topLeftText;
  final String additionalText;
  final String TanggalText;
  final String TahunText;
  final String logoPath; // Menambahkan path gambar logo

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.topLeftText,
    required this.additionalText,
    required this.TanggalText,
    required this.TahunText,
    required this.logoPath, // Menambahkan path gambar logo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth *
          0.9, // Mengatur lebar container menjadi 90% dari lebar layar
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 17, top: 36), // Padding dari sisi kiri dan atas
            child: Image.asset(
              // Menambahkan gambar logo
              logoPath,
              width: 70, // Ukuran gambar logo
              height: 70,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment
                  .center, // Menyatukan teks ke tengah horizontal dari container
              child: Text(
                topLeftText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment
                  .center, // Menyatukan teks ke tengah horizontal dari container
              child: Text(
                '"' + text + '"',
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 146, 17),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Lokasi : ' + additionalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tanggal : ' + TanggalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tahun : ' + TahunText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: screenWidth *
                  0.8, // Mengatur lebar container menjadi 80% dari lebar layar
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.assured_workload,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Bidang Pengabdian : ...', // Isian teks di sini
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: screenWidth *
                  0.8, // Mengatur lebar container menjadi 80% dari lebar layar
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.group,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Jumlah Total     : ......  Orang', // Isian teks di sini
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: screenWidth *
                      0.4, // Mengatur lebar container menjadi 40% dari lebar layar
                  height: 102,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.person_2_sharp,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          height: 8), // Spacer untuk jarak antara ikon dan teks
                      Center(
                        child: Text(
                          'Jumlah Laki Laki \n .. Orang', // Isian teks di sini
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth *
                      0.4, // Mengatur lebar container menjadi 40% dari lebar layar
                  height: 102,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.person_4_sharp,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          height: 8), // Spacer untuk jarak antara ikon dan teks
                      Center(
                        child: Text(
                          'Jumlah Perempuan \n .. Orang', // Isian teks di sini
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Container(
              width: screenWidth *
                  0.8, // Mengatur lebar container menjadi 80% dari lebar layar
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.description,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Tujuan Kegiatan : \naaaaaaaaaaaaaaaaaaaaa', // Isian teks di sini
                      softWrap: true,
                      overflow: TextOverflow
                          .visible, // Mengizinkan teks meluas di luar batas kontainer
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20), // Spacer tambahan jika dibutuhkan
        ],
      ),
    );
  }
}
