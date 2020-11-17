import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

part 'posts_model.g.dart';

@JsonSerializable()
class PostsModel {
  String id;
  String userName;
  String title;
  String body;
  String comment;

  PostsModel({this.id, this.userName, this.title, this.body, this.comment});

  factory PostsModel.fromJson(Map<String, dynamic> json) =>
      _$PostsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostsModelToJson(this);


}
