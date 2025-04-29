import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/profile_dto.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HomeScreen({super.key, required this.userData});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _picController;
  late Animation<double> _picAnimation;

  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textController.forward();

    _picController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _picAnimation =
        CurvedAnimation(parent: _picController, curve: Curves.elasticOut);
    _picController.forward();

    _iconController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _picController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Widget _animatedCard(Widget card, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      // Removed the delay parameter as it is not supported
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: child,
        ),
      ),
      child: card,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            title: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome,',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.userData['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ScaleTransition(
                    scale: _picAnimation,
                    child: Hero(
                      tag: 'profilePic',
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage(widget.userData['imageName']),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Actions',
                      style: AppTheme.headingStyle.copyWith(fontSize: 20)),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _animatedCard(
                          _buildActionCard(
                            'Profile',
                            Icons.person,
                            AppTheme.primaryColor,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/profile',
                              arguments: ProfileDTO(
                                name: widget.userData['name'],
                                imageName: widget.userData['imageName'],
                                phone: widget.userData['phone'] ?? '',
                                email: widget.userData['email'] ?? '',
                                biometric:
                                    widget.userData['biometric'] ?? false,
                                address: widget.userData['address'] ?? '',
                              ),
                            ),
                          ),
                          0),
                      _animatedCard(
                          _buildActionCard(
                            'Messages',
                            Icons.message,
                            AppTheme.secondaryColor,
                            onTap: () => Navigator.pushNamed(context, '/chat'),
                          ),
                          1),
                      _animatedCard(
                          _buildActionCard(
                            'Settings',
                            Icons.settings,
                            Colors.purple,
                            onTap: () =>
                                Navigator.pushNamed(context, '/settings'),
                          ),
                          2),
                      _animatedCard(
                          _buildActionCard(
                            'Help',
                            Icons.help,
                            Colors.teal,
                          ),
                          3),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Updates',
                      style: AppTheme.headingStyle.copyWith(fontSize: 20)),
                  const SizedBox(height: 16),
                  Container(
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      children: [
                        _buildUpdateItem(
                          'Profile Updated',
                          'Your profile information has been updated successfully',
                          Icons.person,
                          AppTheme.primaryColor,
                        ),
                        const Divider(),
                        _buildUpdateItem(
                          'New Message',
                          'You have a new message from the support team',
                          Icons.message,
                          AppTheme.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color,
      {VoidCallback? onTap}) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool _hovering = false;
        late final AnimationController _controller = AnimationController(
          duration: const Duration(milliseconds: 600),
          vsync: this,
        )..repeat(reverse: true);

        final Animation<double> _scaleAnimation = Tween(begin: 1.0, end: 1.15)
            .animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
        final Animation<double> _rotationAnimation =
            Tween(begin: 0.0, end: 0.05).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

        return MouseRegion(
          onEnter: (_) {
            setState(() => _hovering = true);
            _controller.forward();
          },
          onExit: (_) {
            setState(() => _hovering = false);
            _controller.reverse();
          },
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _hovering ? _rotationAnimation.value : 0,
                  child: Transform.scale(
                    scale: _hovering ? _scaleAnimation.value : 1,
                    child: Container(
                      decoration: AppTheme.cardDecoration.copyWith(
                        boxShadow: _hovering
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withOpacity(_hovering ? 0.2 : 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 32, color: color),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpdateItem(
      String title, String subtitle, IconData icon, Color color) {
    return ListTile(
      leading: AnimatedBuilder(
        animation: _iconController,
        builder: (_, child) => Transform.rotate(
          angle: 0.1 * math.sin(_iconController.value * 2 * math.pi),
          child: child,
        ),
        child: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
