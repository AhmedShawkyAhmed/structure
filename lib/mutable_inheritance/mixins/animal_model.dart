import 'package:structure/mutable_inheritance/mixins/mixin_fly.dart';
import 'package:structure/mutable_inheritance/mixins/mixin_swim.dart';

class Animal with Fly, Swim {}

void main() {
  final Animal animal = Animal();
  animal.fly();
  animal.swim();
}
