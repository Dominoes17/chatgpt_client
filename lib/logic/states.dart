import 'package:equatable/equatable.dart';

abstract class States extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends States {}

class ChangeModelSuccessState extends States {
  final String model;

  ChangeModelSuccessState({required this.model});
}

class ChangeChatSuccessState extends States {
  final String chat;

  ChangeChatSuccessState({required this.chat});
}

class LoadingState extends States {
  LoadingState();
}
