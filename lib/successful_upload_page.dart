import 'package:flutter/material.dart';

class SuccessfulUploadPage extends StatelessWidget {
  const SuccessfulUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Green Checkmark Circle
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50), // Green color matching design
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              const SizedBox(height: 40),
              // Success Text
              Text(
                'Your item has been\nuploaded successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).textTheme.headlineMedium?.color,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 100),
              // Go to Profile Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Pop until we return to the first route (which should be the MainNavigation with Profile tab)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Go to Profile',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
