import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DialogCommentSuccess extends StatelessWidget{
  const DialogCommentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/vector/authorisation.svg'),
            const Text('Successfully submitted',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),),
            const SizedBox(height: 10,),
            const Text('Thank you for the valuable feedback.',style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF656A72)
            ),)
          ],
        ),
      ),
    );
  }
}