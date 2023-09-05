import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:hecticai/logic/events.dart';
import 'package:hecticai/logic/states.dart';

class ProductBloc extends Bloc<Events, States> {
  ProductBloc() : super(InitialState()) {
    on<ChangeModel>((event, emit) {
      try {
        String model = event.model;
        log("Change Model :: ${event.model}");
        emit(ChangeModelSuccessState(model: model));
        emit(InitialState());
      } catch (e) {
        log("Change Model Error:: $e");
        emit(InitialState());
      }
    });

    on<ChangeChat>((event, emit) {
      try {
        String chat = event.chat;
        log("Change Chat :: ${event.chat}");
        emit(ChangeChatSuccessState(chat: chat));
        //  emit(InitialState());
      } catch (e) {
        log("Change Chat Error:: $e");
        emit(InitialState());
      }
    });
  }
}
