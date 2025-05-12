class Fixture {
  final int fixtureId;
  final String leagueName;
  final String leagueLogo;
  final String homeTeam;
  final String homeTeamLogo;
  final String awayTeam;
  final String awayTeamLogo;
  final int homeScore;
  final int awayScore;
  final String status;
  final int elapsed;
  final String stadium;
  final String referee;

  Fixture({
    required this.fixtureId,
    required this.leagueName,
    required this.leagueLogo,
    required this.homeTeam,
    required this.homeTeamLogo,
    required this.awayTeam,
    required this.awayTeamLogo,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.elapsed,
    required this.stadium,
    required this.referee,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    final fixture = json['fixture'];
    final league = json['league'];
    final teams = json['teams'];
    final goals = json['goals'];

    return Fixture(
      fixtureId: fixture['id'],
      leagueName: league['name'] ?? 'Unknown League',
      leagueLogo: league['logo'] ?? '',
      homeTeam: teams['home']['name'] ?? 'Unknown Team',
      homeTeamLogo: teams['home']['logo'] ?? '',
      awayTeam: teams['away']['name'] ?? 'Unknown Team',
      awayTeamLogo: teams['away']['logo'] ?? '',
      homeScore: goals['home'] ?? 0,
      awayScore: goals['away'] ?? 0,
      status: fixture['status']['long'] ?? 'Unknown',
      elapsed: fixture['status']['elapsed'] ?? 0,
      stadium: fixture['venue']['name'] ?? 'Unknown Stadium',
      referee: fixture['referee'] ?? 'Unknown Referee',
    );
  }
}
