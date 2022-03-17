class AscendRefObject {
  AscendRefObject({
    required this.id,
    required this.type,
    required this.url,
  });

  final String id;
  final String type;
  final String url;

  factory AscendRefObject.fromJson(Map<String, dynamic> json) {
    return AscendRefObject(
      id: json['id'],
      type: json['type'],
      url: json['url'],
    );
  }
}