import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/src/features/auth/pages/sign_in_page.dart';
import 'package:learning_app/src/features/auth/pages/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void handleNavigator(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_){
      return const SignUpPage(isLogin: true);
    }));
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    bool isLandscape = MediaQuery
        .of(context)
        .orientation == Orientation.landscape; // che do xoay?
    bool isTablet = screenWidth > 600;
    return SafeArea(
        child: Scaffold(
          body: isLandscape ||
              isTablet // Dùng layout chung cho cả tablet và điện thoại xoay ngang
              ? buildLandscapeOrTabletLayout(context)
              : buildPortraitLayout(context), // Layout cho điện thoại dọc
        )
    );
  }


  TextStyle _textStyle(Color color) {
    return TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color);
  }

  //landscape
  Widget buildLandscapeOrTabletLayout(BuildContext context) {
    return
      Row(
        children: [
          Expanded(child: _widgetSecond()),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _widgetWelcome(context)),
                Expanded(
                    child: _widgetForm(context)
                )
              ],
            ),
          ),
        ],

      );
  }

  //Portrait
  Widget buildPortraitLayout(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          size: Size(MediaQuery
              .of(context)
              .size
              .width, MediaQuery
              .of(context)
              .size
              .height / 3),
          painter: RectangleWithArcPainter(),
        ),
        Column(
          children: [
            Expanded(
                child: _widgetWelcome(context)

            ),
            Expanded(child: _widgetSecond()),
            Expanded(
                child: _widgetForm(context)
            )

          ],
        ),
      ],
    );
  }

  Widget _widgetWelcome(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double imageSize = screenWidth * 0.4;
            return SvgPicture.asset(
              'assets/vector/ellipse.svg',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.fill,
            );
          },
        ),
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Xin chào!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(

              'Chào mừng đến với thế giới của những khóa'
              ' học tuyệt vời từ những giảng viên giỏi nhất.',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _widgetSecond() {
    return Image.asset('assets/images/background_login.png', fit: BoxFit.fill,);
  }

  Widget _widgetForm(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;
        double buttonWidth = screenWidth * 0.8;
        double buttonHeight = screenHeight * 0.2;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Nút "Explore the app"
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blueAccent,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       minimumSize: Size(buttonWidth,
            //           buttonHeight), // Điều chỉnh chiều rộng và chiều cao nút
            //     ),
            //     child: Text('Explore the app', style: _textStyle(Colors.white)),
            //   ),
            // ),
            // Nút "Login"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context, builder: (modalContext) {
                        return _modalBottomSheet(modalContext, context);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(buttonWidth,
                      buttonHeight), // Điều chỉnh chiều rộng và chiều cao nút
                ),
                child: Text('Đăng nhập', style: _textStyle(Colors.black)),
              ),
            ),
            // Text "New here?" và "Create account"
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Bạn không có tài khoản ?', style: _textStyle(Colors.black)),
                TextButton(onPressed: () {
                  handleNavigator(context);

                },
                child: Text('Tạo ngay', style: _textStyle(Colors.blueAccent))),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _modalBottomSheet(BuildContext modalContext, BuildContext context) {
    Widget modalBar(BuildContext context){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Đăng nhập hoặc  đăng ký',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(modalContext);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    width: 1,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  )
              ),
              child: const Text(
                'Đóng',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              )
          )
        ],
      );
    }
    Widget googleButton(BuildContext context){
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.2),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/vector/google.svg'),
            const SizedBox(width: 8),
            const Text(
              'Đăng nhập với Google',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    Widget facebookButton(BuildContext context){
      return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.2),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/vector/facebook.svg'),
            const SizedBox(width: 8),
            const Text(
              'Đăng nhập với facebook', // Fixed text here
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    Widget emailButton(BuildContext context){
      return ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (_){
            return const SignInPage(isSignUp: false);
          }) );

        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.2),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            )
        ),
        child: const Text(
          'Đăng nhập với gmail',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    Widget createAccount(BuildContext context){
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bạn chưa có tài khoản ?'),
            TextButton(
              onPressed: () {
                handleNavigator(context);
              },
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
    Widget widgetInfo(){
      return Center(
        child: Text(
          'khoản hoặc bỏ qua màn hình này, bạn chấp nhận Điều khoản sử dụng của chúng tôi',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * (7 / 10),
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8)
          )
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          modalBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // This is important
                children: [
                  // Header row with title and skip button
                  const SizedBox(height: 12),
                  // Google sign in button
                  googleButton(context),
                  const SizedBox(height: 12),
                  // Facebook sign in button (fixed text)
                  facebookButton(context),
                  const SizedBox(height: 12),
                  // Apple sign in button
                  const Center(child: Text('OR')),
                  const SizedBox(height: 15),
                  // Email login button
                  emailButton(context),

                  const SizedBox(height: 20),

                  // Create account section
                  createAccount(context),

                  const SizedBox(height: 15), // Replace Spacer with SizedBox

                  // Terms of use text
                  widgetInfo()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class RectangleWithArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFAEBF4) // Màu hồng nhạt
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;

    final path = Path();
    path.moveTo(0, 0);

     path.arcTo(
       Rect.fromCenter(
         center: Offset(size.width / 2, 0), // Tâm ở đáy
         width: size.width,
         height: size.height,
       ),
       -3.14, // Góc bắt đầu (180 độ)
       3.14,  // Góc quét (180 độ)
       false,
     );
     path.lineTo(size.width, size.height); // Cạnh phải
     path.lineTo(0, size.height); // Cạnh dưới
     path.close();

    // Vẽ lên canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}