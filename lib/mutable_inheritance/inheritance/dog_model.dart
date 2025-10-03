import 'package:core_utils/core_utils.dart';
import 'package:structure/mutable_inheritance/inheritance/animal_interface.dart';

class Dog extends Animal{
  void bark() {
    AppLogs.debugLog('Barking');
  }
}

void main() {
  final Dog dog = Dog();
  dog.eat();
  dog.bark();
}