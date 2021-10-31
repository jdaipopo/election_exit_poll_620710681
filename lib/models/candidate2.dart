class candidate2{
  final int number;
  final String title;
  final String firstName;
  final String lastName;

  final int score;

  candidate2 ({
    required this.number,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.score,
  });

  factory candidate2.fromJson(Map<String,dynamic>json) {
    return candidate2(
      firstName: json["firstName"],
      lastName: json["lastName"],
      number: json["number"],
      title: json["title"],
      score: json["score"],
    );
  }


}
