import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {
  File? _imageFile;
  Map<String, dynamic>? _animalInfo;
  final ImagePicker _picker = ImagePicker();
  Uint8List? selectedImage;
  final gemini = Gemini.instance;

  Future<void> _selectImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg';
        final savedImage = await File(pickedFile.path).copy(imagePath);

        setState(() {
          _imageFile = savedImage;
        });

        await _getAnimalInfo(savedImage);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAnimalInfo(File image) async {
    final prompt = '''
Identify the following animal in the image and provide the following details:
1. Animal Name
2. Family
3. Species
4. Features

Provide the information in the following format:
Animal Name: [Name]
Family: [Family]
Species: [Species]
Features: [Features]
''';

    try {
      final imageBytes = await image.readAsBytes();
      selectedImage = imageBytes;
      final value = await gemini.textAndImage(
        text: prompt,
        images: [selectedImage!],
      );

      String? result = value?.content?.parts?.last.text;
      if (result != null) {
        final lines = result.split('\n');
        final infoMap = <String, String>{};
        for (var line in lines) {
          final parts = line.split(': ');
          if (parts.length == 2) {
            infoMap[parts[0].trim()] = parts[1].trim();
          }
        }
        setState(() {
          _animalInfo = infoMap;
        });

        // Show animal info after parsing the result
        _showAnimalInfo();
      }
    } catch (e) {
      print('Error getting animal info: $e');
    }
  }

  void _showAnimalInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _animalInfo != null
            ? Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Animal Name: ${_animalInfo!['Animal Name'] ?? 'N/A'}'),
              Text('Family: ${_animalInfo!['Family'] ?? 'N/A'}'),
              Text('Species: ${_animalInfo!['Species'] ?? 'N/A'}'),
              Text('Features: ${_animalInfo!['Features'] ?? 'N/A'}'),
            ],
          ),
        )
            : Container(
          padding: EdgeInsets.all(16.0),
          child: Text('No information available'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Image.asset('assets/images/logoblack.png', height: 40),
        ),
      ),
      body: Stack(
        children: [
          _imageFile != null
              ? Center(
            child: Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
              : Center(
            child: Column(
              children: [
                Lottie.asset('assets/images/empty.json'),
                Text(
                  'No image selected',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _selectImage,
                child: Icon(Icons.photo_library),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
