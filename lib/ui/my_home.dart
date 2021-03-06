import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:posts_of_user/network/api_service.dart';
import 'package:posts_of_user/network/model/posts_model.dart';
import 'package:posts_of_user/ui/detail_posts.dart';
import 'package:provider/provider.dart';

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomeState();
  }
}

class _MyHomeState extends State<MyHome> {
  final GlobalKey<ScaffoldState> _scaffKey = new GlobalKey<ScaffoldState>();
  final _userNameControler = TextEditingController();
  final _titleControler = TextEditingController();
  final _bodyControler = TextEditingController();
  final _commentControler = TextEditingController();
  PostsModel _postsModel =
      PostsModel(id: '', userName: '', title: '', body: '', comment: '');
  List<PostsModel> listPost = List<PostsModel>();

  void _insertPosts() {
    //validate data of transaction
    if (_postsModel.userName.isEmpty ||
        _postsModel.title.isEmpty ||
        _postsModel.body.isEmpty ||
        _postsModel.comment.isEmpty) {
      Navigator.of(context).pop();
      _showSnackBar("Data cannot be left blank");
      return;
    }

    final api = Provider.of<ApiService>(context, listen: false);
    api.insertPosts(_postsModel).whenComplete(() {
      _showSnackBar("Data cannot be left blank");
      print('Hoàn thành');
    }).catchError((onError) {
      print(onError.toString);
    });
    _userNameControler.text = '';
    _titleControler.text = '';
    _bodyControler.text = '';
    _commentControler.text = '';
  }

  void _showSnackBar(String message) {
    _scaffKey.currentState.showSnackBar(SnackBar(
      content: Text('$message'),
      duration: Duration(seconds: 2),
    ));
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
                  _postsModel.userName = text.toString();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(labelText: 'Post title'),
                controller: _titleControler,
                onChanged: (text) {
                  _postsModel.title = text.toString();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(labelText: 'Content post'),
                controller: _bodyControler,
                onChanged: (text) {
                  _postsModel.body = text.toString();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(labelText: 'comment'),
                controller: _commentControler,
                onChanged: (text) {
                  _postsModel.comment = text.toString();
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
                      child: Text('Add'),
                      onPressed: () {
                        print('Add');
                        setState(() {
                          _insertPosts();
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'List Post And Users',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 10, right: 10),
        child: _listFuturePosts(context),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //async
          // final api = Provider.of<ApiService>(context, listen: false);
          // api.getPosts().then((value) {
          //   value.forEach((element) {
          //     print(element.userName);
          //   });
          // }).catchError((onError) {
          //   print(onError.toString);
          // });
          _onButtomShowModelSheet();
          print('Waiting to add functionality');
        },
      ),
    );
  }

  FutureBuilder _listFuturePosts(BuildContext context) {
    return FutureBuilder<List<PostsModel>>(
      future: Provider.of<ApiService>(context, listen: false).getPosts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<PostsModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('error not connected'),
              ),
            );
          }
          //final post = snapshot.data;
          listPost = snapshot.data;
          return _listNewPosts(context: context, posts: listPost);
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  ListView _listPosts({BuildContext context, List<PostsModel> posts}) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListTile(
              leading: Text(posts[index].title),
              title: Text(posts[index].userName),
            ),
          ),
        );
      },
    );
  }

  ListView _listNewPosts({BuildContext context, List<PostsModel> posts}) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(posts[index].toString()),
          background: Container(
            color: Colors.red,
            alignment: AlignmentDirectional.centerEnd,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              final api = Provider.of<ApiService>(context, listen: false);
              api.deletePosts(posts[index].id).whenComplete(() {
                print('delete success');
              }).catchError((onError) {
                print(onError.toString);
              });
              posts.removeAt(index);
            });
          },
          direction: DismissDirection.endToStart,
          child: GestureDetector(
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: (index - 1) % 2 == 0
                    ? Colors.lightGreen
                    : Colors.pinkAccent,
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_balance,
                              color: Colors.white,
                            ),
                            Text(
                              ' ${posts[index].title}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_box_rounded,
                              color: Colors.white,
                            ),
                            Text(
                              ' ${posts[index].userName}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Show detail',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                      ],
                    ),
                  ],
                )),
            onTap: () {
              _postsModel = posts[index];
              _onTapped(_postsModel);
            },
          ),
        );
      },
    );
  }

  void _onTapped(PostsModel postsModel) {
    print('click');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPost(
                  title: 'list comment of post',
                  postsModel: _postsModel,
                )));
  }
}
