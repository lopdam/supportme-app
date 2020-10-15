import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Models/comment_model.dart';
import 'package:supportme_app/Services/comment_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/common/circle_Indicator.dart';
import 'package:supportme_app/screens/login/Login/login_screen.dart';

class CommentListHueca extends StatefulWidget {
  int _hueca;

  CommentListHueca(this._hueca);

  @override
  _CommentListHueca createState() {
    return _CommentListHueca(_hueca);
  }
}

class _CommentListHueca extends State<CommentListHueca> {
  BuildContext _context;
  int _hueca;
  bool _loadComments;
  List<Widget> _listCommentWidget;
  Widget _listView;
  int _flexMain;
  int _flexComment;
  TextEditingController _editingController;

  _CommentListHueca(this._hueca);

  @override
  void initState() {
    super.initState();
    _flexMain = 8;
    _flexComment = 1;

    _loadComments = false;
    _listCommentWidget = List();
    CommentService.getComments(hueca: _hueca)
        .then((comments) => {_addComments(comments)});
  }

  @override
  Widget build(BuildContext context) {
    _editingController = TextEditingController(text: "");
    _context = context;
    return (_loadComments) ? _mainContainer() : CircleIndicator();
  }

  Widget _mainContainer() {
    return Column(
      children: [
        Expanded(flex: _flexMain, child: _listView),
        Expanded(
            flex: _flexComment,
            child: Card(
              elevation: 3.5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: TextField(
                    controller: _editingController,
                    onTap: () {
                      _expandedComment();
                    },
                    onSubmitted: (value) {
                      _summitComment();
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: "Comentar...",
                        fillColor: AppColors.mainColor),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  void _expandedComment() {
    if (!AccountSave.isLogin()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    } else {
      setState(() {
        _flexMain = 1;
        _flexComment = 8;
      });
    }
  }

  void _summitComment() {
    String content = _editingController.text;
    if (content != "") {
      Util.shortToast(context: _context, msg: "Enviando...");
      _loadComments = false;
      CommentService.post_comment(hueca: _hueca, content: content)
          .then((value) => {
                CommentService.getComments(hueca: _hueca)
                    .then((comments) => {_addComments(comments)})
              });
    }

    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).unfocus();
      _flexMain = 8;
      _flexComment = 1;
    });
  }

  void _addComments(List<CommentModel> comments) {
    if (comments.length != 0) {
      _listCommentWidget.clear();
      for (CommentModel comment in comments) {
        _listCommentWidget.add(_listTile(comment: comment));
      }
      _listView = ListView(
        children: _listCommentWidget,
      );
    } else {
      _listView = Center(
        child: Text("No existen Comentarios"),
      );
    }
    _loadComments = true;
    setState(() {});
  }

  Widget _listTile({CommentModel comment}) {
    return Card(
      elevation: 3.5,
      child: ListTile(
        title: Text(comment.content),
        subtitle: Text(comment.commentDate()),
        trailing: deleteCommentWidget(comment),
      ),
    );
  }

  Widget deleteCommentWidget(CommentModel comment) {
    return Visibility(
      visible: AccountSave.isLogin() && comment.user == AccountSave.id,
      child: GestureDetector(
        onTap: () => deleteComment(comment.id),
        child: Icon(Icons.clear),
      ),
    );
  }

  void deleteComment(int comment) {
    _loadComments = false;
    CommentService.delete_comment(comment: comment).then((value) => {
          if (value)
            {
              CommentService.getComments(hueca: _hueca)
                  .then((comments) => {_addComments(comments)})
            }
        });
    setState(() {});
  }
}
