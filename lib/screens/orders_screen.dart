import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../routes/app_routes.dart';
import '../services/laundry_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final LaundryService _service = LaundryService();

  String selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laundry Orders',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _service.fetchOrders(),
        builder: (context, snapshot) {
          final orders = snapshot.data ?? [];

          final filtered = selectedStatus == 'All'
              ? orders
              : orders
              .where(
                (order) =>
            order.status == selectedStatus,
          )
              .toList();

          return Column(
            children: [
              SizedBox(
                height: 52,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: [
                    'All',
                    'Pending',
                    'Washing',
                    'Ready',
                    'Delivered',
                  ].map(
                        (status) {
                      final selected =
                          selectedStatus == status;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStatus = status;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: 9,
                          ),
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 17,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius:
                            BorderRadius.circular(24),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            status,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppColors.textDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: snapshot.connectionState ==
                    ConnectionState.waiting
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : snapshot.hasError
                    ? const Center(
                  child: Text(
                    'Unable to load orders.',
                  ),
                )
                    : filtered.isEmpty
                    ? const Center(
                  child: Text(
                    'No orders found.',
                  ),
                )
                    : ListView.builder(
                  padding:
                  const EdgeInsets.fromLTRB(
                    20,
                    5,
                    20,
                    20,
                  ),
                  itemCount: filtered.length,
                  itemBuilder:
                      (context, index) {
                    final order =
                    filtered[index];

                    return OrderCard(
                      order: order,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.orderDetails,
                          arguments: order,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.home,
            );
          } else if (index == 2) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.profile,
            );
          }
        },
      ),
    );
  }
}