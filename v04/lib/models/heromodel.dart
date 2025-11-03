import 'package:uuid/uuid.dart';

import '../config/constants.dart';
import 'appearance.dart';
import 'biography.dart';
import 'connections.dart';
import 'heroimage.dart';
import 'powerstats.dart';
import 'work.dart';

class HeroModel {
  final String id;
  final String? externalId;
  final String name;
  final Powerstats powerstats;
  final Biography biography;
  final Appearance appearance;
  final Work work;
  final Connections connections;
  final HeroImage image;

  HeroModel({
    String? id,
    this.externalId,
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
      id: json['id'] ?? _generateId(),
      externalId: json['external_id'],
      name: json['name'] ?? '',
      powerstats: Powerstats.fromJson(json['powerstats'] ?? {}),
      biography: Biography.fromJson(json['biography'] ?? {}),
      appearance: Appearance.fromJson(json['appearance'] ?? {}),
      work: Work.fromJson(json['work'] ?? {}),
      connections: Connections.fromJson(json['connections'] ?? {}),
      image: HeroImage.fromJson(json['image'] ?? {}),
    );
  }

  /// Returns a string representation of the character type.
  /// Either "Hero" or "Villain".
  String get characterType => isHero ? 'Hero' : 'Villain';

  /// Returns true if the character is a hero, false if a villain.
  /// Based on the character's alignment from their biography.
  bool get isHero {
    // Check if alignment is null or empty
    final alignment = biography.alignment;
    if (alignment.isEmpty) {
      // For null/empty alignments, default to hero
      // (assuming most characters in a hero database are heroes)
      return true;
    }
    
    final alignmentLower = alignment.toLowerCase().trim();
    
    // Check if alignment matches any hero alignments
    if (AppConstants.heroAlignments.contains(alignmentLower)) {
      return true;
    }
    
    // Check if alignment matches any villain alignments
    if (AppConstants.villainAlignments.contains(alignmentLower)) {
      return false;
    }
    
    // For unknown alignments not in either list, default to hero
    return true;
  }

  /// Returns true if the character is a villain, false if a hero.
  /// This is the inverse of isHero for convenience.
  bool get isVillain => !isHero;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'external_id': externalId,
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
    return 'HeroModel{id: $id, externalId: $externalId, name: $name, strength: ${powerstats.strength}}';
  }

  static String _generateId() {
    const uuid = Uuid();
    return uuid.v4().trim().substring(0, 15);
  }
}