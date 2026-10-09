import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../data/issue_draft_store.dart';
import '../data/issue_report.dart';
import '../data/issue_report_repository.dart';
import '../data/report_diagnostics_service.dart';
import '../data/report_media_service.dart';

class IssueReportCubit extends Cubit<IssueReportState> {
  IssueReportCubit({
    required this._repository,
    required this._store,
    required this._media,
    required String screen,
    this._diagnostics = const ReportDiagnosticsService(),
  }) : super(IssueReportState(id: const Uuid().v4(), screen: screen));

  final IssueReportRepository _repository;
  final IssueDraftStore _store;
  final ReportMediaService _media;
  final ReportDiagnosticsService _diagnostics;
  Timer? _saveTimer;
  CancelToken? _cancelToken;
  bool _discarded = false;

  bool get configured => _repository.configured;
  bool get simulated => _repository.simulated;
  bool get _editable => !isClosed && !state.sending && !state.preparing;

  Future<void> initialize({XFile? screenshot}) async {
    emit(state.copyWith(preparing: true));
    try {
      final saved = await _store.load();
      if (isClosed) {
        return;
      }
      if (saved != null) {
        emit(saved.copyWith(preparing: true));
      }
      final recovered = await _media.recoverLostMedia();
      for (final file in [?screenshot, ...recovered]) {
        final item = await _media.prepare(file, state.attachments);
        if (isClosed) {
          return;
        }
        emit(
          state.copyWith(
            id: const Uuid().v4(),
            attachments: List.unmodifiable([...state.attachments, item]),
          ),
        );
      }
    } on ReportException catch (error) {
      if (!isClosed) {
        emit(state.copyWith(problem: error.problem));
      }
    } on Object {
      if (!isClosed) {
        emit(state.copyWith(problem: ReportProblem.storageUnavailable));
      }
    } finally {
      if (!isClosed) {
        final problem = state.problem;
        emit(state.copyWith(preparing: false, problem: problem));
        _scheduleSave();
      }
    }
  }

  void _edit(IssueReportState updated) {
    _discarded = false;
    emit(
      updated.copyWith(
        id: const Uuid().v4(),
        consent: false,
        status: ReportStatus.editing,
        progress: 0,
      ),
    );
    _scheduleSave();
  }

  void descriptionChanged(String value) {
    if (_editable) {
      _edit(state.copyWith(description: value));
    }
  }

  void expectedChanged(String value) {
    if (_editable) {
      _edit(state.copyWith(expected: value));
    }
  }

  void consentChanged({required bool consent}) {
    if (_editable) {
      emit(state.copyWith(consent: consent));
    }
  }

  Future<void> diagnosticsChanged({required bool enabled}) async {
    if (!_editable) {
      return;
    }
    if (!enabled) {
      _edit(state.copyWith(removeDiagnostics: true));
      return;
    }
    emit(state.copyWith(preparing: true, consent: false));
    try {
      final details = await _diagnostics.collect();
      if (!isClosed) {
        _edit(state.copyWith(diagnostics: details));
      }
    } on Object {
      if (!isClosed) {
        emit(state.copyWith(problem: ReportProblem.diagnosticsUnavailable));
      }
    } finally {
      if (!isClosed) {
        emit(state.copyWith(preparing: false, problem: state.problem));
      }
    }
  }

  Future<void> addImages() => _pick(() => _media.pickImages());

  Future<void> addVideo() => _pick(() async {
    final file = await _media.pickVideo();
    return [?file];
  });

  Future<void> _pick(Future<List<XFile>> Function() pick) async {
    if (!_editable) {
      return;
    }
    emit(state.copyWith(preparing: true));
    try {
      await _persist();
      final files = await pick();
      for (final file in files) {
        if (isClosed) {
          return;
        }
        final item = await _media.prepare(file, state.attachments);
        if (isClosed) {
          return;
        }
        _edit(
          state.copyWith(
            attachments: List.unmodifiable([...state.attachments, item]),
          ),
        );
      }
    } on ReportException catch (error) {
      if (!isClosed) {
        emit(state.copyWith(problem: error.problem));
      }
    } on Object {
      if (!isClosed) {
        emit(state.copyWith(problem: ReportProblem.mediaUnavailable));
      }
    } finally {
      if (!isClosed) {
        emit(state.copyWith(preparing: false, problem: state.problem));
      }
    }
  }

  Future<void> removeAttachment(ReportAttachment item) async {
    if (!_editable) {
      return;
    }
    _edit(
      state.copyWith(
        attachments: state.attachments.where((entry) => entry != item).toList(),
      ),
    );
    try {
      await _persist();
      await _store.removeAttachment(item);
    } on Object {
      if (!isClosed) {
        emit(state.copyWith(problem: ReportProblem.storageUnavailable));
      }
    }
  }

  Future<void> submit() async {
    if (!_editable || state.status == ReportStatus.sent) {
      return;
    }
    if (state.description.trim().isEmpty) {
      emit(state.copyWith(problem: ReportProblem.descriptionRequired));
      return;
    }
    if (!state.consent) {
      emit(state.copyWith(problem: ReportProblem.consentRequired));
      return;
    }
    if (!configured) {
      emit(state.copyWith(problem: ReportProblem.notConfigured));
      return;
    }
    final token = CancelToken();
    _cancelToken = token;
    emit(state.copyWith(status: ReportStatus.sending, progress: 0));
    try {
      try {
        await _persist();
      } on Object {
        throw const ReportException(ReportProblem.storageUnavailable);
      }
      final reference = await _repository.submit(
        state,
        cancelToken: token,
        onProgress: (sent, total) {
          if (!isClosed && state.sending && total > 0) {
            emit(state.copyWith(progress: (sent / total).clamp(0, 1)));
          }
        },
      );
      if (isClosed) {
        return;
      }
      emit(
        state.copyWith(
          status: ReportStatus.sent,
          reference: reference,
          progress: 1,
        ),
      );
      try {
        await _store.clear();
      } on Object {
        // Receipt is authoritative even if local cleanup fails.
      }
    } on ReportException catch (error) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: error.problem == ReportProblem.cancelled
                ? ReportStatus.editing
                : ReportStatus.failed,
            problem: error.problem,
          ),
        );
      }
    } on Object {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ReportStatus.failed,
            problem: ReportProblem.uploadFailed,
          ),
        );
      }
    } finally {
      _cancelToken = null;
    }
  }

  void cancelUpload() => _cancelToken?.cancel();

  Future<void> discard() async {
    if (!_editable) {
      return;
    }
    _saveTimer?.cancel();
    await _store.clear();
    _discarded = true;
    emit(IssueReportState(id: const Uuid().v4(), screen: state.screen));
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 350), () async {
      try {
        await _persist();
      } on Object {
        if (!isClosed && !state.sending) {
          emit(state.copyWith(problem: ReportProblem.storageUnavailable));
        }
      }
    });
  }

  Future<void> _persist() {
    _saveTimer?.cancel();
    return _store.save(state);
  }

  @override
  Future<void> close() async {
    _saveTimer?.cancel();
    cancelUpload();
    if (!_discarded && state.status != ReportStatus.sent) {
      try {
        await _persist();
      } on Object {
        // The form already reports storage failures while it is open.
      }
    }
    return super.close();
  }
}
