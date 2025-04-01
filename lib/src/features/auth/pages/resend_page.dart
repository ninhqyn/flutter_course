import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResendPage extends StatefulWidget {
  const ResendPage({super.key});

  @override
  State<ResendPage> createState() => _ResendPageState();
}

class _ResendPageState extends State<ResendPage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Listen to app lifecycle and keyboard events
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {}); // Rebuild the UI when keyboard metrics change (e.g., keyboard appears/disappears)
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Ensures the UI resizes when the keyboard appears
        appBar: _appBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            children: [
              const Text(
                'We just sent an email to reset \nyour password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(child: Image.asset('assets/images/email_notification.png',fit: BoxFit.fill,)),
              const SizedBox(height: 16.0), // Add spacing
              const Text(
                'Haven’t received the email?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 15), // Add spacing
              const Text(
                'Check your spam folder to make sure it \ndidn’t end up there, or resend the email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Match the "Log in" button color
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Resend email', // Changed to "Log in" to match the second image
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: Padding(
        padding: const EdgeInsets.only(left: 10,top: 10,bottom: 5,right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back when arrow is tapped
              },
              child: SvgPicture.asset('assets/vector/arrow_left.svg'),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}