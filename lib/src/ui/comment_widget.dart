import 'package:flutter/material.dart';
import '../classes/comment.dart';
import 'constants.dart';
import 'small_ui.dart';

class CommentTile extends StatefulWidget {

  final bool isForOwner;
  final Comment comment;
  CommentTile({Key? key, required this.comment, required this.isForOwner})
      : super(key: key);

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var comment = widget.comment;
    var isForOwner = widget.isForOwner;

    return Card(
      child: ExpansionTile(
        title: Text(comment.title),
        leading: buildScore(comment.score),
        subtitle: Text(Strings.formatDate(comment.time), style: Theme.of(context).textTheme.caption,),
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 50,
            margin: EdgeInsets.all(6.0),
            child: Text(comment.message, style: Theme.of(context).textTheme.bodyText1),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).primaryColorDark),
              color: Colors.white
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: isForOwner ? Strings.get('enter-comment-reply-prompt')! : Strings.get('comment-no-response'),
                  icon: Icon(Icons.reply),
                ),
                readOnly: !isForOwner || comment.reply != null,
                initialValue: comment.reply,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.get('empty-reply-error');
                  }
                },
                onSaved: (value) => comment.reply = value,
              ),
            ),
          ),
          if (isForOwner)
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                child: Text(Strings.get('confirm')!),
                onPressed: comment.reply == null ? confirmPressed : null,
              ),
            ),
        ],
        expandedCrossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  void confirmPressed() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _formKey.currentState!.save();
      });
      ScaffoldMessenger.of(context).showSnackBar(showBar(Strings.get('comment-answer-added')!, Duration(milliseconds: 2000)));
    }
  }
}


