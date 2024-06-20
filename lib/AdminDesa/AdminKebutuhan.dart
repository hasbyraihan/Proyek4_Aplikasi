import 'package:flutter/material.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminKebutuhan extends StatefulWidget {
  @override
  _AdminKebutuhanState createState() => _AdminKebutuhanState();
}

class _AdminKebutuhanState extends State<AdminKebutuhan> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC5E0CD),
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10),
              SizedBox(height: 10),
              ContainerCardRW(
                rwDataList: [
                  RWData(
                    rwNumber: 1,
                    needs: [
                      'Kurang Guru',
                      'Lingkungan Kotor',
                      'Keterbatasan Fasilitas',
                    ],
                  ),
                  RWData(
                    rwNumber: 2,
                    needs: [],
                  ),
                  RWData(
                    rwNumber: 3,
                    needs: [],
                  ),
                  RWData(
                    rwNumber: 4,
                    needs: [],
                  ),
                  RWData(
                    rwNumber: 5,
                    needs: [],
                  ),
                  RWData(
                    rwNumber: 6,
                    needs: [],
                  ),
                  RWData(
                    rwNumber: 7,
                    needs: [],
                  ),
                ],
              )
            ],
          ),
        ),
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

class ContainerCardRW extends StatefulWidget {
  final List<RWData> rwDataList;

  const ContainerCardRW({
    Key? key,
    required this.rwDataList,
  }) : super(key: key);

  @override
  _ContainerCardRWState createState() => _ContainerCardRWState();
}

class _ContainerCardRWState extends State<ContainerCardRW> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.rwDataList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 350,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildRWCard(widget.rwDataList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRWCard(RWData rwData) {
    TextEditingController _editController = TextEditingController();

    void _editNeeds(int index, String newValue) {
      setState(() {
        rwData.needs[index] = newValue;
      });
    }

    void _addNeed() {
      setState(() {
        rwData.needs.add('');
      });
    }

    void _returnData() {
      // Implementasi untuk mengembalikan data RW dan kebutuhannya
      print('Data RW ${rwData.rwNumber}: ${rwData.needs}');
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      width: 500,
      // Mengubah jenis perutean dari Column menjadi SingleChildScrollView
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RW ${rwData.rwNumber}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Kebutuhan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Column(
              children: rwData.needs.asMap().entries.map((entry) {
                int index = entry.key;
                String need = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: need),
                            onChanged: (newValue) {
                              _editNeeds(index, newValue);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Kebutuhan ${index + 1}',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              rwData.needs.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _addNeed,
              child: Text('Tambah Kebutuhan'),
            ),
            ElevatedButton(
              onPressed: _returnData,
              child: Text('Return Data'),
            ),
          ],
        ),
      ),
    );
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
