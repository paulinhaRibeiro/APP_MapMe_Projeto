import 'package:flutter/material.dart';
import 'package:mapeme/Screens/Widgets/drawerUser/user_accout_drawer.dart';

import '../../authtentication/edit/edit_account.dart';

class MenuDrawerUser extends StatelessWidget {
  const MenuDrawerUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          
          const DrawerUserAccount(),
          
          _createDrawerItem(
            icon: Icons.home_rounded,
            text: 'Home',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.mode_edit_outline_rounded,
            text: 'Editar Conta',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditAccount()),
              );
            },
          ),
          const Divider(),
          _createDrawerItem(
            icon: Icons.info_rounded,
            text: 'Sobre',
            onTap: () {
              Navigator.pop(context);
            },
          ),
          _createDrawerItem(
            icon: Icons.exit_to_app_rounded,
            text: 'Sair',
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: text != "Sair" ? Colors.grey[800] : const Color(0xFF9F0000),
        ),
      ),
      leading: text != "Sair"
          ? Icon(icon)
          : Icon(
              icon,
              color: const Color(0xFF9F0000),
            ),
      onTap: onTap,
    );
  }
}
