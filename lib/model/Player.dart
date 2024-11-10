class Player {
  final int rank;
  final String username;
  final int score;

  Player({
    required this.rank,
    required this.username,
    required this.score,
  });
}

class rlUser {
  String name;
  String email;
  String score;
  String pfp;

  rlUser(
      {required this.name,
      required this.email,
      required this.score,
      required this.pfp});

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'score': score, 'pfp': pfp};
  }
}
