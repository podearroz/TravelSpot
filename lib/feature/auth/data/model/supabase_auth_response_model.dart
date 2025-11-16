class SupabaseAuthResponseModel {
  final String? accessToken;
  final String? tokenType;
  final int? expiresIn;
  final int? expiresAt;
  final String? refreshToken;
  final SupabaseUserModel? user;
  final SupabaseSessionModel? session;

  const SupabaseAuthResponseModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.expiresAt,
    this.refreshToken,
    this.user,
    this.session,
  });

  factory SupabaseAuthResponseModel.fromJson(Map<String, dynamic> json) {
    return SupabaseAuthResponseModel(
      accessToken: json['access_token'] as String?,
      tokenType: json['token_type'] as String?,
      expiresIn: json['expires_in'] as int?,
      expiresAt: json['expires_at'] as int?,
      refreshToken: json['refresh_token'] as String?,
      user: json['user'] != null 
        ? SupabaseUserModel.fromJson(json['user'] as Map<String, dynamic>)
        : null,
      session: json['session'] != null
        ? SupabaseSessionModel.fromJson(json['session'] as Map<String, dynamic>)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'expires_at': expiresAt,
      'refresh_token': refreshToken,
      'user': user?.toJson(),
      'session': session?.toJson(),
    };
  }
}

class SupabaseUserModel {
  final String id;
  final String? aud;
  final String? role;
  final String? email;
  final String? emailConfirmedAt;
  final String? phone;
  final String? confirmationSentAt;
  final String? confirmedAt;
  final String? lastSignInAt;
  final Map<String, dynamic>? appMetadata;
  final Map<String, dynamic>? userMetadata;
  final List<SupabaseIdentityModel>? identities;
  final String? createdAt;
  final String? updatedAt;

  const SupabaseUserModel({
    required this.id,
    this.aud,
    this.role,
    this.email,
    this.emailConfirmedAt,
    this.phone,
    this.confirmationSentAt,
    this.confirmedAt,
    this.lastSignInAt,
    this.appMetadata,
    this.userMetadata,
    this.identities,
    this.createdAt,
    this.updatedAt,
  });

  factory SupabaseUserModel.fromJson(Map<String, dynamic> json) {
    return SupabaseUserModel(
      id: json['id'] as String,
      aud: json['aud'] as String?,
      role: json['role'] as String?,
      email: json['email'] as String?,
      emailConfirmedAt: json['email_confirmed_at'] as String?,
      phone: json['phone'] as String?,
      confirmationSentAt: json['confirmation_sent_at'] as String?,
      confirmedAt: json['confirmed_at'] as String?,
      lastSignInAt: json['last_sign_in_at'] as String?,
      appMetadata: json['app_metadata'] as Map<String, dynamic>?,
      userMetadata: json['user_metadata'] as Map<String, dynamic>?,
      identities: (json['identities'] as List<dynamic>?)
          ?.map((e) => SupabaseIdentityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aud': aud,
      'role': role,
      'email': email,
      'email_confirmed_at': emailConfirmedAt,
      'phone': phone,
      'confirmation_sent_at': confirmationSentAt,
      'confirmed_at': confirmedAt,
      'last_sign_in_at': lastSignInAt,
      'app_metadata': appMetadata,
      'user_metadata': userMetadata,
      'identities': identities?.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class SupabaseSessionModel {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final int expiresAt;
  final String refreshToken;
  final SupabaseUserModel user;

  const SupabaseSessionModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    required this.refreshToken,
    required this.user,
  });

  factory SupabaseSessionModel.fromJson(Map<String, dynamic> json) {
    return SupabaseSessionModel(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      expiresIn: json['expires_in'] as int,
      expiresAt: json['expires_at'] as int,
      refreshToken: json['refresh_token'] as String,
      user: SupabaseUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'expires_at': expiresAt,
      'refresh_token': refreshToken,
      'user': user.toJson(),
    };
  }
}

class SupabaseIdentityModel {
  final String id;
  final String userId;
  final Map<String, dynamic>? identityData;
  final String? provider;
  final String? lastSignInAt;
  final String? createdAt;
  final String? updatedAt;

  const SupabaseIdentityModel({
    required this.id,
    required this.userId,
    this.identityData,
    this.provider,
    this.lastSignInAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SupabaseIdentityModel.fromJson(Map<String, dynamic> json) {
    return SupabaseIdentityModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      identityData: json['identity_data'] as Map<String, dynamic>?,
      provider: json['provider'] as String?,
      lastSignInAt: json['last_sign_in_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'identity_data': identityData,
      'provider': provider,
      'last_sign_in_at': lastSignInAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}