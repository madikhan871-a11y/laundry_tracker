import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/laundry_item_model.dart';
import '../services/laundry_service.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _nameController = TextEditingController();

  final LaundryService _service = LaundryService();

  String selectedItem = AppConstants.laundryCategories.first;
  int quantity = 1;

  DateTime pickupDate =
  DateTime.now().add(const Duration(days: 1));

  DateTime deliveryDate =
  DateTime.now().add(const Duration(days: 3));

  bool isLoading = false;

  final Map<String, double> prices = {
    'Shirts': 250,
    'Trousers': 350,
    'Dresses': 700,
    'Bedsheets': 600,
    'Towels': 300,
    'Other': 400,
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  double get total => (prices[selectedItem] ?? 400) * quantity;

  Future<void> _selectDate({
    required bool pickup,
  }) async {
    final initial = pickup ? pickupDate : deliveryDate;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 60),
      ),
    );

    if (date == null) {
      return;
    }

    setState(() {
      if (pickup) {
        pickupDate = date;

        if (deliveryDate.isBefore(pickupDate)) {
          deliveryDate = pickupDate.add(
            const Duration(days: 2),
          );
        }
      } else {
        deliveryDate = date;
      }
    });
  }

  Future<void> _createOrder() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter customer name.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final item = LaundryItemModel(
        name: selectedItem,
        quantity: quantity,
        price: prices[selectedItem] ?? 400,
      );

      await _service.createOrder(
        customerName: _nameController.text.trim(),
        pickupDate:
        DateFormat('dd MMM yyyy').format(pickupDate),
        deliveryDate:
        DateFormat('dd MMM yyyy').format(deliveryDate),
        items: [item.toJson()],
        total: total,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Order Created 🎉'),
            content: const Text(
              'Your laundry order was successfully sent '
                  'to the API.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not create order: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Laundry Order',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          20,
          5,
          20,
          30,
        ),
        children: [
          const Text(
            'Customer Name',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter customer name',
              prefixIcon: Icon(
                Icons.person_outline,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Laundry Item',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          DropdownButtonFormField<String>(
            initialValue: selectedItem,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.checkroom_outlined,
              ),
            ),
            items: AppConstants.laundryCategories
                .map(
                  (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                selectedItem = value;
              });
            },
          ),
          const SizedBox(height: 22),
          const Text(
            'Quantity',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Number of items',
                  ),
                ),
                IconButton(
                  onPressed: quantity > 1
                      ? () {
                    setState(() {
                      quantity--;
                    });
                  }
                      : null,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Pickup Date',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          _DateButton(
            date: pickupDate,
            icon: Icons.calendar_today_outlined,
            onTap: () {
              _selectDate(pickup: true);
            },
          ),
          const SizedBox(height: 18),
          const Text(
            'Delivery Date',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          _DateButton(
            date: deliveryDate,
            icon: Icons.event_available_outlined,
            onTap: () {
              _selectDate(pickup: false);
            },
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'Rs. ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: isLoading ? null : _createOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
                  : const Text(
                'Create Order',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final DateTime date;
  final IconData icon;
  final VoidCallback onTap;

  const _DateButton({
    required this.date,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              DateFormat('dd MMM yyyy').format(date),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}