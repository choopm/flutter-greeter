part of 'sign_in.dart';

FormData _$FormDataFromJson(Map<String, dynamic> json) {
  return FormData(
    username: json['username'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$FormDataToJson(FormData instance) => <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

ResponseData _$ResponseDataFromJson(Map<String, dynamic> json) {
  return ResponseData(
    message: json['message'] as String,
    username: json['username'] as String,
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$ResponseDataToJson(ResponseData instance) => <String, dynamic>{
  'message': instance.message,
  'username': instance.username,
  'token': instance.token,
};