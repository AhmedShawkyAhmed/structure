// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
  userId: (json['user_id'] as num?)?.toInt(),
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  body: json['body'] as String?,
);

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
  'user_id': ?instance.userId,
  'id': ?instance.id,
  'title': ?instance.title,
  'body': ?instance.body,
};
