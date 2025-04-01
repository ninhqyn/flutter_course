import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/data/repositories/course_repository.dart';
import 'package:learning_app/src/data/repositories/rating_repository.dart';
import 'package:learning_app/src/features/review/bloc/review_bloc.dart';
import 'package:learning_app/src/shared/widgets/card_review.dart';
import 'package:learning_app/src/shared/widgets/modal_review.dart';

class _ReviewContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset('assets/vector/arrow_left.svg'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            BlocBuilder<ReviewBloc, ReviewState>(
              builder: (context, state) {
                if(state is ReviewLoaded){
                  return Text(state.course.courseName,style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                  ),);
                }
               return const Text('Name of course');
              },
            ),
            const SizedBox(height: 20,),
            BlocBuilder<ReviewBloc, ReviewState>(
              builder: (context, state) {
                if (state is ReviewLoaded) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Số sao với ngôi sao vàng
                          RatingBarIndicator(
                            rating: state.ratingTotal.ratingValue.toDouble(),
                            itemBuilder: (context, index) =>
                            const Icon(
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
                            '(${state.ratingTotal.totalRating} review)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(height: 20,),
            Expanded(child: BlocBuilder<ReviewBloc, ReviewState>(
              builder: (context, state) {
                if (state is ReviewLoaded) {
                  return ListView.separated(
                    itemCount: state.ratings.length,
                    itemBuilder: (context, index) {
                      return CardReview(rating: state.ratings[index],);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 15,);
                    },);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
            )
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Cho phép kiểm soát kích thước
            builder: (context) {
              bool isLandscape = MediaQuery
                  .of(context)
                  .orientation == Orientation.landscape;
              return FractionallySizedBox(
                heightFactor: isLandscape ? 1 : 0.8,
                widthFactor: 1, // 8/10 chiều cao màn hình
                child: ModalReview(),

              );
            },
          );
          // showDialog(context: context, barrierDismissible: true,builder: (BuildContext context){
          //   return DialogCommentSuccess();
          // });
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent
          ),
          child: Center(child: SvgPicture.asset('assets/vector/note.svg')),
        ),
      ),
    ));
  }

}

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key, required this.courseId});

  final int courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ReviewBloc(context.read<RatingRepository>(),
          context.read<CourseRepository>())
        ..add(ReviewFetchData(courseId)),
      child: _ReviewContentPage(),
    );
  }
}