import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posts_of_user/network/api_service.dart';
import 'package:posts_of_user/network/model/posts_model.dart';
import 'package:provider/provider.dart';

class DetailPost extends StatefulWidget {
  //final ValueChanged<void> postDetail;
  final PostsModel postsModel;
  final String title;

  DetailPost({this.postsModel, this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailPostState();
  }
}

class DetailPostState extends State<DetailPost> {
  final _userNameControler = TextEditingController();
  final _titleControler = TextEditingController();
  final _bodyControler = TextEditingController();
  final _commentControler = TextEditingController();

  void _updatePosts() {
    _userNameControler.text = widget.postsModel.userName;
    _titleControler.text = widget.postsModel.title;
    _bodyControler.text = widget.postsModel.body;
    _commentControler.text = widget.postsModel.comment;
    setState(() {
      final api = Provider.of<ApiService>(context, listen: false);
      api.updatePosts(widget.postsModel.id, widget.postsModel).whenComplete(() {
        print('Hoàn thành');
      }).catchError((onError) {
        print(onError.toString);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _tabs = ['Tab 1', 'Tab 2'];
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                widget.postsModel.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: Text(widget.postsModel.body),
              //bat su kien khi nhan vao ListTitle
              onTap: () {
                _onButtomShowModelSheet();
                print('Tab me');
              },
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 10,
              child: ListTile(
                leading: const Icon(Icons.account_box_rounded),
                subtitle: Text(widget.postsModel.comment),
                //bat su kien khi nhan vao ListTitle
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _onButtomShowModelSheet() {
    showModalBottomSheet(
      context: this.context,
      builder: (context) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(labelText: 'User name'),
                controller: _userNameControler,
                onChanged: (text) {
                  widget.postsModel.userName = text.toString();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(labelText: 'Post title'),
                controller: _titleControler,
                onChanged: (text) {
                  widget.postsModel.title = text.toString();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(labelText: 'Content post'),
                controller: _bodyControler,
                onChanged: (text) {
                  widget.postsModel.body = text.toString();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(labelText: 'comment'),
                controller: _commentControler,
                onChanged: (text) {
                  widget.postsModel.comment = text.toString();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: SizedBox(
                    child: RaisedButton(
                      color: Colors.green,
                      child: Text('Update'),
                      onPressed: () {
                        print('update');
                        setState(() {
                          _updatePosts();
                        });
                        Navigator.of(context)
                            .pop(); //quay lại màn hình trước đó
                      },
                    ),
                    height: 50,
                  )),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Expanded(
                      child: SizedBox(
                    child: RaisedButton(
                      color: Colors.pinkAccent,
                      child: Text('Cancel'),
                      onPressed: () {
                        print('cancel');
                        Navigator.of(context)
                            .pop(); //quay lại màn hình trước đó
                      },
                    ),
                    height: 50,
                  ))
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
