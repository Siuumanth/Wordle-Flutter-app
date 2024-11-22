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

/*
class rlUser {
  String name;
  String email;
  int score;
  String pfp;
  String rank;

  rlUser(
      {required this.name,
      required this.email,
      required this.score,
      required this.pfp,
      required this.rank});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'score': score,
      'pfp': pfp,
      'rank': rank
    };
  }
}
*/
class profileUser {
  String username;
  String email;
  int score;
  String pfp;
  String rank;

  profileUser({
    required this.username,
    required this.email,
    required this.score,
    required this.pfp,
    required this.rank,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': username,
      'email': email,
      'score': score,
      'pfp': pfp,
      'rank': rank,
    };
  }
}

//

class leaderBoardDetails {
  final String username;
  final int score;
  final String pfp;

  const leaderBoardDetails({
    required this.pfp,
    required this.username,
    required this.score,
  });
}

class userDailyTracker {
  final String email;
  final int gamesPlayed;
  final String lastDatePlayedTime;

  const userDailyTracker({
    required this.email,
    required this.gamesPlayed,
    required this.lastDatePlayedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'gamesPlayed': gamesPlayed,
      'lastDateTime': lastDatePlayedTime,
    };
  }
}
