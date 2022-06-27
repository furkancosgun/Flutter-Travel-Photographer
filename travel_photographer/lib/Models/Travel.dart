// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Travel {
  String PlaceName;
  String PlaceDescription;
  String PlaceImgUrl;
  Travel({
    required this.PlaceName,
    required this.PlaceDescription,
    required this.PlaceImgUrl,
  });

  factory Travel.fromMap(Map<String, dynamic> map) {
    return Travel(
      PlaceName: map['PlaceName'] as String,
      PlaceDescription: map['PlaceDescription'] as String,
      PlaceImgUrl: map['PlaceImgUrl'] as String,
    );
  }
}
