import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/shared/models/instructor.dart';


class InstructorPage extends StatelessWidget {
  const InstructorPage({super.key, required this.instructor});
  final Instructor instructor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Close button in top left and Share button in top right
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: Image.network(instructor.photoUrl ?? " ",
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/background_login.png',
                          width: double.infinity,
                          fit: BoxFit.fill,
                        );
                      },),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_outlined),
                            onPressed: () {},
                            iconSize: 20,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: SvgPicture.asset('assets/vector/share.svg'),
                            onPressed: () {},
                            iconSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -120,
                    left: 10,
                    child: Column(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              border: Border.all(
                                  color: Colors.white,
                                  width: 4
                              )
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.network(
                              instructor.photoUrl ?? "https://res.cloudinary.com/depram2im/image/upload/v1743389798/ai_clsgh6.jpg",
                              fit: BoxFit.fill,
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/email_notification.png',
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                );
                              },),
                          ),
                        ),
                        Text(
                          instructor.instructorName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  instructor.specialization?? 'Specialization',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],),
                            const Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  'London, UK',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 70),
              const SizedBox(height: 16),
              // Social media icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.pink),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Image.asset('assets/images/linked.png',width: 24,height: 24,),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Courses count and tabs
              Text(
                '4 courses',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              // Pink underline for selected tab
              Container(
                margin: const EdgeInsets.only(top: 8, right: 16),
                alignment: Alignment.centerRight,
                width: 120,
                height: 2,
                color: Colors.pink,
              ),

              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}