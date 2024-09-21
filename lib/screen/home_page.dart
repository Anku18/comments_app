import 'package:comments_app/authentication/firebase/auth.dart';
import 'package:comments_app/comment/api/get_comments.dart';
import 'package:comments_app/comment/controller/comments_controller.dart';
import 'package:comments_app/comment/model/product_model.dart';
import 'package:comments_app/widgets/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  int pageNo = 0;
  bool hasFetchedData = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final commentsController = context.read<CommentsController>();

      GetCommentsApi.instance
          .getComments(commentsController: commentsController);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Comments"),
        actions: [
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  onTap: () {
                    _logout(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Consumer<CommentsController>(
        builder: (context, commentsController, child) {
          if (commentsController.isLoadingComments) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (commentsController.isErrOccuredWhileLoadingComments) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Server Error Occurred",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(commentsController.errorMessage),
                ],
              ),
            );
          }
          if (commentsController.commentsList.isEmpty) {
            return Center(
              child: Text(
                "No Comments Found",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.all(24.sp),
                  shrinkWrap: true,
                  itemCount: commentsController.commentsList.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 15.h,
                  ),
                  itemBuilder: (_, index) {
                    final CommentsModel commentsModel =
                        commentsController.commentsList.elementAt(index);
                    return Comment(commentsModel: commentsModel);
                  },
                ),
              ),
              if (commentsController.isPaginating)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.sp,
                        ),
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: Theme.of(context).textTheme.titleMedium!.merge(
                GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                    fontSize: 20.sp)),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Authentication.instance.auth.signOut();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
