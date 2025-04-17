import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/src/data/model/cart_item_model.dart';
import 'package:learning_app/src/features/cart/bloc/cart_bloc.dart';
import 'package:learning_app/src/features/cart/widget/cart_course_item.dart';
import 'package:learning_app/src/features/course_detail/page/course_detail.dart';
import 'package:learning_app/src/shared/utils/price_format.dart';
class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});
  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Giỏ hàng của tôi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_sharp),
            onPressed: () async {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

              final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
              final Size buttonSize = button.size;

              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromLTWH(
                  buttonPosition.dx + buttonSize.width, // align right
                  buttonPosition.dy -10,     // show below the icon
                  0,
                  0,
                ),
                Offset.zero & overlay.size,
              );
              final currentContext = context;
              final selected = await showMenu(
                context: currentContext,
                position: position,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 8,
                items: [
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, color: Colors.black87),
                        SizedBox(width: 10),
                        Text('Clear'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Row(
                      children: [
                        Icon(Icons.clear, color: Colors.redAccent),
                        SizedBox(width: 10),
                        Text('Cancel'),
                      ],
                    ),
                  ),
                ],
              );

              if (selected == 'clear') {

                showDialog(
                  context: currentContext,
                  builder: (context) => AlertDialog(
                    title: const Text('Xác nhận'),
                    content: const Text('Bạn có chắc muốn xóa tất cả không?'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Cancel
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                        ),
                        onPressed: () {
                          currentContext.read<CartBloc>().add(ClearCart());
                          Navigator.pop(context); // Close dialog
                        },
                        child: const Text('Xóa hết'),
                      ),
                    ],
                  ),
                );
              }
            },
          )
        ],


      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
              ),
            );
          }

          if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return _buildEmptyCart(context);
            }
            return Column(
              children: [
                // List of cart items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final cart = state.cartItems[index];
                      return CartCourseItem(
                        course: cart.course,
                        onRemove: () {
                          context.read<CartBloc>().add(RemoveFromCart(cart.course.courseId));
                        },
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return CourseDetail(course: cart.course);
                          }));
                        },
                      );
                    },
                  ),
                ),

                // Checkout section
                _buildCheckoutSection(context, state.cartItems),
              ],
            );
          }

          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFEF4444),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi: ${state.message}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(LoadCart());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_cart.png',
            width: 180,
            height: 180,
          ),
          const SizedBox(height: 24),
          const Text(
            'Giỏ hàng của bạn đang trống',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Hãy thêm khóa học bạn yêu thích vào giỏ hàng',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, List<CartItemModel> cartItems) {
    // Tính tổng giá
    final double totalPrice = cartItems.fold(
      0,
          (sum, item) => sum + (item.course.price ?? 0),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tổng tiền
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                totalPrice.toCurrencyVND(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),

          // Nút thanh toán
          ElevatedButton(
            onPressed: () {
              // TODO: Xử lý thanh toán hoặc chuyển sang màn hình checkout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng thanh toán chưa được hỗ trợ'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Thanh toán',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }



}