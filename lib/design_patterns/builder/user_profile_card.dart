import 'package:flutter/material.dart';

// Usage example of the Builder Pattern
void main() {
  UserProfileCardBuilder()
      .setName('Ahmed Shawky')
      .setEmail('ahmed@test.com')
      .setImage('https://picsum.photos/200')
      .build();
}

// Builder Pattern for User Profile Card
class UserProfileCard extends StatelessWidget {
  final String name;
  final String? image;
  final String? email;

  UserProfileCard._builder(UserProfileCardBuilder builder)
    : name = builder.name!,
      image = builder.image,
      email = builder.email;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: image != null
            ? Image.network(image!)
            : const Icon(Icons.person),
        title: Text(name),
        subtitle: email != null ? Text(email!) : null,
      ),
    );
  }
}

class UserProfileCardBuilder {
  String? name;
  String? image;
  String? email;

  UserProfileCardBuilder setName(String name) {
    this.name = name;
    return this;
  }

  UserProfileCardBuilder setImage(String image) {
    this.image = image;
    return this;
  }

  UserProfileCardBuilder setEmail(String email) {
    this.email = email;
    return this;
  }

  UserProfileCard build() {
    if (name == null) {
      throw Exception('Name is required!');
    }
    return UserProfileCard._builder(this);
  }
}
