// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import "package:firebase_storage/firebase_storage.dart" as firebase_storage;

class PhotoAdd extends StatefulWidget {
  const PhotoAdd({Key? key, required this.userName}) : super(key: key);
  final String userName;
  @override
  State<PhotoAdd> createState() => _PhotoAddState();
}

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

File? _photo;
final ImagePicker _picker = ImagePicker();

class _PhotoAddState extends State<PhotoAdd> {
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No image selected.",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        );
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[900],
            content: Text(
              "No image selected.",
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        );
      }
    });
  }

  String TurkishCharacterToEnglish(String text) {
    List<String> turkishChars = [
      'ı',
      'ğ',
      'İ',
      'Ğ',
      'ç',
      'Ç',
      'ş',
      'Ş',
      'ö',
      'Ö',
      'ü',
      'Ü'
    ];
    List<String> englishChars = [
      'i',
      'g',
      'I',
      'G',
      'c',
      'C',
      's',
      'S',
      'o',
      'O',
      'u',
      'U'
    ];

    // Match chars
    for (int i = 0; i < turkishChars.length; i++) {
      print(text);
      text = text.replaceAll(turkishChars[i], englishChars[i]);
    }

    return text;
  }

  Future uploadFile(String placeName, String placeDescription) async {
    if (_photo == null) return;
    const destination = 'images';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child(
          "_pn_${TurkishCharacterToEnglish(placeName.replaceAll(" ", "_").trim())}_pdesc_${TurkishCharacterToEnglish(placeDescription.replaceAll(" ", "_").trim())}_email_${TurkishCharacterToEnglish(widget.userName)}");
      await ref.putFile(_photo!);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: _photo == null
          ? Center(
              child: Container(
                  height: size.height * .85,
                  width: size.width * .85,
                  decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent[900],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.deepPurpleAccent.withOpacity(1),
                            blurRadius: 2,
                            spreadRadius: 2)
                      ]),
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                imgFromGallery();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                  "PICK FROM GALLERY",
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                imgFromCamera();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                    child: Text(
                                  "PICK FROM CAMERA",
                                  style: Theme.of(context).textTheme.bodyText1,
                                )),
                              ),
                            ),
                          ),
                        ],
                      )))))
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(_photo!), fit: BoxFit.cover)),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        stops: const [
                      0.3,
                      0.9
                    ],
                        colors: [
                      Colors.black.withOpacity(.9),
                      Colors.black.withOpacity(.2),
                    ])),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _photo = null;
                                });
                              },
                              child: Container(
                                width: size.width / 6,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(size.width / 6),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    "X",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )),
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                if (_placeDescriptionController.text.isEmpty &&
                                    _placeNameController.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Fill in all fields"),
                                    backgroundColor: Colors.red,
                                  ));
                                } else {
                                  uploadFile(_placeNameController.text,
                                      _placeDescriptionController.text);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Succesfuly Saved"),
                                          backgroundColor: Colors.green));
                                }
                              },
                              child: Container(
                                width: size.width / 3,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                      child: Text(
                                    "Save",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _placeNameController,
                                style: Theme.of(context).textTheme.bodyText1,
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.place,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Place Name',
                                  prefixText: ' ',
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyText1,
                                  focusColor: Colors.white,
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.white,
                                  )),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.white,
                                  )),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                  controller: _placeDescriptionController,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  cursorColor: Colors.white,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.description,
                                      color: Colors.white,
                                    ),
                                    hintText: 'Place Description',
                                    prefixText: ' ',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    focusColor: Colors.white,
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                  )),
                              Row(
                                children: [
                                  const Spacer(),
                                  Text(
                                    widget.userName,
                                    style: GoogleFonts.whisper(
                                        color: Colors.white,
                                        height: 1,
                                        fontSize: 32),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            ),
    );
  }
}

final TextEditingController _placeNameController = TextEditingController();
final TextEditingController _placeDescriptionController =
    TextEditingController();
