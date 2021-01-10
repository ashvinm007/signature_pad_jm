import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  File SignatureFile;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print("Value changed"));
  }

  Future<File>getImage(Uint8List imageUInt8List) async {
    Uint8List tempImg = imageUInt8List;
    if (tempImg != null) {
      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.jpg').create();
      file.writeAsBytesSync(tempImg);
      setState(() {});
      return file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signature Pad"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_controller.isNotEmpty) {
                Uint8List data = await _controller.toPngBytes();
                SignatureFile = await getImage(data);
                setState(() {

                });
                if(SignatureFile!=null){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: Center(
                              child: Container(
                                  color: Colors.grey[300], child: Image.file(SignatureFile))),
                        );
                      },
                    ),
                  );
                }

              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() => _controller.clear());
            },
          ),
        ],
      ),
      body: Signature(
        controller: _controller,
        height: MediaQuery.of(context).size.height *100/100,
        backgroundColor: Colors.white,
      ),
    );
  }
}
