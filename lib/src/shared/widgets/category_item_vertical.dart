
import 'package:flutter/material.dart';

class CategoryItemHorizontal extends StatelessWidget{
  const CategoryItemHorizontal({super.key, required this.isSelected, required this.categoryName});
  final bool isSelected;
  final String categoryName;
  @override
  Widget build(BuildContext context) {
   return Container(
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(6),
       color: isSelected ? Colors.blueAccent : const Color(0xFFECEDEE)
     ),padding: const EdgeInsets.symmetric(horizontal: 10),
     child: Center(
       child: Text(categoryName,style: TextStyle(
         color: isSelected ? Colors.white :const Color(0xFF656A72),
         fontSize:15,
         fontWeight: FontWeight.w400
       ),),
     ),
   );
  }
}