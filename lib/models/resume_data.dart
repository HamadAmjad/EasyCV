class ResumeData {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String summary;
  final List<String> skills;
  final List<String> experiences;
  final List<String> education;
  final List<String> certifications;
  final List<String> languages;
  final List<String> hobbies;
  final List<String> achievements;
  final List<String> references;

  ResumeData( {
    required this.name,
    required this.email,
    required this.phone,
    required  this.address,
    required this.summary,
    required this.skills,
    required this.experiences,
    required this.education,
    this.certifications = const [],
    this.languages = const [],
    this.hobbies = const [],
    this.achievements = const [],
    this.references = const [],
  });
}
