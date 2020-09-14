import 'package:flupresso/model/Profile.dart';
import 'package:flupresso/model/services/state/CoffeeService.dart';
import 'package:flupresso/model/services/state/ProfileService.dart';
import 'package:flupresso/service_locator.dart';
import 'package:flupresso/ui/screens/CoffeeScreen.dart';
import 'package:flupresso/ui/screens/MiscScreen.dart';
import 'package:flutter/material.dart';
import 'Theme.dart' as Theme;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool available = false;

  CoffeeService coffeeSelection;
  ProfileService profileService;

  @override
  void initState() {
    super.initState();
    coffeeSelection = getIt<CoffeeService>();
    coffeeSelection.addListener(() {
      setState(() {});
    });
    profileService = getIt<ProfileService>();
    profileService.addListener(() {
      setState(() {});
    });
  }

  Widget _buildButton(child, onpress) {
    var color = Theme.Colors.backgroundColor;
    return FlatButton(
      onPressed: onpress,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19.0),
        side: BorderSide(color: color),
      ),
      child: Container(
        height: 50,
        padding: EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget coffee;
    var currentCoffee = coffeeSelection.currentCoffee;
    if (currentCoffee != null) {
      coffee = Row(children: [
        Spacer(
          flex: 2,
        ),
        Text(
          currentCoffee.roaster,
          style: Theme.TextStyles.tabSecondary,
        ),
        Spacer(
          flex: 1,
        ),
        Text(
          currentCoffee.name,
          style: Theme.TextStyles.tabSecondary,
        ),
        Spacer(
          flex: 2,
        ),
      ]);
    } else {
      coffee = Text(
        "No Coffee selected",
        style: Theme.TextStyles.tabSecondary,
      );
    }
    Widget profile;
    Profile currentProfile = profileService.currentProfile;
    if (currentProfile != null) {
      profile = Text(
        currentProfile.name,
        style: Theme.TextStyles.tabSecondary,
      );
    } else {
      profile = Text(
        "No Profile selected",
        style: Theme.TextStyles.tabSecondary,
      );
    }

    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: Theme.Colors.ScreenBackground,
        ),
        child: Column(
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            Center(
                child: Image(
              image: AssetImage('assets/decent.png'),
              height: 120,
              color: Theme.Colors.primaryColor,
            )),
            Spacer(
              flex: 3,
            ),
            Center(child: coffee),
            Center(child: profile),
            Spacer(
              flex: 3,
            ),
            Center(
              child: Row(
                children: [
                  Spacer(),
                  _buildButton(
                    Text(
                      "Espresso",
                      style: Theme.TextStyles.tabSecondary,
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => CoffeeScreen()),
                        )),
                  ),
                  Spacer(),
                  _buildButton(
                    Text(
                      "Water / Steam / Flush",
                      style: Theme.TextStyles.tabSecondary,
                    ),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => WaterScreen()),
                      ),
                    ),
                  ),
                  Spacer(),
                  _buildButton(
                      Text(
                        "Settings",
                        style: Theme.TextStyles.tabSecondary,
                      ),
                      () => {}),
                  Spacer(),
                ],
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}