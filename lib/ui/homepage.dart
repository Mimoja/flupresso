import 'package:flupresso/model/services/state/coffee_service.dart';
import 'package:flupresso/model/services/state/profile_service.dart';
import 'package:flupresso/service_locator.dart';
import 'package:flupresso/ui/screens/coffee_screen.dart';
import 'package:flupresso/ui/screens/water_screen.dart';
import 'package:flupresso/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Widget _buildButton(FluTheme theme, child, onpress) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: FlatButton(
          onPressed: onpress,
          color: theme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19.0),
            side: BorderSide(color: theme.backgroundColor),
          ),
          child: Container(
            height: 50,
            padding: EdgeInsets.all(10.0),
            child: child,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<FluTheme>(context);

    Widget coffee;
    var currentCoffee = coffeeSelection.currentCoffee;
    if (currentCoffee != null) {
      coffee = Row(children: [
        Spacer(
          flex: 2,
        ),
        Text(
          currentCoffee.roaster,
          style: theme.tabSecondaryStyle,
        ),
        Spacer(
          flex: 1,
        ),
        Text(
          currentCoffee.name,
          style: theme.tabSecondaryStyle,
        ),
        Spacer(
          flex: 2,
        ),
      ]);
    } else {
      coffee = Text(
        'No Coffee selected',
        style: theme.tabSecondaryStyle,
      );
    }
    Widget profile;
    var currentProfile = profileService.currentProfile;
    if (currentProfile != null) {
      profile = Text(
        currentProfile.name,
        style: theme.tabSecondaryStyle,
      );
    } else {
      profile = Text(
        'No Profile selected',
        style: theme.tabSecondaryStyle,
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: theme.screenBackgroundGradient,
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
              color: theme.primaryColor,
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
              child: Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  _buildButton(
                    theme,
                    Text(
                      'Espresso',
                      style: theme.tabSecondaryStyle,
                    ),
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => CoffeeScreen()),
                        )),
                  ),
                  _buildButton(
                    theme,
                    Text(
                      'Water / Steam / Flush',
                      style: theme.tabSecondaryStyle,
                    ),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => WaterScreen()),
                      ),
                    ),
                  ),
                  _buildButton(
                    theme,
                      Text(
                        'Settings',
                        style: theme.tabSecondaryStyle,
                      ),
                      () => {}),
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
