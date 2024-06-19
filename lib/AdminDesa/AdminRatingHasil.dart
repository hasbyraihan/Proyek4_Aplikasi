import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Faq.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminRatingHasil extends StatefulWidget {
  @override
  _AdminRatingHasilState createState() => _AdminRatingHasilState();
}

class _AdminRatingHasilState extends State<AdminRatingHasil> {
  int _selectedIndex = 1;
  int _rating = 0; // Initial rating value

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
          SizedBox(height: 20),
          CustomContainer(
            color: Color(0xFF60AD77),
            text: 'PENGMAS BUMI',
            topLeftText: 'Politeknik Negeri Bandung',
            additionalText: 'Sinumbra',
            TanggalText: '21 Maret - 24 Maret',
            TahunText: '2023',
            logoPath:
                'assets/images/logopolban.png', // Memberikan path gambar logo
            rating: _rating,
            onRatingChanged: (rating) {
              setState(() {
                _rating = rating;
              });
            },
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
}

class CustomContainer extends StatefulWidget {
  final Color color;
  final String text;
  final String topLeftText;
  final String additionalText;
  final String TanggalText;
  final String TahunText;
  final String logoPath; // Menambahkan path gambar logo
  final int rating; // Menambahkan rating
  final ValueChanged<int> onRatingChanged; // Callback untuk rating

  const CustomContainer({
    Key? key,
    required this.color,
    required this.text,
    required this.topLeftText,
    required this.additionalText,
    required this.TanggalText,
    required this.TahunText,
    required this.logoPath, // Menambahkan path gambar logo
    required this.rating, // Menambahkan rating
    required this.onRatingChanged, // Callback untuk rating
  }) : super(key: key);

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool _isEditing = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth *
          0.9, // Mengatur lebar container menjadi 90% dari lebar layar
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 36), // Padding dari sisi kiri dan atas
            child: Image.asset(
              // Menambahkan gambar logo
              widget.logoPath,
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
                widget.topLeftText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment
                  .center, // Menyatukan teks ke tengah horizontal dari container
              child: Text(
                '"' + widget.text + '"',
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 146, 17),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Lokasi : ' + widget.additionalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tanggal : ' + widget.TanggalText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Tahun : ' + widget.TahunText,
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
          SizedBox(height: 10), // Spacer tambahan jika dibutuhkan
          _buildRatingStars(), // Tambahkan widget rating stars di sini
          SizedBox(height: 10), // Spacer tambahan jika dibutuhkan
          _buildEditableContainer(), // Tambahkan widget editable container di sini
          SizedBox(height: 10), // Spacer tambahan jika dibutuhkan
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.8,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            'Rating',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  widget.onRatingChanged(index + 1);
                },
                child: Icon(
                  index < widget.rating ? Icons.star : Icons.star_border,
                  color: index < widget.rating ? Colors.orange : Colors.orange,
                  size: 30,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableContainer() {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: Container(
        width: screenWidth * 0.8,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Evaluasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Divider(),
            _isEditing
                ? TextField(
                    controller: _controller,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Masukkan teks di sini...',
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  )
                : Icon(
                    Icons.edit,
                    size: 50,
                    color: Colors.grey,
                  ),
          ],
        ),
      ),
    );
  }
}
