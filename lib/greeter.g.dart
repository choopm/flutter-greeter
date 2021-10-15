part of 'greeter.dart';

FormData _$FormDataFromJson(Map<String, dynamic> json) {
  return FormData(
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$FormDataToJson(FormData instance) => <String, dynamic>{
      'name': instance.name,
    };

ResponseData _$ResponseDataFromJson(Map<String, dynamic> json) {
  return ResponseData(
    message: json['message'] as String,
    greeting: json['greeting'] as String,
  );
}

Map<String, dynamic> _$ResponseDataToJson(ResponseData instance) => <String, dynamic>{
  'message': instance.message,
  'greeting': instance.greeting,
};