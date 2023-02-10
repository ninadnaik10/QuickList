import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_list/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class _MyHomePageState extends State<HomePage> {
  // _MyHomePageState({Key? key}) : super(key: key);
  final _collection = FirebaseFirestore.instance.collection('users');
  late Future<QuerySnapshot> _retrieveData;
  final User? user = Auth().currentUser;
  int _selectedIndex = -1;
  late String _selectedId;
  // final _usersStream = FirebaseFirestore.instance
  // .collection('users')
  // .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  // .snapshots();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  AppBar _appBar = AppBar(
    title: const Text('QuickList'),
    actions: [
      IconButton(
          onPressed: () async => await Auth().signOut(),
          icon: const Icon(Icons.logout))
    ],
  );

  late AppBar _homeAppBar;

  @override
  void initState() {
    super.initState();
    _homeAppBar = _appBar;
    TextEditingController updateController = TextEditingController();
    _retrieveData = FirebaseFirestore.instance
        .collection('users')
        .orderBy('createdOn', descending: true)
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    _longPressedAppBar = AppBar(
      title: const Text('Item selected'),
      actions: [
        IconButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                  backgroundColor: const Color(0XFFFFFFFF),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Text("Enter the Data"),
                        TextField(
                            controller: updateController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Update Data')),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _appBar = _homeAppBar;
                                  _selectedIndex = -1;
                                });
                              },
                              child: const Text('Close'),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                                onPressed: () {
                                  var sampleText = updateController.text;
                                  updateData(_selectedId, sampleText);
                                  Navigator.pop(context);
                                  setState(() {
                                    _retrieveData = retrieveData();
                                    _appBar = _homeAppBar;
                                    _selectedIndex = -1;
                                  });
                                },
                                child: const Text('Submit'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit)),
        IconButton(
            onPressed: () {
              deleteData(_selectedId);
              setState(() {
                _retrieveData = retrieveData();
                _appBar = _homeAppBar;
                _selectedIndex = -1;
              });
            },
            icon: const Icon(Icons.delete_outline)),
      ],
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          setState(() {
            _appBar = _homeAppBar;
            _selectedIndex = -1;
          });
        }, //TODO Do close button onpress
      ),
    );
  }

  // Widget _title() {
  //   return const Text('Firebase Auth');
  // }

  // Widget _userUid() {
  //   return Text(user?.email ?? 'User email');
  // }

  // Widget _signOutButton() {
  //   return FilledButton(
  //     onPressed: signOut,
  //     child: const Text('Sign Out'),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    TextEditingController controller = TextEditingController();
    return Scaffold(
        appBar: _appBar,
        body: FutureBuilder<QuerySnapshot>(
          future: _retrieveData,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            // if (snapshot.connectionState ==
            //     ConnectionState.waiting) {
            //   return const Center(
            //       child: CircularProgressIndicator()
            //   );
            // }

            // if (!snapshot.hasData) {
            //   return const Center(child: Text("No data available"));
            // }
            if (snapshot.hasData) {
              bool isSelected = false;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    // Map<String, dynamic> data =
                    // document.data()! as Map<String, dynamic>;
                    return ListTile(
                      selected: index == _selectedIndex,
                      title: Text(snapshot.data!.docs[index]['text']),
                      onLongPress: () {
                        setState(() {
                          _appBar = _longPressedAppBar;
                          _selectedIndex = index;
                          initiateMenuOp(
                              snapshot.data!.docs[index].reference.id);
                        });
                      },
                      // subtitle: Text(data['company']),
                    );
                  },
                  separatorBuilder: (_, int __) => const Divider(),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text("No data available"));
          },
        ),
        // Container(
        //   height: double.infinity,
        //   width: double.infinity,
        //   padding: const EdgeInsets.all(20),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        // _userUid(),
        // const SizedBox(height: 10),
        // _signOutButton(),
        // const SizedBox(height: 10),
        // TextField(controller: controller, decoration: const InputDecoration(
        //   border: OutlineInputBorder(),
        //   labelText: 'Enter Data'
        // )),
        // Container(
        //   margin: const EdgeInsets.all(20),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       FilledButton(
        //         child: const Text('Post'),
        //         onPressed: () async {
        //           final sampleText = controller.text;
        //           saveData(text: sampleText);
        //           setState(() {
        //             controller.clear();
        //           });
        //         },
        //       ),
        //       FilledButton(
        //         child: const Text('Refresh'),
        //         onPressed: () {
        //           setState(() {
        //             retrieveData();
        //           });
        //         },
        //       )
        //     ],
        //   ),
        // ),
        // Expanded(
        //     child: Container(
        //       decoration: BoxDecoration(
        //         border: Border.all(color: Colors.grey),
        //         borderRadius: const BorderRadius.all(Radius.circular(5.0))
        //       ),
        //       child: SizedBox(
        //           height: 200.0,
        //           width: 500,
        //           child:
        //           // StreamBuilder(
        //           //     stream: FirebaseFirestore.instance
        //           //         .collection('users')
        //           //         .snapshots(),
        //           //     builder: (context, snapshot) {
        //           //       return ListView.builder(
        //           //           itemCount: snapshot.data!.docs.length,
        //           //           itemBuilder: (context, index) {
        //           //             var data = snapshot.data!.docs[index].data();
        //           //             return ListTile(
        //           //               title: data['name'],
        //           //             );
        //           //           });
        //           //     }),
        //           ),
        //     ))
        // ],
        // );
        // ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                backgroundColor: const Color(0XFFFFFFFF),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // Text("Enter the Data"),
                      TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Data')),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                              onPressed: () {
                                final sampleText = controller.text;
                                saveData(text: sampleText);
                                Navigator.pop(context);
                                setState(() {
                                  _retrieveData = retrieveData();
                                });
                              },
                              child: const Text('Submit'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // backgroundColor: brandColor,
            child: const Icon(Icons.add),
          ),
        ));
  }

  void initiateMenuOp(String docsId) {
    // _collection.doc(docsId).delete();
    _selectedId = docsId;
  }

  Future<void> saveData({required String text}) async {
    if (text == '') {
      return;
    }
    await _collection.add({
      'uid': FirebaseAuth.instance.currentUser?.uid,
      'text': text,
      'createdOn': FieldValue.serverTimestamp()
    });
  }

  Future<QuerySnapshot> retrieveData() async {
    return await _collection
        .orderBy('createdOn', descending: true)
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
  }

  late final AppBar _longPressedAppBar;

  void deleteData(String docsId) async {
    await _collection.doc(docsId).delete();
  }

  void updateData(String docsId, String updatedString) async {
    if(updatedString == ''){
      return;
    }
    Map<String, dynamic> data = <String, dynamic>{"text": updatedString};
    await _collection.doc(docsId).update(data);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
