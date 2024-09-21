import 'package:comments_app/comment/model/product_model.dart';
import 'package:flutter/material.dart';

class CommentsController with ChangeNotifier {
  List<CommentsModel> commentsList = [];

  bool isLoadingComments = false;
  bool isErrOccuredWhileLoadingComments = false;
  String errorMessage = "";
  bool maskEmail = false;
  bool hasInternetConnection = true;

  void updateCommentsList({required List<CommentsModel> list}) {
    commentsList.clear();
    commentsList.addAll(list);
    notifyListeners();
  }

  void updateIsLoadingComments({required bool isLoading}) {
    isLoadingComments = isLoading;
    notifyListeners();
  }

  void updateIsErrorOccuredWhileLoadingComments({required bool error}) {
    isErrOccuredWhileLoadingComments = error;
    notifyListeners();
  }

  bool isPaginating = false;
  void updateIsPaginating(bool v) {
    isPaginating = v;
    notifyListeners();
  }

  void addComment({required List<CommentsModel> list}) {
    commentsList.addAll(list);
    notifyListeners();
  }

  void updateEmail({required bool b}) {
    maskEmail = b;
    notifyListeners();
  }
}
