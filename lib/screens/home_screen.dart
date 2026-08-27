import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../routes/app_routes.dart';
import '../services/laundry_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/order_card.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final LaundryService _laundryService = LaundryService();

  Future<void> _openOrders() async {
    await Navigator.pushNamed(
      context,
      AppRoutes.orders,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _laundryService.fetchOrders(),
          builder: (context, snapshot) {
            final orders = snapshot.data ?? [];

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                await Future<void>.delayed(
                  const Duration(milliseconds: 500),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Good morning 👋',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Laundry dashboard',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fresh clothes,\nfresh day.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 9),
                                Text(
                                  'Track your laundry with ease.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: 0.16,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_laundry_service,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        SummaryCard(
                          title: 'Total Orders',
                          value: snapshot.connectionState ==
                              ConnectionState.waiting
                              ? '--'
                              : '${orders.length}',
                          icon: Icons.receipt_long_outlined,
                        ),
                        const SizedBox(width: 12),
                        SummaryCard(
                          title: 'Active',
                          value: snapshot.connectionState ==
                              ConnectionState.waiting
                              ? '--'
                              : '${orders.where((o) => o.status != 'Delivered').length}',
                          icon: Icons.sync_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recent Orders',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _openOrders,
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (snapshot.connectionState ==
                        ConnectionState.waiting)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (snapshot.hasError)
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.cloud_off_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Unable to load orders. '
                                    'Check your internet connection.',
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...orders.take(3).map(
                            (order) => OrderCard(
                          order: order,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.orderDetails,
                              arguments: order,
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addOrder,
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Create New Laundry Order',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (index == 1) {
            Navigator.pushNamed(
              context,
              AppRoutes.orders,
            );
          } else if (index == 2) {
            Navigator.pushNamed(
              context,
              AppRoutes.profile,
            );
          }
        },
      ),
    );
  }
}