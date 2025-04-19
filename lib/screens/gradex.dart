import 'package:flutter/material.dart';
import '../widgets/side_drawer.dart';


class GradexPage extends StatelessWidget {

  const GradexPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(currentRoute: '/gradex'),
        floatingActionButton: Builder(
              builder: (context) => FloatingActionButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  splashColor: Colors.transparent,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  child: SizedBox(
                      height: 25,
                      child: Image.asset(
                        "assets/icons/arrow_icon.png",
                        color: Colors.white,
                      ))),
            ),
        body: SafeArea(
          child: Center(
            child: Text("SGPA Calculator Page", style: TextStyle(color: Colors.white)),
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}