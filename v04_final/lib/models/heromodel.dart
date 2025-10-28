import 'package:uuid/uuid.dart';

import 'appearance.dart';
import 'biography.dart';
import 'connections.dart';
import 'heroimage.dart';
import 'powerstats.dart';
import 'work.dart';

class HeroModel {
  final String id;
  final String name;
  final Powerstats powerstats;
  final Biography biography;
  final Appearance appearance;
  final Work work;
  final Connections connections;
  final HeroImage image;

  HeroModel({
    String? id,
    required this.name,
    required this.powerstats,
    required this.biography,
    required this.appearance,
    required this.work,
    required this.connections,
    required this.image,
  }) : id = id ?? _generateId();

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: json['id'] as String?,
      name: json['name'] ?? '',
      powerstats: Powerstats.fromJson(json['powerstats'] ?? {}),
      biography: Biography.fromJson(json['biography'] ?? {}),
      appearance: Appearance.fromJson(json['appearance'] ?? {}),
      work: Work.fromJson(json['work'] ?? {}),
      connections: Connections.fromJson(json['connections'] ?? {}),
      image: HeroImage.fromJson(json['image'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'powerstats': powerstats.toJson(),
      'biography': biography.toJson(),
      'appearance': appearance.toJson(),
      'work': work.toJson(),
      'connections': connections.toJson(),
      'image': image.toJson(),
    };
  }

  @override
  String toString() {
    return 'HeroModel{id: $id, name: $name, strength: ${powerstats.strength}}';
  }

  static String _generateId() {
    const uuid = Uuid();
    return uuid.v4();
  }
}