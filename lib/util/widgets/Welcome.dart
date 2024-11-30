import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';

void showWelcomeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to the Game!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Here\'s what you can do:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint('Offline Mode:',
                  'Tap the Start button to play offline.', context,
                  isBold: true),
              const SizedBox(height: 8),
              _buildBulletPoint('Online Mode:',
                  'Tap Daily Challenges to compete and earn points.', context,
                  isBold: true),
              const SizedBox(height: 8),
              _buildBulletPoint(
                  'Leaderboard:',
                  'Check the Trophy button to view rankings and scores.',
                  context,
                  isBold: true),
              const SizedBox(height: 8),
              _buildBulletPoint(
                  'Profile:',
                  'View your details, score, and rank in your profile.',
                  context,
                  isBold: true),
              const SizedBox(height: 16),
              _buildBulletPoint(
                  'Settings:', 'You can change the app theme here.', context,
                  isBold: true),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Enjoy the game!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                  child: dialogButton(
                      'Got it!', 45, 120, context)), // Custom button
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildBulletPoint(String header, String description, context,
    {bool isBold = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '• ',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: '$header ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
            children: [
              TextSpan(
                text: description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget dialogButton(
    String text, double ht, double width, BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: black,
      minimumSize: Size(width, ht),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
    child: Text(
      text,
      style: TextStyle(fontSize: ht / 2.3, fontWeight: FontWeight.w600),
    ),
  );
}
