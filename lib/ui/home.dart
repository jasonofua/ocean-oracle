import 'dart:typed_data';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocean_oracle/utils/constants.dart';
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
  bool isLoading = false;
  Future<void> _selectImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg';
        final savedImage = await File(pickedFile.path).copy(imagePath);

        setState(() {
          _imageFile = savedImage;
          isLoading = true;
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

    image.readAsBytes().then((value) {
      setState(() {
        selectedImage = value;
        gemini.textAndImage(
          text: prompt,
          images: [selectedImage!],
        ).then((response) {
          if (response != null && response.content != null) {
            String result = response.content!.parts!.last.text!;
            _parseAnimalInfo(result);
            _showAnimalInfo();
          }
        }).catchError((error) {
          print("Error: $error");
        });
      });
    });
  }

  void _parseAnimalInfo(String response) {
    final Map<String, dynamic> animalInfo = {};
    final lines = response.split('\n');
    for (var line in lines) {
      if (line.startsWith('Animal Name:')) {
        animalInfo['name'] = line.replaceFirst('Animal Name:', '').trim();
      } else if (line.startsWith('Family:')) {
        animalInfo['family'] = line.replaceFirst('Family:', '').trim();
      } else if (line.startsWith('Species:')) {
        animalInfo['species'] = line.replaceFirst('Species:', '').trim();
      } else if (line.startsWith('Features:')) {
        animalInfo['features'] = line.replaceFirst('Features:', '').trim();
      }
    }
    setState(() {
      _animalInfo = animalInfo;
      isLoading = false;
    });
  }

  void _showAnimalInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _animalInfo != null
            ? Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.pets, color: Colors.orange, size: 30),
                    SizedBox(width: 8.0),
                    Text(
                      _animalInfo!['name'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    _buildInfoItem('Family', _animalInfo!['family'], Icons.family_restroom),
                    _buildInfoItem('Species', _animalInfo!['species'], Icons.bug_report),
                    _buildInfoItem('Features', _animalInfo!['features'], Icons.info),
                  ],
                ),
              ],
            ),
          ),
        )
            : Container(
          padding: EdgeInsets.all(16.0),
          child: Text('No information available'),
        );
      },
    );
  }

  Widget _buildInfoItem(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 8.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  content,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      blurEffectIntensity: 4,
      progressIndicator: SpinKitFadingCircle(
        color: kPrimaryColor,
        size: 90.0,
      ),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black,
      child: Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
