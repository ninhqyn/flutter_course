import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:learning_app/src/shared/models/rating.dart';
import 'package:learning_app/src/shared/utils/date_time_util.dart';

class CardReview extends StatelessWidget{
  const CardReview({super.key, required this.rating});
  final Rating rating;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(0.07)
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(34),
                      child: Image.network(
                         rating.user.photoUrl ?? 'avatar',
                        width: 34,
                        height: 34,
                          fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/images/unknown.png',
                              width: 34,
                              height: 34,
                              fit: BoxFit.fill,
                            );}
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible( 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rating.user.displayName ?? 'Display name',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            DateTimeUtil.formatDateTime(rating.createdAt).toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Color(0xFF737982),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: rating.ratingValue.toDouble(),
                itemBuilder: (context, index) =>
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ],
          ),

          const SizedBox(height: 15,),
          Text(rating.reviewText,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Colors.black
            ),)
        ],
      ),
    );
  }

}