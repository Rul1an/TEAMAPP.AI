// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/training.dart';
import '../repositories/training_repository.dart';
import 'trainings_provider.dart';

class TrainingEditState {
  const TrainingEditState({
    required this.training,
    this.isLoading = false,
    this.error,
  });

  final Training? training;
  final bool isLoading;
  final String? error;

  TrainingEditState copyWith({
    Training? training,
    bool? isLoading,
    String? error,
  }) => TrainingEditState(
    training: training ?? this.training,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

class TrainingEditViewModel extends StateNotifier<TrainingEditState> {
  TrainingEditViewModel(this.ref, this.trainingId)
    : super(const TrainingEditState(training: null, isLoading: true)) {
    _load();
  }

  final Ref ref;
  final String trainingId;

  Future<void> _load() async {
    final repo = ref.read(trainingRepositoryProvider);
    final res = await repo.getById(trainingId);
    if (res.isSuccess) {
      state = state.copyWith(training: res.dataOrNull, isLoading: false);
    } else {
      state = state.copyWith(error: res.errorOrNull?.message, isLoading: false);
    }
  }

  Future<bool> save(Training updated) async {
    state = state.copyWith(isLoading: true, error: null);
    final repo = ref.read(trainingRepositoryProvider);
    final res = await repo.update(updated);
    if (!res.isSuccess) {
      state = state.copyWith(isLoading: false, error: res.errorOrNull?.message);
      return false;
    }
    state = state.copyWith(training: updated, isLoading: false);
    return true;
  }
}

final trainingEditViewModelProvider =
    StateNotifierProvider.family<
      TrainingEditViewModel,
      TrainingEditState,
      String
    >((ref, trainingId) {
      return TrainingEditViewModel(ref, trainingId);
    });
