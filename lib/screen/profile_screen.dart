import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/profile_dto.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _buttonController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: Offset(0, 0.5 + index * 0.1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _cardController,
        curve: Interval(0.2 * index, 0.6 + 0.2 * index, curve: Curves.easeOut),
      ));
    });

    _fadeAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _cardController,
        curve: Interval(0.2 * index, 0.6 + 0.2 * index, curve: Curves.easeIn),
      ));
    });

    _cardController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileDTO profileData =
        ModalRoute.of(context)?.settings.arguments as ProfileDTO;

    final Map<String, dynamic> additionalData = {
      'role': 'Software Developer',
      'joinDate': 'March 2024',
      'status': 'Active',
      'totalProjects': '15',
      'lastActive': 'Today',
    };

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'profile_image',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.85),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(profileData.imageName),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profileData.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        additionalData['role'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(3, (index) {
                  final titles = [
                    'Personal Information',
                    'Account Details',
                    'Activity',
                  ];
                  final contents = [
                    [
                      _buildInfoItem(Icons.email, 'Email', profileData.email),
                      _buildInfoItem(Icons.phone, 'Phone', profileData.phone),
                      _buildInfoItem(Icons.location_on, 'Address', profileData.address),
                    ],
                    [
                      _buildInfoItem(Icons.calendar_today, 'Joined', additionalData['joinDate']),
                      _buildInfoItem(Icons.circle, 'Status', additionalData['status'],
                          customIcon: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          )),
                      _buildInfoItem(Icons.fingerprint, 'Biometric Login',
                          profileData.biometric ? 'Enabled' : 'Disabled'),
                    ],
                    [
                      _buildInfoItem(Icons.folder, 'Total Projects', additionalData['totalProjects']),
                      _buildInfoItem(Icons.access_time, 'Last Active', additionalData['lastActive']),
                    ],
                  ];

                  return SlideTransition(
                    position: _slideAnimations[index],
                    child: FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(titles[index]),
                          _buildInfoCard(contents[index]),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  );
                })
                  ..add(ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
                    ),
                    child: _buildActionButtons(),
                  )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, {Widget? customIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: customIcon ?? Icon(icon, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(value.isEmpty ? 'Not provided' : value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => _buttonController.forward(),
          onTapUp: (_) => _buttonController.reverse(),
          onTapCancel: () => _buttonController.reverse(),
          child: ScaleTransition(
            scale: Tween(begin: 1.0, end: 0.95).animate(CurvedAnimation(
              parent: _buttonController,
              curve: Curves.easeOut,
            )),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.security),
            label: const Text('Security Settings'),
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
