import '../data/model/MeasurementModel.dart';

abstract class MeasurementState {
  const MeasurementState();
}

class MeasurementInitial extends MeasurementState {
  const MeasurementInitial();
}

class UploadLoading extends MeasurementState {
  const UploadLoading();
}

class UploadProgress extends MeasurementState {
  final int progress;
  const UploadProgress(this.progress);
}

class UploadSuccess extends MeasurementState {
  final MeasurementModel measurement;
  const UploadSuccess(this.measurement);
}

class UploadError extends MeasurementState {
  final String error;
  const UploadError(this.error);
}