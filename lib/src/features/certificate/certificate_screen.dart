import 'package:flutter/material.dart';


class CertificateListScreen extends StatelessWidget {
  const CertificateListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Credentials'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            EducationCard(
              logoPath: 'assets/bits_pilani_logo.png',
              instituteName: 'Birla Institute of Technology & Science, Pilani',
              degree: 'Bachelor of Science in Computer Science',
              details: 'Ranked #7 among Technical Universities in India (The Week-Hansa Research Best Universities Survey 2024)',
            ),
            SizedBox(height: 16),
            EducationCard(
              logoPath: 'assets/university_of_london_logo.png',
              instituteName: 'University of London',
              degree: 'Bachelor of Science in Computer Science',
              details: 'Specialise in ML and AI, data science, web and mobile development, physical computing and IoT, game development, VR, or UX',
            ),
            SizedBox(height: 16),
            EducationCard(
              logoPath: 'assets/illinois_tech_logo.png',
              instituteName: 'Illinois Tech',
              degree: 'Bachelor of Information Technology',
              details: 'Ranked #23 for Best Colleges (WSJ/College Pulse, 2023)',
              deadline: 'Hạn nộp hồ sơ 30 tháng 3 năm 2025',
            ),
            SizedBox(height: 16),
            EducationCard(
              logoPath: 'assets/georgetown_university_logo.png',
              instituteName: 'Georgetown University',
              degree: 'Bachelor of Arts in Liberal Studies',
              details: 'Ranked #24 in the National University rankings (US News & World Report, 2025)',
              deadline: 'Hạn nộp hồ sơ 31 tháng 3 năm 2025',
            ),
          ],
        ),
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final String logoPath;
  final String instituteName;
  final String degree;
  final String details;
  final String? deadline;

  const EducationCard({
    Key? key,
    required this.logoPath,
    required this.instituteName,
    required this.degree,
    required this.details,
    this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  logoPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instituteName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    degree,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (deadline != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        deadline!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}