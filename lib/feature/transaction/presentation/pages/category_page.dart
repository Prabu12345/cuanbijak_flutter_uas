import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/widgets/transaction_button.dart';
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
  String selectedStatus = 'Food';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.gradient2,
      appBar: AppBar(
        title: const Text('Select Category'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, selectedStatus);
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'Food',
              'Salary',
              'Bill',
            ]
                .map(
                  (e) => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TransactionButton(
                              onPressed: () {
                                setState(() {
                                  selectedStatus = e;
                                });
                              },
                              backgroundColor: selectedStatus == e
                                  ? AppPallete.whiteColor
                                  : AppPallete.whiteColor70,
                              foregroundColor: AppPallete.black,
                              textButton: e,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
