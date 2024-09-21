import 'package:comments_app/comment/controller/comments_controller.dart';
import 'package:comments_app/comment/model/product_model.dart';
import 'package:comments_app/config/theme/app_theme.dart';
import 'package:comments_app/services/remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Comment extends StatefulWidget {
  const Comment({
    super.key,
    required this.commentsModel,
  });

  final CommentsModel commentsModel;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((s) {
      final commentsController = context.read<CommentsController>();
      commentsController.updateEmail(
          b: FirebaeRemote.instance.remoteConfig.getBool("maskEmail"));

      FirebaeRemote.instance.remoteConfig.onConfigUpdated.listen((e) {
        FirebaeRemote.instance.remoteConfig.onConfigUpdated
            .listen((event) async {
          await FirebaeRemote.instance.remoteConfig.activate();
          commentsController.updateEmail(
              b: FirebaeRemote.instance.remoteConfig.getBool("maskEmail"));
          // Use the new config values here.
          debugPrint(commentsController.maskEmail.toString());
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.sp)),
      padding: const EdgeInsets.only(top: 12, left: 10, bottom: 9, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: AppThemeData.nameCircleColor,
            child: Center(
              child: Text(
                widget.commentsModel.name?[0].toUpperCase() ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .merge(GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                    )),
              ),
            ),
          ),
          SizedBox(
            width: 13.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name : ",
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                        GoogleFonts.poppins(
                            color: AppThemeData.nameCircleColor,
                            fontStyle: FontStyle.italic)),
                  ),
                  SizedBox(
                    width: 230.w,
                    child: Text(
                      widget.commentsModel.name ?? '',
                      style: Theme.of(context).textTheme.titleSmall!.merge(
                          GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email : ",
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                        GoogleFonts.poppins(
                            color: AppThemeData.nameCircleColor,
                            fontStyle: FontStyle.italic)),
                  ),
                  Consumer<CommentsController>(
                      builder: (context, commentsController, child) {
                    return SizedBox(
                      width: 230.w,
                      child: Text(
                        commentsController.maskEmail
                            ? maskEmail(widget.commentsModel.email!)
                            : widget.commentsModel.email ?? '',
                        style: Theme.of(context).textTheme.titleSmall!.merge(
                            GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
                  })
                ],
              ),
              SizedBox(
                width: 250.w,
                child: Text(widget.commentsModel.body ?? '',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .merge(GoogleFonts.poppins(color: Colors.black))),
              ),
            ],
          )
        ],
      ),
    );
  }

  String maskEmail(String email) {
    // Split the email into username and domain parts
    final parts = email.split('@');
    if (parts.length != 2) {
      return email; // Invalid email format
    }

    final username = parts[0];
    final domain = parts[1];

    // Mask the username part
    if (username.length <= 3) {
      // If the username is 3 or fewer characters, just return it as is
      return email;
    }

    final maskedUsername =
        username.substring(0, 3) + '*' * (username.length - 3);
    return '$maskedUsername@$domain';
  }
}
