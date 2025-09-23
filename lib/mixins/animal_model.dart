import 'package:structure/mixins/mixin_fly.dart';
import 'package:structure/mixins/mixin_swim.dart';

class Animal with Fly, Swim {}

void main() {
  final Animal animal = Animal();
  animal.fly();
  animal.swim();
}
