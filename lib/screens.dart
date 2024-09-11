import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

import 'home.dart';

class Screen extends StatefulWidget {
  const Screen({
    super.key,
  });
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  List<Widget> listPages = [const Home(), const Home()];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 2, vsync: this);
    tabController.animation?.addListener(
      () {
        final value = tabController.animation!.value.round();
        if (value != currentPage && mounted) {
          changePage(value);
        }
      },
    );
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color unselectedColor = Colors.grey;
    return SafeArea(
      child: Scaffold(
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.5,
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Preferences',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.blue),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.menu, color: Colors.blue))
                  ],
                ),
              ),
              ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Sign Out'), Icon(Icons.exit_to_app)],
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: BottomBar(
          barDecoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clip: Clip.none,
          fit: StackFit.expand,
          borderRadius: BorderRadius.circular(18),
          curve: Curves.decelerate,
          showIcon: false,
          width: MediaQuery.of(context).size.width - 30,
          barColor: Colors.white,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          body: (context, controller) =>
              TabBarView(controller: tabController, children: listPages),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              TabBar(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicatorPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                controller: tabController,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 4,
                    ),
                    insets: const EdgeInsets.fromLTRB(16, 0, 16, 8)),
                tabs: [
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                        child: Icon(
                      Icons.home,
                      color: currentPage == 0 ? Colors.blue : unselectedColor,
                    )),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.pie_chart,
                        color: currentPage == 1 ? Colors.blue : unselectedColor,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -15,
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.blue,
                  onPressed: () {},
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
