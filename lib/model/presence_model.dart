class Presence {
  final int presenceId;
  final String userName;
  final DateTime presenceTime;
  final DateTime? goHomeTime;
  final double latitude;
  final double longitude;

  Presence({
    required this.presenceId,
    required this.userName,
    required this.presenceTime,
    this.goHomeTime,
    required this.latitude,
    required this.longitude,
  });

  // Convert the object to JSON
  Map<String, Object?> toJson() => {
        "presence_id": presenceId,
        "user_name": userName,
        "presence_time": presenceTime.toIso8601String(),
        "go_home_time": goHomeTime?.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
      };

  // Create an object from JSON
  factory Presence.fromJson(Map<String, Object?> json) => Presence(
        presenceId: json["presence_id"] != null
            ? (json["presence_id"] as int?) ?? 0
            : 0,
        userName: json["user_name"] as String? ?? '',
        presenceTime: DateTime.parse(json["presence_time"] as String? ??
            DateTime.now().toIso8601String()),
        goHomeTime: json["go_home_time"] != null
            ? DateTime.parse(json["go_home_time"] as String)
            : null,
        latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
        longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
      );
}
