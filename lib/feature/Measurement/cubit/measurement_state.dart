import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/model/MeasurementModel.dart';

part 'measurement_state.freezed.dart';

@freezed
class MeasurementState with _$MeasurementState {
  const factory MeasurementState.initial() = MeasurementInitial;
  const factory MeasurementState.uploadLoading() = UploadLoading;
  const factory MeasurementState.uploadProgress(int progress) = UploadProgress;
  const factory MeasurementState.uploadSuccess(MeasurementModel measurement) = UploadSuccess;
  const factory MeasurementState.uploadError(String error) = UploadError;
}