import 'package:cuanbijak_flutter_uas/core/theme/app_pallete.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/dashboard_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/history_page.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/pages/profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const TransactionPage(),
      );
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    int pageIndex = 0;

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: pageIndex,
        backgroundColor: AppPallete.backgroundColor,
        color: AppPallete.gradient2,
        items: const [
          Icon(
            Icons.home_outlined,
            size: 30,
            color: AppPallete.whiteColor,
          ),
          Icon(
            Icons.history,
            size: 30,
            color: AppPallete.whiteColor,
          ),
          Icon(
            Icons.account_circle_outlined,
            size: 30,
            color: AppPallete.whiteColor,
          )
        ],
        onTap: (index) {
          setState(() {
            pageIndex = index;
            pageController.jumpToPage(index);
          });
        },
      ),
      body: SizedBox.expand(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: const [DashboardPage(), HistoryPage(), ProfilePage()],
        ),
      ),
    );
  }
}
