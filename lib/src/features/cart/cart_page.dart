import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool hasItems = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: hasItems ? const CheckoutScreen() : const EmptyCartScreen(),
      bottomNavigationBar: hasItems
          ? null
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              hasItems = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade100,
            foregroundColor: Colors.pink,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Recommended'),
        ),
      ),
    );
  }
}

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/vector/empty_cart.svg',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            'Oops',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have not added any course',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool hasDiscount = false;
  double subtotal = 44.99;
  double discount = 0;
  double total = 44.99;

  final List<Course> designCourses = [
    Course(
      title: 'App Design',
      instructor: 'Jasmine Sophie',
      price: 14.99,
      image: 'assets/images/background_login.png',
    ),
    Course(
      title: 'Wireframe & Prototype',
      instructor: 'Jasmine Sophie',
      price: 14.99,
      image: 'assets/images/background_login.png',
    ),
    Course(
      title: 'UI Design',
      instructor: 'Jasmine Sophie',
      price: 14.99,
      image: 'assets/images/background_login.png',
    ),
  ];

  final List<Course> developmentCourses = [
    Course(
      title: 'Motion Design',
      instructor: 'Jasmine Sophie',
      price: 14.99,
      image: 'assets/motion_design.jpg',
    ),
    Course(
      title: 'E-commerce Design',
      instructor: 'Jasmine Sophie',
      price: 14.99,
      image: 'assets/ecommerce.jpg',
    ),
    Course(
      title: 'Flutter Bootcamp',
      instructor: 'Jasmine Sophie',
      price: 14.99,
      image: 'assets/flutter.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void applyDiscount() {
    setState(() {
      hasDiscount = true;
      discount = 15.00;
      total = subtotal - discount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Design courses tab
                ListView.builder(
                  itemCount: designCourses.length,
                  itemBuilder: (context, index) {
                    return CourseItem(course: designCourses[index]);
                  },
                ),
                // Development courses tab
                ListView.builder(
                  itemCount: developmentCourses.length,
                  itemBuilder: (context, index) {
                    return CourseItem(course: developmentCourses[index]);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (!hasDiscount)
            GestureDetector(
              onTap: () {
                // Show a dialog to enter promo code
                applyDiscount();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Enter your promo code',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          if (hasDiscount)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'DISCOUNT50',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        hasDiscount = false;
                        discount = 0;
                        total = subtotal;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sub Total:'),
              Text('\$${subtotal.toStringAsFixed(2)}'),
            ],
          ),
          if (hasDiscount)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Discount:'),
                  Text('\$${discount.toStringAsFixed(2)}'),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Place order'),
          ),
        ],
      ),
    );
  }
}

class Course {
  final String title;
  final String instructor;
  final double price;
  final String image;

  Course({
    required this.title,
    required this.instructor,
    required this.price,
    required this.image,
  });
}

class CourseItem extends StatelessWidget {
  final Course course;

  const CourseItem({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              course.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  course.instructor,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${course.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}