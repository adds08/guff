import 'package:pocketbase/pocketbase.dart';

sealed class ChatsState {}

class ChatsViewLoading extends ChatsState {}

class ChatsViewData extends ChatsState {
  final List<RecordModel> data;
  ChatsViewData(this.data);
}

class ChatsViewError extends ChatsState {}
