import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.userName,
  }) : super(key: key);
  final String image;
  final String title;
  final String description;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image:
              DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(begin: Alignment.bottomRight, stops: const [
          0.3,
          0.9
        ], colors: [
          Colors.black.withOpacity(.9),
          Colors.black.withOpacity(.2),
        ])),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.headline1),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        userName,
                        style: GoogleFonts.whisper(
                            color: Colors.white, height: 1, fontSize: 32),
                      ),
                    ],
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
