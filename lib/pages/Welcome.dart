import 'package:flutter/material.dart';
import 'package:ukll/models/user_login.dart';
import 'package:ukll/pages/playlist.dart';
import 'package:ukll/widgets/bottom_nav.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final UserLogin user =
        ModalRoute.of(context)!.settings.arguments as UserLogin;

    final pages = [
      _buildWelcomeContent(user),
      const PlaylistPage(),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Spotify green
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          _selectedIndex == 0 ? 'Welcome' : 'Song Playlist',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildWelcomeContent(UserLogin user) {
    return Center(
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.green,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                '🎵 Welcome to SpotApp',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _infoRow("👤 Name", "${user.firstName} ${user.lastName}"),
            _infoRow("📛 Username", user.username ?? "N/A"),
            _infoRow("📧 Email", user.email ?? "N/A"),
            _infoRow("⚧ Gender", user.gender ?? "N/A"),
            if (user.token != null) ...[
              const SizedBox(height: 16),
              const Text(
                "🔑 Token",
                style: TextStyle(color: Colors.white70),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user.token!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
