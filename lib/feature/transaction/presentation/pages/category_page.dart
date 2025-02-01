import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CategoryPage(),
      );
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String? selectedCategory;
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Food & Drinks',
      'subcategories': ['Groceries', 'Restaurants', 'Snacks', 'Coffee'],
      'icon': Icons.restaurant,
    },
    {
      'name': 'Shopping',
      'subcategories': ['Clothing', 'Electronics', 'Home Goods'],
      'icon': Icons.shopping_bag,
    },
    {
      'name': 'Housing',
      'subcategories': ['Rent', 'Mortgage', 'Utilities', 'Maintenance'],
      'icon': Icons.home,
    },
    {
      'name': 'Transportation',
      'subcategories': ['Public Transport', 'Taxi', 'Fuel', 'Parking'],
      'icon': Icons.directions_car,
    },
    {
      'name': 'Life & Entertainment',
      'subcategories': ['Movies', 'Concerts', 'Hobbies', 'Sports'],
      'icon': Icons.sports_esports,
    },
    {
      'name': 'Financial Expenses',
      'subcategories': ['Insurance', 'Taxes', 'Fees', 'Loans'],
      'icon': Icons.attach_money,
    },
    {
      'name': 'Income',
      'subcategories': ['Salary', 'Bonus', 'Freelance', 'Investments'],
      'icon': Icons.account_balance_wallet,
    },
    {
      'name': 'Others',
      'subcategories': ['Gifts', 'Donations', 'Uncategorized'],
      'icon': Icons.category,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.gradient2,
      appBar: AppBar(
        title: const Text('Select Category'),
        actions: [
          IconButton(
            onPressed: () {
              if (selectedCategory != null) {
                Navigator.pop(context, selectedCategory);
              }
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(category['icon'], color: AppPallete.black),
              title: Text(
                category['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: (category['subcategories'] as List<String>)
                        .map((subcategory) => ListTile(
                              title: Text(subcategory),
                              trailing: Radio<String>(
                                value: subcategory,
                                groupValue: selectedCategory,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  selectedCategory = subcategory;
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
