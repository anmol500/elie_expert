library rating_dialog;

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Colors.dart';

class RatingDialog extends StatefulWidget {
  /// The dialog's title
  final Text title;

  /// The dialog's message/description text
  final Text? message;

  /// The top image used for the dialog to be displayed
  final String image;

  /// The rating bar (star icon & glow) color
  final Color starColor;

  /// The size of the star
  final double starSize;

  /// Disables the cancel button and forces the user to leave a rating
  final bool force;

  /// Show or hide the close button
  final bool showCloseButton;

  final commentController;

  /// The initial rating of the rating bar
  final double initialRating;

  /// Display comment input area
  final bool enableComment;

  /// The comment's TextField hint text
  final String commentHint;

  /// The submit button's label/text
  final String submitButtonText;

  /// The submit button's label/text
  final TextStyle submitButtonTextStyle;

  /// Returns a RatingDialogResponse with user's rating and comment values
  final Function(RatingDialogResponse) onSubmitted;

  /// called when user cancels/closes the dialog
  final Function? onCancelled;

  RatingDialog({
    required this.title,
    this.message,
    this.commentController,
    required this.image,
    required this.submitButtonText,
    this.submitButtonTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 17,
    ),
    required this.onSubmitted,
    this.starColor = Colors.amber,
    this.starSize = 40.0,
    this.onCancelled,
    this.showCloseButton = true,
    this.force = false,
    this.initialRating = 0,
    this.enableComment = true,
    this.commentHint = 'Tell us your comments',
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  RatingDialogResponse? _response;

  @override
  void initState() {
    super.initState();
    _response = RatingDialogResponse(rating: widget.initialRating);
  }

  @override
  Widget build(BuildContext context) {
    final _content = Container(
      color: midBlack,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 30, 25, 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                widget.image != 'null'
                    ? Padding(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(image: NetworkImage(widget.image), fit: BoxFit.fill)),
                          height: 130,
                        ),
                        padding: const EdgeInsets.only(top: 25, bottom: 5),
                      )
                    : Container(),
                widget.title,
                widget.message ?? Container(),
                const SizedBox(height: 10),
                Center(
                  child: RatingBar.builder(
                    initialRating: widget.initialRating,
                    glowColor: widget.starColor,
                    minRating: 0,
                    itemSize: widget.starSize,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _response!.rating = rating;
                      });
                    },
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: widget.starColor,
                    ),
                  ),
                ),
                widget.enableComment
                    ? TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        controller: widget.commentController,
                        textAlign: TextAlign.left,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: highLcolorDark),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: highLcolorDark),
                          ),
                          hintText: widget.commentHint,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )
                    : const SizedBox(height: 15),
                TextButton(
                  child: Text(
                    widget.submitButtonText,
                    style: widget.submitButtonTextStyle,
                  ),
                  onPressed: _response!.rating == 0
                      ? null
                      : () {
                          if (!widget.force) Navigator.pop(context);
                          _response!.comment = widget.commentController.text;
                          widget.onSubmitted.call(_response!);
                        },
                ),
              ],
            ),
          ),
          if (!widget.force && widget.onCancelled != null && widget.showCloseButton) ...[
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.onCancelled!.call();
              },
            )
          ]
        ],
      ),
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: _content,
    );
  }
}

class RatingDialogResponse {
  /// The user's comment response
  String comment;

  /// The user's rating response
  double rating;

  RatingDialogResponse({this.rating = 0.0, this.comment = ''});
}
