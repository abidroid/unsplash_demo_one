class PhotoUrl {
  final String raw;
  final String full;
  final String regular;
  final String small;
  final String thumb;

  PhotoUrl({
    required this.raw,
    required this.full,
    required this.regular,
    required this.small,
    required this.thumb,
  });

  factory PhotoUrl.fromJson(Map<String, dynamic> map) {
    return PhotoUrl(
      raw: map['raw'],
      full: map['full'],
      regular: map['regular'],
      small: map['small'],
      thumb: map['thumb'],
    );
  }
}
