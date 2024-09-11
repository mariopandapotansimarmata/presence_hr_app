import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:presence_hr_app/list_presence.dart';
import 'package:presence_hr_app/presence.dart';

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
  List<Widget> listPages = [const Home(), const ListPresence()];

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
                indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 4,
                    ),
                    insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const PresencePage();
                      },
                    ));
                  },
                  child: const Icon(
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
