import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _onlyWifiEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _sectionTitle('Theme'),
            _membershipTile(),
            const Divider(),
            _sectionTitle('Push Notification'),
            _settingTile(
              title: 'Learning Reminder',
              value: 'On',
              onTap: () {
                // Handle learning reminder
              },
            ),
            const Divider(),
            _sectionTitle('Download'),
            _switchTile(
              title: 'Only via WiFi',
              value: _onlyWifiEnabled,
              onChanged: (value) {
                setState(() {
                  _onlyWifiEnabled = value;
                });
              },
            ),
            const Divider(),
            _sectionTitle('Get in touch'),
            _settingTile(
              title: 'Share feedback',
              onTap: () {
                // Handle share feedback
              },
            ),
            _settingTile(
              title: 'Contact Support',
              onTap: () {
                // Handle contact support
              },
            ),
            const Divider(),
            _sectionTitle('About'),
            _settingTile(
              title: 'About EEE',
              onTap: () {
                // Handle about
              },
            ),
            _settingTile(
              title: 'Privacy policy',
              onTap: () {
                // Handle privacy policy
              },
            ),
            _settingTile(
              title: 'Share app',
              onTap: () {
                // Handle share app
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _membershipTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Dark Theme',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle upgrade
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('ON'),
          ),
        ],
      ),
    );
  }

  Widget _settingTile({
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                if (value != null)
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.pink,
          ),
        ],
      ),
    );
  }



}