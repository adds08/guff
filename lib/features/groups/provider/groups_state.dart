import 'package:pocketbase/pocketbase.dart';

sealed class GroupsState {}

class GroupsViewLoading extends GroupsState {}

class GroupsViewData extends GroupsState {
  final List<RecordModel> data;
  GroupsViewData(this.data);
}

class GroupsViewError extends GroupsState {}
