import 'package:comments_app/comment/controller/comments_controller.dart';
import 'package:comments_app/comment/model/product_model.dart';
import 'package:dio/dio.dart';

class GetCommentsApi {
  GetCommentsApi.init();
  static final GetCommentsApi instance = GetCommentsApi.init();

  getComments({required CommentsController commentsController}) async {
    try {
      commentsController.updateIsLoadingComments(isLoading: true);
      commentsController.updateIsErrorOccuredWhileLoadingComments(error: false);

      final Dio ins = Dio();
      final Response response = await ins.get(
        "https://jsonplaceholder.typicode.com/comments",
      );
      final List<dynamic> jsonList = response.data;

      final List<CommentsModel> comments =
          jsonList.map((jsonItem) => CommentsModel.fromJson(jsonItem)).toList();

      print(comments.length);

      commentsController.updateIsLoadingComments(isLoading: false);
      commentsController.updateIsErrorOccuredWhileLoadingComments(error: false);
      commentsController.updateCommentsList(list: comments);
    } on DioException catch (err) {
      commentsController.updateIsLoadingComments(isLoading: false);
      commentsController.updateIsErrorOccuredWhileLoadingComments(error: true);
      commentsController.errorMessage = err.message!;
    }
  }
}
