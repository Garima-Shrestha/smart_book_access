import 'package:equatable/equatable.dart';
import 'package:smart_book_access/features/history/domain/entities/history_entity.dart';

enum HistoryStatus {
  initial,
  loading,
  loaded,
  error,
}

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<HistoryEntity> historyList;
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.historyList = const [],
    this.errorMessage,
  });

  // copyWith
  HistoryState copyWith({
    HistoryStatus? status,
    List<HistoryEntity>? historyList,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      historyList: historyList ?? this.historyList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, historyList, errorMessage];
}