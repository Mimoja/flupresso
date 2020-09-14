import 'dart:developer';

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
  int temperature;
  int duration;
  ProfileTarget target;

  ProfileFrame(this.name, this.frameNumber, this.temperature, this.duration,
      this.target);

  factory ProfileFrame.fromJson(dynamic json) {
    return ProfileFrame(
      json['name'] as String,
      json['index'] as int,
      json['temp'] as int,
      json['duration'] as int,
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
  int value;
  ProfileType type;
  bool interpolate;

  ProfileTarget(this.value, this.type, this.interpolate);

  factory ProfileTarget.fromJson(dynamic json) {
    return ProfileTarget(
      json['value'] as int,
      _$enumDecode(_$ProfileType, json['type']) as ProfileType,
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
      json['value'] as double,
      json['type'] as ProfileType,
      _$enumDecode(_$ProfileTriggerType, json['operator'])
          as ProfileTriggerType,
    );
  }
}
