import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordo/common/services/update_checker.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit() : super(UpdateState.initial()) {
    checkForUpdates();
  }

  Future<void> checkForUpdates() async {
    emit(UpdateState.loading());

    final updateInfo = await UpdateChecker.checkForUpdates();

    if (updateInfo != null) {
      emit(UpdateState.loaded(updateInfo));
    } else {
      emit(UpdateState.error());
    }
  }

  void dismissUpdate() {
    emit(UpdateState.dismissed());
  }
}

class UpdateState {
  final bool isLoading;
  final bool hasUpdate;
  final Map<String, dynamic>? updateInfo;
  final bool isDismissed;
  final bool hasError;

  UpdateState({
    this.isLoading = false,
    this.hasUpdate = false,
    this.updateInfo,
    this.isDismissed = false,
    this.hasError = false,
  });

  factory UpdateState.initial() {
    return UpdateState();
  }

  factory UpdateState.loading() {
    return UpdateState(isLoading: true);
  }

  factory UpdateState.loaded(Map<String, dynamic> info) {
    return UpdateState(hasUpdate: info['hasUpdate'] == true, updateInfo: info);
  }

  factory UpdateState.error() {
    return UpdateState(hasError: true);
  }

  factory UpdateState.dismissed() {
    return UpdateState(isDismissed: true);
  }
}
