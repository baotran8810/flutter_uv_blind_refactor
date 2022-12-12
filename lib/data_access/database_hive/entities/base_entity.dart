import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class BaseEntity extends HiveObject {
  @HiveField(0)
  final String id;

  BaseEntity({String? id}) : id = id ?? const Uuid().v4();
}
