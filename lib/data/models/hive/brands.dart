// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

part 'brands.g.dart';

@HiveType(typeId: 0)
class Brand extends HiveObject {
  @HiveField(0)
  String logo;
  @HiveField(1)
  String label;
  Brand({
    required this.logo,
    required this.label,
  });
}
