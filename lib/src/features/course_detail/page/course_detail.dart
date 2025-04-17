
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/core/constants/text_constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:learning_app/src/features/cart/bloc/cart_bloc.dart';
import 'package:learning_app/src/features/cart/page/cart_page.dart';
import 'package:learning_app/src/features/instructor/page/instructor_page.dart';
import 'package:learning_app/src/features/my_course_detail/page/my_course_detail_page.dart';
import 'package:learning_app/src/features/payment/page/paymet_page.dart';
import 'package:learning_app/src/features/review/page/review_page.dart';
import 'package:learning_app/src/shared/models/course.dart';
import 'package:learning_app/src/shared/models/instructor.dart';
import 'package:learning_app/src/shared/models/skill.dart';
import 'package:learning_app/src/shared/utils/price_format.dart';
import 'package:learning_app/src/shared/widgets/course_item.dart';
import 'package:learning_app/src/shared/widgets/expandable_module.dart';

import '../bloc/course_detail/course_detail_bloc.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({super.key, required this.course});
  final Course course;
  @override
  State<CourseDetail> createState() => _CourseDetailState();
}
class _CourseDetailState extends State<CourseDetail> {
  @override
  void initState() {
    super.initState();
    context.read<CourseDetailBloc>().add(FetchDataCourseDetail(widget.course.courseId,widget.course.category.categoryId));
  }
  void handleNavigatorCourseDetail(Course course){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
      return CourseDetail(course: course);
    })
    );
  }
  void handleNavigatorReviewPage(int courseId) {
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return ReviewPage(courseId: courseId);
    })
    );
  }
  void handleNavigatorMyCourseDetail(int courseId){
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return MyCourseDetailPage(courseId: courseId);
    })
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
              elevation: 6,
            ),
          );
        }

        if (state is CartAddError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.message)),
                ],
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
              elevation: 6,
            ),
          );
        }
      },
  child: SafeArea(
      child:  BlocBuilder<CourseDetailBloc, CourseDetailState>(
        builder: (context, state) {
          if(state is CourseDetailLoading){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ) ;
          }
          return Scaffold(
            appBar: _appBar(context),
            body: buildPortraitLayout(context),
            bottomNavigationBar:  BlocBuilder<CourseDetailBloc, CourseDetailState>(
              builder: (context, state) {
                if(state is CourseDetailLoaded){
                  if(state.isEnrollment){
                    return SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          handleNavigatorMyCourseDetail(state.courseId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text('GO TO COURSE',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),),
                      ),
                    );

                  }
                }
                return _bottomNavigator(context);
              },
            ),
          );
        },
      ),
    ),
);
  }

  Widget _navigator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side - Price information
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: widget.course.discountPercentage > 0
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (widget.course.discountPercentage > 0) ...[
              // Original price with strikethrough
              Text(
                'Giá gốc: ${widget.course.price.toCurrencyVND()}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              // Discounted price and discount badge
              Row(
                children: [
                  Text(
                    'Giá: ${(widget.course.price * (1 - widget.course.discountPercentage / 100)).toCurrencyVND()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${widget.course.discountPercentage}%',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ] else
            // Regular price (non-discounted) - centered vertically
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Giá: ${widget.course.price.toCurrencyVND()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),

        // Right side - Cart and Enroll button
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                print('handle add to cart');
                context.read<CartBloc>().add(AddToCart(widget.course.courseId));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        width: 1,
                        color: Colors.black.withOpacity(0.1)
                    )
                ),
                child: SvgPicture.asset(
                  'assets/vector/cart.svg',
                ),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PaymentPage(courses:[widget.course]))
                  );
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    backgroundColor: Colors.blue
                ),
                child: const Text(
                  'Enroll now',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white
                  ),
                )
            )
          ],
        )
      ],
    );
  }
  
  Widget _bottomNavigator(BuildContext context){

    bool isLandscape = MediaQuery
        .of(context)
        .orientation == Orientation.landscape; // che do xoay?

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: isLandscape
          ? Row(
        children: [
            const Spacer(),
            Expanded(child: _navigator(context))
      ],)
          : _navigator(context),
    );
  }

  Widget _thumbnailCourse(BuildContext context){
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double imageSize = constraints.maxHeight;
        return Image.network(
            widget.course.thumbnailUrl !=null ? widget.course.thumbnailUrl!:
          'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww'
              '.shutterstock.com%2Fim'
              'age-vector%2Ferror-500-page-empty-symbol-crash-1711106146&psig=AOvVaw0wzR1YZIYv'
              'TGIxUM0HcXaN&ust=1742899542189000&source=i'
              'mages&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCPjF4PPE'
              'oowDFQAAAAAdAAAAABAE',
            width:constraints.maxWidth,
            height: imageSize,
            fit: BoxFit.fill,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Image.asset('assets/images/background_login.png',
                  width:constraints.maxWidth,
                  height: imageSize,
                  fit: BoxFit.fill,
                );
        },);
      },
    );
  }

  Widget _courseInfo(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.course.courseName,style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600
        ),),
        const SizedBox(height:  20,),
        BlocBuilder<CourseDetailBloc, CourseDetailState>(
          builder: (context, state) {
            if (state is CourseDetailLoaded) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Số sao với ngôi sao vàng
                      RatingBarIndicator(
                        rating: state.rating.ratingValue.toDouble(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 5),
                  
                      // Số review
                      Text(
                        '(${state.rating.totalRating} review)',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<CourseDetailBloc, CourseDetailState>(
                    builder: (context, state) {
                      if(state is CourseDetailLoaded){
                        return IconButton(onPressed: (){
                          handleNavigatorReviewPage(state.courseId);
                        }, icon: const Icon(Icons.navigate_next_outlined));
                      }
                      return IconButton(onPressed: (){
                      }, icon: const Icon(Icons.navigate_next_outlined));
                    },
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
  Widget _instructorWidget(Instructor instructor){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
                child: Image.asset(
                  "assets/images/background_login.png",
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Image.asset('assets/images/background_login.png',width: 40,height: 40,);
                  },)
            ),
            const SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(instructor.instructorName,style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),),
                Text(instructor.specialization == null ? 'Instructor':
                instructor.specialization!,style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),)
              ],
            ),
          ],
        ),

        const Icon(Icons.navigate_next,color: Colors.black,)
      ],
    );
  }

  Widget buildPortraitLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
              height: MediaQuery.of(context).size.height/4,
              child: _thumbnailCourse(context)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child:_courseInfo(context)),
          _overView(context),



        ]
      ),
    );
  }

  Widget _overView(BuildContext context){

    return  SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),

          //Description
          Text(widget.course.description,
            style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400
          ),
          ),
          const SizedBox(height: 20,),

          //Level info
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F5F6),
              borderRadius: BorderRadius.circular(8)
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/vector/camera.svg'),
                    const SizedBox(width: 5,),
                    Text('Time (${widget.course.durationHours} h)')
                  ],

                ),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    SvgPicture.asset('assets/vector/level.svg'),
                    const SizedBox(width: 5,),
                    Text('Level: ${widget.course.difficultyLevel}')
                  ],)
              ],
            ),
          ),
          const SizedBox(height: 20,),

          //Module info
          const Text('Module' ,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),),
          const SizedBox(height: 10,),
          BlocBuilder<CourseDetailBloc, CourseDetailState>(
            builder: (context, state) {
              if(state is CourseDetailLoaded){
                if(state.modules.isNotEmpty){
                  return ListView.separated(
                      itemCount: state.modules.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        return ExpandableModuleWidget(module: state.modules[index]);
                      }, separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 8);
                  },);
                }
              }
              return const Text('Module empty');
            },
          ),
          const SizedBox(height: 20,),
          //Instructor info
          const Text('Instructor' ,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),),
          const SizedBox(height: 10,),
          BlocBuilder<CourseDetailBloc, CourseDetailState>(
            builder: (context, state) {
              if(state is CourseDetailLoaded){
                if(state.instructors.isNotEmpty){
                  return ListView.separated(
                    itemCount: state.instructors.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return InkWell(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return InstructorPage(instructor: state.instructors[index],);
                        }));
                      },child: _instructorWidget( state.instructors[index]));
                    }, separatorBuilder: (BuildContext context, int index)=> const SizedBox(height: 15,),);
                }
                return const Text('Instructor null');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          const SizedBox(height: 20,),

          //Skill Info
          const Text('Skill' ,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),),
          BlocBuilder<CourseDetailBloc, CourseDetailState>(
            builder: (context, state) {
              if (state is CourseDetailLoaded) {
                if (state.skills.isNotEmpty) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.skills.map((skill) => _skillWidget(skill)).toList(),
                  );
                }
                return const Text('Not found');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          const SizedBox(height: 20,),
          const Text('What you \'ll learn' ,style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17
          ),
          ),
          const SizedBox(height: 20,),
          _interestWidget(TextConstants.interest1),
          _interestWidget(TextConstants.interest2),
          _interestWidget(TextConstants.interest3),
          _interestWidget(TextConstants.interest4),
          _interestWidget(TextConstants.interest5),
          const SizedBox(height: 30,),
          const Text('Certificate',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),),
          const Text('Shareable on App'),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Image.asset(
              'assets/images/course_certificate.png',
              fit: BoxFit.fill,

            ),
          ),
          const SizedBox(height: 30,),

          //Realted course
          const Text('Realted course',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: BlocBuilder<CourseDetailBloc, CourseDetailState>(
              builder: (context, state) {
                if(state is CourseDetailLoaded){
                  final courses = state.courses;
                  if(courses.isNotEmpty){
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: courses.map((course) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: CourseItem(
                              course: course,
                              onTap: (){
                                handleNavigatorCourseDetail(course);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const Text('Không tìm thấy khóa học');
                }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  Widget _skillWidget(Skill skill){
    return Container(decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.black12
    ),child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(skill.skillName),
    ));
  }
  Widget _interestWidget(String text){
    return Row(
      children: [
        const Icon(Icons.check,color: Colors.green,),
        Text(text ,style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15
        ),
        ),
      ],
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(onTap: (){
              Navigator.pop(context);
            },child: SvgPicture.asset('assets/vector/arrow_left.svg')),
            Row(
              children: [
                GestureDetector(onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> const ShoppingCartPage()));
                },child: SvgPicture.asset('assets/vector/cart.svg')),
                const SizedBox(width: 20,),
                SvgPicture.asset('assets/vector/share.svg'),
              ],
            )
          ],
        ),
      ),
    );
  }

  
}