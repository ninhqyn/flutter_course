import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/core/routes/routes_name.dart';
import 'package:learning_app/src/data/repositories/user_repository.dart';
import 'package:learning_app/src/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:learning_app/src/features/payment_history/payment_history.dart';
import 'package:learning_app/src/features/profile/bloc/profile/profile_bloc.dart';
import 'package:learning_app/src/features/profile/page/edit_profile/page/profile_edit_page.dart';
import 'package:learning_app/src/features/profile/page/my_certificate/page/certificate_page.dart';


class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _profileBloc;
  @override
  void initState() {
    super.initState();
    // Khóa hướng màn hình chỉ cho phép portrait khi vào trang này
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _profileBloc = ProfileBloc(context.read<UserRepository>());
  }
  @override
  void dispose() {
    // Khôi phục lại hướng màn hình mặc định khi thoát trang
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double y = MediaQuery.of(context).size.height/4;
    return BlocProvider.value(
      
  value: _profileBloc,
  child: SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.lightBlue,
                    height: y,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if(state is ProfileLoaded){
                        return  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(state.user.displayName ?? 'user name', style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                          )),
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('NAME USER', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        )),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _itemButton(
                    icon: Icons.edit,
                    title: "Cập nhật thông tin tài khoản",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_){
                        return ProfileEditPage();
                      })
                      );
                    },
                  ),
                  _itemButton(
                    icon: Icons.payment,
                    title: "Lịch sử thanh toán",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>const PaymentHistory()));
                    },
                  ),
                  _itemButton(
                    icon: Icons.bookmark_border,
                    title: "Chứng chỉ của tôi",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>CertificatesPage()));
                    },
                  ),
                  _itemButton(
                    icon: Icons.settings,
                    title: "Cài đặt",
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.settingPage);
                    },
                  ),
                  _itemButton(
                    icon: Icons.login_outlined,
                    title: 'Đăng xuất',
                    onTap: () {
                      // Hiển thị hộp thoại xác nhận
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            title: const Text('Confirm Logout'),
                            content: const Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(const AuthLogOut());
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const Text('Log Out'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                ],
              ),
              Positioned(
                top: y-50,
                left: 30,
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if(state is ProfileLoaded){
                        return Image.network(
                            state.user.photoUrl ?? 'https://res.cloudinary.com/depram2im/image/upload/v1743432104/avatar_default_huhlum.png',
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Image.asset(
                                  'assets/images/user_default.png',
                                  fit: BoxFit.cover
                              );}
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
);
  }

  Widget _itemButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
         decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.pink),
          ],
        ),
      ),
    );
  }
}