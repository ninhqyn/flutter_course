import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/features/instructor/bloc/instructor_courses_bloc.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:learning_app/src/shared/models/instructor.dart';
import 'package:learning_app/src/shared/utils/price_format.dart';
import 'package:learning_app/src/shared/widgets/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructorPage extends StatefulWidget {
  const InstructorPage({super.key, required this.instructor});
  final Instructor instructor;

  @override
  State<InstructorPage> createState() => _InstructorPageState();
}

class _InstructorPageState extends State<InstructorPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Courses', 'Reviews', 'About'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _launchURL(String? url) async {
    if (url != null && url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch URL')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => InstructorCoursesBloc(context.read<CourseRepository>())..add(FetchInstructorCourses(widget.instructor.instructorId)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with cover image and profile
                _buildHeader(),

                // Profile info section
                _buildProfileInfo(),

                // Tabs section
                _buildTabs(),

                // Courses section
                _buildCoursesList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header with cover image, back button, and profile photo
  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover image
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Image.network(
            widget.instructor.photoUrl ?? "",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/background_login.png',
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),

        // Navigation buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Share button
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/vector/share.svg',
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        // Profile photo
        Positioned(
          bottom: -60,
          left: 24,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Container(
                width: 120,
                height: 120,
                color: Colors.grey[300],
                child: Image.network(
                  widget.instructor.photoUrl ?? "https://res.cloudinary.com/depram2im/image/upload/v1743389798/ai_clsgh6.jpg",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/email_notification.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // Verification badge if instructor is verified
        if (widget.instructor.isVerified)
          Positioned(
            bottom: -25,
            left: 120,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  const Text(
                    'Verified',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Profile information section
  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 70, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and social media
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and specialty section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.instructor.instructorName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.school_outlined, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.instructor.specialization ?? 'Instructor',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'London, UK',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Social media buttons
              Column(
                children: [
                  Row(
                    children: [
                      // Website button
                      if (widget.instructor.websiteUrl != null && widget.instructor.websiteUrl!.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.language, color: Colors.blue),
                          onPressed: () => _launchURL(widget.instructor.websiteUrl),
                        ),

                      // LinkedIn button
                      if (widget.instructor.linkedinUrl != null && widget.instructor.linkedinUrl!.isNotEmpty)
                        IconButton(
                          icon: Image.asset('assets/images/linked.png', width: 24, height: 24),
                          onPressed: () => _launchURL(widget.instructor.linkedinUrl),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Bio/about section
          if (widget.instructor.bio != null && widget.instructor.bio!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              widget.instructor.bio!,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 15,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  // Tabs section
  Widget _buildTabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Courses list section with BLoC implementation
  Widget _buildCoursesList() {
    return BlocBuilder<InstructorCoursesBloc, InstructorCoursesState>(
      builder: (context, state) {
        if (state is InstructorCoursesLoading) {
          return const Center(child: LoadingIndicator());
        } else if (state is InstructorCoursesLoaded) {
          final courses = state.courses;

          if (courses.isEmpty) {
            return _buildEmptyCourses();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${courses.length} ${courses.length == 1 ? 'course' : 'courses'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See all'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courses.length > 3 ? 3 : courses.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildCourseCard(courses[index]),
                    );
                  },
                ),
              ],
            ),
          );
        } else if (state is InstructorCoursesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load courses: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<InstructorCoursesBloc>().add(
                      FetchInstructorCourses(widget.instructor.instructorId),
                    );
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        // Initial state or unknown state
        return const SizedBox.shrink();
      },
    );
  }

  // Course card widget
  Widget _buildCourseCard(Course course) {
    return InkWell(
      onTap: () {
        // Navigate to course details page
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                course.thumbnailUrl ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  );
                },
              ),
            ),

            // Course details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            course.category.categoryName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset('assets/vector/level.svg', height: 14),
                        const SizedBox(width: 4),
                        Text(
                          course.difficultyLevel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          course.price.toCurrencyVND(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/vector/cart.svg',
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Empty courses widget
  Widget _buildEmptyCourses() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(Icons.school_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No courses available yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This instructor hasn\'t published any courses',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}