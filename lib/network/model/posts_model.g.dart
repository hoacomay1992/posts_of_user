// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostsModel _$PostsModelFromJson(Map<String, dynamic> json) {
  return PostsModel(
    id: json['id'] as String,
    userName: json['userName'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
    comment: json['comment'] as String,
  );
}

Map<String, dynamic> _$PostsModelToJson(PostsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'title': instance.title,
      'body': instance.body,
      'comment': instance.comment,
    };
