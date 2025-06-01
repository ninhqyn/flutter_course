import 'package:flutter/material.dart';

class CertificatesPage extends StatefulWidget {
  @override
  _CertificatesPageState createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  String selectedFilter = 'Tất cả';

  // Dữ liệu mẫu cho các chứng chỉ
  final List<Certificate> certificates = [
    Certificate(
      title: 'Flutter Development Masterclass',
      organization: 'Udemy',
      completionDate: '15/03/2024',
      duration: '40 giờ',
      category: 'Mobile Development',
      imageUrl: 'assets/certificates/flutter_cert.png',
      isVerified: true,
    ),
    Certificate(
      title: 'Advanced Dart Programming',
      organization: 'Google Developers',
      completionDate: '02/03/2024',
      duration: '25 giờ',
      category: 'Programming',
      imageUrl: 'assets/certificates/dart_cert.png',
      isVerified: true,
    ),
    Certificate(
      title: 'UI/UX Design Fundamentals',
      organization: 'Coursera',
      completionDate: '20/02/2024',
      duration: '30 giờ',
      category: 'Design',
      imageUrl: 'assets/certificates/ux_cert.png',
      isVerified: false,
    ),
    Certificate(
      title: 'Firebase for Mobile Apps',
      organization: 'Firebase Academy',
      completionDate: '10/02/2024',
      duration: '20 giờ',
      category: 'Backend',
      imageUrl: 'assets/certificates/firebase_cert.png',
      isVerified: true,
    ),
    Certificate(
      title: 'Git & GitHub Complete Course',
      organization: 'GitHub Learning Lab',
      completionDate: '25/01/2024',
      duration: '15 giờ',
      category: 'Tools',
      imageUrl: 'assets/certificates/git_cert.png',
      isVerified: true,
    ),
  ];

  List<String> get categories {
    Set<String> cats = certificates.map((cert) => cert.category).toSet();
    return ['Tất cả', ...cats.toList()];
  }

  List<Certificate> get filteredCertificates {
    if (selectedFilter == 'Tất cả') {
      return certificates;
    }
    return certificates.where((cert) => cert.category == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade600,
                  Colors.blue.shade400,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Bar
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'Chứng chỉ của tôi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search, color: Colors.white, size: 28),
                          onPressed: () {
                            // Implement search functionality
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Stats Section
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Tổng số', '${certificates.length}', Icons.school),
                          _buildStatItem('Đã xác thực', '${certificates.where((c) => c.isVerified).length}', Icons.verified),
                          _buildStatItem('Năm nay', '5', Icons.calendar_today),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Filter Section
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedFilter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = category;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade600 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Certificates List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: filteredCertificates.length,
              itemBuilder: (context, index) {
                final certificate = filteredCertificates[index];
                return _buildCertificateCard(certificate);
              },
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateCard(Certificate certificate) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showCertificateDetails(certificate),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Certificate Image/Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Icon(
                    Icons.school,
                    color: Colors.blue.shade600,
                    size: 40,
                  ),
                ),
                SizedBox(width: 16),
                // Certificate Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              certificate.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          if (certificate.isVerified)
                            Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 20,
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        certificate.organization,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                          SizedBox(width: 4),
                          Text(
                            certificate.completionDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                          SizedBox(width: 4),
                          Text(
                            certificate.duration,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          certificate.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCertificateDetails(Certificate certificate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Certificate Image
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade100, width: 2),
                  ),
                  child: Icon(
                    Icons.school,
                    color: Colors.blue.shade600,
                    size: 60,
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Title and Verification
              Row(
                children: [
                  Expanded(
                    child: Text(
                      certificate.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  if (certificate.isVerified)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Đã xác thực',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                certificate.organization,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 24),
              // Details
              _buildDetailRow('Ngày hoàn thành', certificate.completionDate, Icons.calendar_today),
              _buildDetailRow('Thời lượng', certificate.duration, Icons.access_time),
              _buildDetailRow('Danh mục', certificate.category, Icons.category),
              SizedBox(height: 32),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Share certificate
                      },
                      icon: Icon(Icons.share, color: Colors.blue.shade600),
                      label: Text('Chia sẻ'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue.shade600,
                        side: BorderSide(color: Colors.blue.shade600),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // View certificate
                      },
                      icon: Icon(Icons.visibility, color: Colors.white),
                      label: Text('Xem chi tiết'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCertificateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm chứng chỉ mới'),
        content: Text('Tính năng này sẽ được phát triển trong phiên bản tiếp theo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
        ],
      ),
    );
  }
}

class Certificate {
  final String title;
  final String organization;
  final String completionDate;
  final String duration;
  final String category;
  final String imageUrl;
  final bool isVerified;

  Certificate({
    required this.title,
    required this.organization,
    required this.completionDate,
    required this.duration,
    required this.category,
    required this.imageUrl,
    required this.isVerified,
  });
}