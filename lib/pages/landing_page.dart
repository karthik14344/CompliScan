// pages/landing_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.verified_user,
                            color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'CompliScan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),

            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(60),
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    'Automated Legal Metrology\nCompliance Checker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ensure e-commerce product listings comply with Legal Metrology Rules using AI-powered OCR and automated validation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 20),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Launch Dashboard'),
                  ),
                ],
              ),
            ),

            // Features Section
            Container(
              color: const Color(0xFFF8F8F8),
              padding: const EdgeInsets.all(60),
              child: Column(
                children: [
                  const Text(
                    'Key Features',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          'OCR Text Extraction',
                          'Extract text from product images using advanced OCR technology',
                          Icons.text_fields,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildFeatureCard(
                          'Rule Engine',
                          'Validate against Legal Metrology requirements automatically',
                          Icons.rule,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildFeatureCard(
                          'Compliance Dashboard',
                          'Monitor violations and track compliance trends in real-time',
                          Icons.dashboard,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              child: const Center(
                child: Text(
                  '© 2024 CompliScan - Legal Metrology Compliance Solution',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(icon, size: 30, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
