import 'package:json_annotation/json_annotation.dart';

part 'sms_request_model.g.dart';

@JsonSerializable()
class SmsRequestModel {
  final String to;
  final String message;
  final String? patientId;

  SmsRequestModel({
    required this.to,
    required this.message,
    this.patientId,
  });

  factory SmsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SmsRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SmsRequestModelToJson(this);
}
