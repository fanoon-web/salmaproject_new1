import 'package:dartz/dartz.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import 'button_state.dart';
class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  Future<void> execute({
    dynamic params,
    required UseCase usecase,
    void Function()? onSuccess,               // ← أضف هذا
    void Function(String error)? onFailure,   // ← وأيضاً هذا
  }) async {
    emit(ButtonLoadingState());
    try {
      Either returnedData = await usecase.call(params: params);
      returnedData.fold(
            (error) {
          emit(ButtonFailureState(errorMessage: error));
          if (onFailure != null) onFailure(error.toString());   // استدعي callback الفشل
        },
            (data) {
          emit(ButtonSuccessState());
          if (onSuccess != null) onSuccess();                    // استدعي callback النجاح
        },
      );
    } catch (e) {
      emit(ButtonFailureState(errorMessage: e.toString()));
      if (onFailure != null) onFailure(e.toString());
    }
  }
}
