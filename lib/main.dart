import 'dart:math';
import 'package:flutter/material.dart';
import 'Dashboard.dart';

void main() {
  runApp(MyDashboardApp());
}

class MyDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardScreen(),
      routes: {
        '/Dashboard': (context) => Dashboard(),
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: MyPainter(),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Menambahkan foto dengan jarak bawah 20.0
                // SizedBox(height: 30.0),
                Container(
                  // margin: EdgeInsets.only(bottom: 20.0),
                  child: Expanded(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Menambahkan kalimat "Selamat datang" di tengah
                SizedBox(height: 100.0),
                Text(
                  'SELAMAT DATANG',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Menambahkan jarak antara teks dan teks di bawahnya
                SizedBox(height: 100.0),
                // Menambahkan kalimat di bawah foto
                Text(
                  'Pengabdian menjadi lebih \n mudah dan praktis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 100.0),
                // Menambahkan tombol "Next" di tengah
                Center(
                  child: SizedBox(
                    width: 124.0,
                    height: 56.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                            0xFF60AD77), // Atur warna latar belakang tombol
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: Color(
                                0xFFF5F2F2)), // Atur warna teks menjadi F5F2F2
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // Draw background color
    paint.color = Color(0xFFC5E0CD); // Warna latar belakang dasar
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw wave effect
    Path path = Path();
    paint.color = Color(0xFFE9F0EB); // Warna gelombang
    path.moveTo(0, size.height * 0.5);
    for (int i = 0; i < size.width; i++) {
      path.lineTo(i.toDouble(), size.height * 0.5 + 20 * sin(i * 0.03));
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
