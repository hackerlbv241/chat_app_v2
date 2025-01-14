import 'package:chat_app/auth/auth_service.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    // obtenir l'instance de FirebaseAuth
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),

              //home list tile

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("A C C U E I L"),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // settings list tile

              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("P A R A M E T R E S"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);

                    // naviguer vers la page de paramètres
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ));
                  },
                ),
              ),

              //logout list tile
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: ListTile(
              title: Text("D E C O N N E X I O N"),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          )
        ],
      ),
    );
  }
}
