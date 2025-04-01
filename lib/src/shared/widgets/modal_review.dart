import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModalReview extends StatefulWidget {
  const ModalReview({super.key});

  @override
  State<ModalReview> createState() => _ModalReviewState();
}

class _ModalReviewState extends State<ModalReview> {
  final TextEditingController _reviewController = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _reviewController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _hasText = _reviewController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _reviewController.removeListener(_updateButtonState);
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    bool isLandscape = MediaQuery
        .of(context)
        .orientation == Orientation.landscape;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10)
              )
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () { Navigator.pop(context); },
                    icon: const Icon(Icons.close,color: Colors.black,)),
                    const Text('What is your review ?',style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),),
                    Container()
                  ],
                ),
                SizedBox(height: 20,),
                Text('Name course',style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
                SizedBox(height: 10,),
                Text('Name instructor',style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF656A72)
                ),),
                SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  value: 1,
                  minHeight: 1,
                  color: Color(0xFFE9EAEC),
                ),
                SizedBox(height: 20,),
                Text('Do you recommed this course ?',style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){

                    }, style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),

                        ),
                        backgroundColor: const Color(0xFFF3F5F6)
                    ),child: Row(
                      children: [
                        SvgPicture.asset('assets/vector/like.svg',color: const Color(0xFF989DA4)),
                        const SizedBox(width: 8,),
                        const Text('YES',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF656A72)
                        ),)
                      ],
                    )),
                    SizedBox(width: 10,),
                    ElevatedButton(onPressed: (){

                    }, style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),

                        ),
                        backgroundColor: const Color(0xFFF3F5F6)
                    ),child: Row(
                      children: [
                        SvgPicture.asset('assets/vector/dislike.svg',color: const Color(0xFF989DA4)),
                        const SizedBox(width: 8,),
                        const Text('NO',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF656A72)
                        ),)
                      ],
                    )),
                  ],
                ),
                SizedBox(height: 20,),
                // Đảm bảo TextField luôn hiển thị với kích thước tối thiểu, bất kể chế độ ngang hay dọc
                Container(
                  height: isLandscape ? 100 : 150, // Điều chỉnh chiều cao theo định hướng màn hình
                  child: TextField(
                    controller: _reviewController,
                    maxLines: null, // Cho phép số dòng không giới hạn
                    expands: true, // Cho phép mở rộng để lấp đầy container
                    textAlignVertical: TextAlignVertical.top, // Căn chỉnh văn bản phía trên
                    decoration: InputDecoration(
                        hintText: 'Leave your review for this course',
                        hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFFA9ADB2)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xFFDFE0E2),
                                width: 1
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: isLandscape ? 15 : 15 + bottomPadding,
          ),
          child: ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                  backgroundColor: _hasText ? Colors.blue : Colors.grey, // Đổi thành màu xanh khi có văn bản
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  minimumSize: const Size(double.infinity, 50)
              ),
              child: const Text(
                'Submit review',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),
              )
          ),
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}