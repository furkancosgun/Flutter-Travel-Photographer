import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_fonts/google_fonts.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:travel_photographer/Service/AuthService.dart';
import 'package:string_extension/string_extension.dart';
import '../PhotoAdd/PhotoAdd.dart';
import 'components/imagePage.dart';

class HomePage extends StatefulWidget {
  final String userName;

  const HomePage({super.key, required this.userName});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<String>> listPhotos() async {
    List<String> urlList = [];
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images')
        .listAll();

    for (firebase_storage.Reference ref in result.items) {
      String url = await firebase_storage.FirebaseStorage.instance
          .ref(ref.fullPath)
          .getDownloadURL();
      urlList.add(url);
    }

    return urlList;
  }

  late final PageController _pageController = PageController(
    initialPage: 0,
  );
  final AuthService _auth = AuthService();
  var _future;
  @override
  void initState() {
    super.initState();
    _future = listPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        backgroundColor: Colors.deepPurpleAccent.withOpacity(.5),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                  child: Column(
                children: [
                  Text(
                    'Travel Photographer',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Hi',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.userName,
                    style: GoogleFonts.whisper(
                        color: Colors.white, height: 1, fontSize: 40),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
            ),
            ListTile(
              leading: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 30,
              ),
              title: const Center(child: Text('ADD IMAGE')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => PhotoAdd(
                      userName: widget.userName,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 30,
              ),
              title: const Center(child: Text('LOG OUT')),
              onTap: () {
                Navigator.pop(context);
                _auth.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        color: Colors.black,
        backgroundColor: Colors.deepPurpleAccent,
        onRefresh: () async {
          setState(() {
            _future = listPhotos();
          });
        },
        child: FutureBuilder<List<String>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var datalist = snapshot.data!;
                List<String> placeName = [];
                List<String> placeDescription = [];
                List<String> userName = [];

                datalist.forEach((element) {
                  var pn = element.replaceAll("_", " ").substring(
                      element.indexOf("pn") + 3, element.indexOf("pdesc") - 1);
                  placeName.add(pn.trim().capitalize());

                  var pdesc = element.replaceAll("_", " ").substring(
                      element.indexOf("pdesc") + 5,
                      element.indexOf("email") - 1);

                  placeDescription.add(pdesc.trim().capitalize());

                  var user = element.replaceAll("_", " ").substring(
                      element.indexOf("email") + 5, element.indexOf("?"));

                  userName.add(user.trim().capitalize());
                });

                return PageView(
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  children: [
                    for (int i = 0; i < datalist.length; i++)
                      ImagePage(
                        image: datalist[i],
                        title: placeName[i],
                        description: placeDescription[i],
                        userName: userName[i],
                      )
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
