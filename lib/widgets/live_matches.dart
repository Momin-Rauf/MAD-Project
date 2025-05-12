import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/fixture.dart';
import '../utils/app_theme.dart';
import '../screen/chat-app.dart';

class LiveMatches extends StatefulWidget {
  const LiveMatches({super.key});

  @override
  State<LiveMatches> createState() => _LiveMatchesState();
}

class _LiveMatchesState extends State<LiveMatches> {
  List<Fixture> _matches = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLiveMatches();
  }

  Future<void> _fetchLiveMatches() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/fixtures?live=all'),
        headers: {
          'X-RapidAPI-Key':
              '0a68faee8fmsh79593c148ff1127p1c33dajsnd08cb3279a24',
          'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> fixtures = data['response'];

        setState(() {
          _matches =
              fixtures.map((fixture) => Fixture.fromJson(fixture)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load matches';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildMatchCard(Fixture match) {
    print(
        'Live fixture: ${match.fixtureId} - ${match.homeTeam} vs ${match.awayTeam}');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              fixtureId: match.fixtureId,
              matchTitle: '${match.homeTeam} vs ${match.awayTeam}',
            ),
          ),
        );
      },
      child: Container(
        width: 340,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // League info row
                Row(
                  children: [
                    if (match.leagueLogo.isNotEmpty)
                      Image.network(
                        match.leagueLogo,
                        width: 22,
                        height: 22,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(width: 22, height: 22),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        match.leagueName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${match.elapsed}'",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Teams, logos, and score in one row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Home team
                    Column(
                      children: [
                        if (match.homeTeamLogo.isNotEmpty)
                          Image.network(
                            match.homeTeamLogo,
                            width: 36,
                            height: 36,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(width: 36, height: 36),
                          ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 80,
                          child: Text(
                            match.homeTeam,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Score
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${match.homeScore} - ${match.awayScore}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Away team
                    Column(
                      children: [
                        if (match.awayTeamLogo.isNotEmpty)
                          Image.network(
                            match.awayTeamLogo,
                            width: 36,
                            height: 36,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(width: 36, height: 36),
                          ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 80,
                          child: Text(
                            match.awayTeam,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Stadium and referee, each on its own line for compactness
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    match.stadium,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ref: ${match.referee}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchLiveMatches,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_matches.isEmpty) {
      return const Center(
        child: Text(
          'No Live Fixtures',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchLiveMatches,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _matches.length,
        itemBuilder: (context, index) => _buildMatchCard(_matches[index]),
      ),
    );
  }
}
