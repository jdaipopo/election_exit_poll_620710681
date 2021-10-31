class candidate{
  final int number;
  final String title;
  final String firstName;
  final String lastName;

  candidate ({
    required this.number,
    required this.title,
    required this.firstName,
    required this.lastName,
  });

  factory candidate.fromJson(Map<String,dynamic>json) {
    return candidate(
        firstName: json["firstName"],
        lastName: json["lastName"],
        number: json["number"],
        title: json["title"],
    );
  }
}