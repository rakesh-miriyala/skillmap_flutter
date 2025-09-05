class Worker {
  final int id;
  final String name;
  final String skill;
  final String village;
  final String phone;
  final String? languages;

  Worker({
    required this.id,
    required this.name,
    required this.skill,
    required this.village,
    required this.phone,
    this.languages,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json["id"],
      name: json["name"],
      skill: json["skill"],
      village: json["village"],
      phone: json["phone"],
      languages: json["languages"],
    );
  }
}
