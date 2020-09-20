class Profile {
  final String name;
  final List<ProfileFrame> frames;

  Profile(this.name, this.frames);

  factory Profile.fromJson(dynamic json) {
    return Profile(
      json['name'] as String,
      List.from(json['frames'])
          .map((frame) => ProfileFrame.fromJson(frame))
          .toList(),
    );
  }
}

class ProfileFrame {
  String name;
  int frameNumber;
  double temperature;
  double duration;
  ProfileTarget target;

  ProfileFrame(this.name, this.frameNumber, this.temperature, this.duration,
      this.target);

  factory ProfileFrame.fromJson(dynamic json) {
    return ProfileFrame(
      json['name'] as String,
      json['index'] as int,
      json['temp'].toDouble(),
      json['duration'].toDouble(),
      ProfileTarget.fromJson(json['target']),
    );
  }
}

enum ProfileType {
  FLOW,
  PRESSURE,
}

const _$ProfileType = <ProfileType, dynamic>{
  ProfileType.FLOW: 'flow',
  ProfileType.PRESSURE: 'pressure'
};

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

class ProfileTarget {
  double value;
  ProfileType type;
  bool interpolate;

  ProfileTarget(this.value, this.type, this.interpolate);

  factory ProfileTarget.fromJson(dynamic json) {
    return ProfileTarget(
      double.parse(json['value'].toString()),
      _$enumDecode(_$ProfileType, json['type']),
      json['interpolate'] as bool,
    );
  }
}

enum ProfileTriggerType {
  GREATER_THAN,
  LESSN_THAN,
}

const _$ProfileTriggerType = <ProfileTriggerType, dynamic>{
  ProfileTriggerType.GREATER_THAN: 'greater_than',
  ProfileTriggerType.LESSN_THAN: 'less_than'
};

class ProfileTrigger {
  double value;
  ProfileType type;
  ProfileTriggerType on;

  ProfileTrigger(this.value, this.type, this.on);

  factory ProfileTrigger.fromJson(dynamic json) {
    return ProfileTrigger(
      json['value'].toDouble(),
      json['type'] as ProfileType,
      _$enumDecode(_$ProfileTriggerType, json['operator']),
    );
  }
}
