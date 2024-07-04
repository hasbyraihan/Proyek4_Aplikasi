import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_helloo_world/Component/NavigationBar.dart'
    as BarNavigasi;

class AdminKebutuhan extends StatefulWidget {
  @override
  _AdminKebutuhanState createState() => _AdminKebutuhanState();
}

class _AdminKebutuhanState extends State<AdminKebutuhan> {
  late Future<List<RWData>> rwDataFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    rwDataFuture = fetchRWDataFromFirebase();
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<RWData>>(
          future: rwDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return _buildRWCard(snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog();
        },
        child: Icon(Icons.add),
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

  Widget _buildRWCard(RWData rwData) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RW ${rwData.rwNumber}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kebutuhan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(rwData.needs.length, (index) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        '- ${rwData.needs[index]}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(
                            rwData.rwNumber, index, rwData.needs[index]);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(rwData.rwNumber, index);
                      },
                    ),
                  ],
                );
              }),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _showAddDialogRW(rwData.rwNumber);
              },
              child: Text('Tambah Kebutuhan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
      int rwNumber, int needIndex, String currentNeed) async {
    TextEditingController _controller =
        TextEditingController(text: currentNeed);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Kebutuhan RW'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Masukkan kebutuhan baru'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newNeed = _controller.text.trim();
                if (newNeed.isNotEmpty) {
                  await updateRWNeedInFirebase(rwNumber, needIndex, newNeed);
                  setState(() {
                    rwDataFuture =
                        fetchRWDataFromFirebase(); // Refresh data setelah update
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddDialogRW(int rwNumber) async {
    TextEditingController _controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Kebutuhan RW'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Masukkan kebutuhan baru'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newNeed = _controller.text.trim();
                if (newNeed.isNotEmpty) {
                  await addRWNeedToFirebase(rwNumber, newNeed);
                  setState(() {
                    rwDataFuture =
                        fetchRWDataFromFirebase(); // Refresh data setelah tambah kebutuhan baru
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddDialog() async {
    int? rwNumber;
    String newNeed = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Kebutuhan RW'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Masukkan nomor RW'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  rwNumber = int.tryParse(value);
                },
              ),
              TextField(
                decoration:
                    InputDecoration(hintText: 'Masukkan kebutuhan baru'),
                onChanged: (value) {
                  newNeed = value.trim();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (rwNumber != null && newNeed.isNotEmpty) {
                  await addRWNeedToFirebase(rwNumber!, newNeed);
                  setState(() {
                    rwDataFuture =
                        fetchRWDataFromFirebase(); // Refresh data setelah update
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      int rwNumber, int needIndex) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Kebutuhan RW'),
          content: Text('Apakah Anda yakin ingin menghapus kebutuhan ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteRWNeedFromFirebase(rwNumber, needIndex);
                setState(() {
                  rwDataFuture =
                      fetchRWDataFromFirebase(); // Refresh data setelah update
                });
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}

class RWData {
  final int rwNumber;
  final List<String> needs;

  RWData({required this.rwNumber, required this.needs});
}

Future<List<RWData>> fetchRWDataFromFirebase() async {
  try {
    final userRef = FirebaseDatabase.instance.ref('info-desa/kebutuhan-rw');
    final userSnapshot = await userRef.get();

    List<RWData> rwDataList = [];
    if (userSnapshot.value != null) {
      Map<dynamic, dynamic> data = userSnapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final rwNumber = value['rw'];
        if (rwNumber is int) {
          // Validate rwNumber is int
          final needs = List<String>.from(value['kebutuhan'] ?? []);
          rwDataList.add(RWData(rwNumber: rwNumber, needs: needs));
        }
      });
      return rwDataList;
    } else {
      throw 'Data not found';
    }
  } catch (e) {
    throw 'Error: $e';
  }
}

Future<void> updateRWNeedInFirebase(
    int rwNumber, int needIndex, String newNeed) async {
  try {
    final userRef = FirebaseDatabase.instance
        .ref('info-desa/kebutuhan-rw/rw-$rwNumber/kebutuhan/$needIndex');
    await userRef.set(newNeed);
  } catch (e) {
    throw 'Error updating RW need: $e';
  }
}

Future<void> addRWNeedToFirebase(int rwNumber, String newNeed) async {
  try {
    final userRef = FirebaseDatabase.instance
        .ref('info-desa/kebutuhan-rw/rw-$rwNumber/kebutuhan');

    final userSnapshot = await userRef.get();
    int nextIndex;

    if (userSnapshot.value != null) {
      if (userSnapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data =
            userSnapshot.value as Map<dynamic, dynamic>;
        nextIndex = data.length; 
      } else if (userSnapshot.value is List) {
        List data = userSnapshot.value as List;
        nextIndex = data.length; 
      } else {
        throw 'Unknown data structure';
      }
    } else {
      nextIndex = 0;
    }

    await userRef.child('$nextIndex').set(newNeed);
  } catch (e) {
    throw 'Error adding RW need: $e';
  }
}

Future<void> deleteRWNeedFromFirebase(int rwNumber, int needIndex) async {
  try {
    final userRef = FirebaseDatabase.instance
        .ref('info-desa/kebutuhan-rw/rw-$rwNumber/kebutuhan/$needIndex');
    await userRef.remove();
  } catch (e) {
    throw 'Error deleting RW need: $e';
  }
}
