class SupabaseSignUpRequestModel {
  final String email;
  final String password;
  final Map<String, dynamic>? data;

  const SupabaseSignUpRequestModel({
    required this.email,
    required this.password,
    this.data,
  });

  factory SupabaseSignUpRequestModel.fromJson(Map<String, dynamic> json) {
    return SupabaseSignUpRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (data != null) 'data': data,
    };
  }
}

class SupabaseSignInRequestModel {
  final String email;
  final String password;

  const SupabaseSignInRequestModel({
    required this.email,
    required this.password,
  });

  factory SupabaseSignInRequestModel.fromJson(Map<String, dynamic> json) {
    return SupabaseSignInRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class SupabasePasswordResetRequestModel {
  final String email;

  const SupabasePasswordResetRequestModel({
    required this.email,
  });

  factory SupabasePasswordResetRequestModel.fromJson(Map<String, dynamic> json) {
    return SupabasePasswordResetRequestModel(
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}