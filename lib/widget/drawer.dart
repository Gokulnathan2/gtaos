import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gtaos/helper/network.dart';
import 'package:gtaos/utils/colors.dart';
import 'package:gtaos/views/attendance.dart';
import 'package:gtaos/views/change_pass.dart';
import 'package:gtaos/views/login.dart';
import 'package:gtaos/views/pac_updater.dart';
import 'package:gtaos/views/products_view.dart';
import 'package:gtaos/views/workreport.dart';

class GTAOSDrawer extends StatelessWidget {
  const GTAOSDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: Column(
        children: [
        //   DrawerHeader(
            
        //     decoration: BoxDecoration(
        //       color: colorScheme.primaryContainer,
        //     ),
        //     child: SafeArea(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //      Image.asset(
        //   'asset/brand_icon.png',
        //   width: 50,
        //   height: 50,
        // ),
        //           // const SizedBox(height: 8),
        //           Text(
        //             networkCaller.isAdminMode ? 'Admin Mode' : 'Employee Mode',
        //             style: theme.textTheme.bodyLarge?.copyWith(
        //               color: colorScheme.onPrimaryContainer.withOpacity(0.8),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
          // ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerSection(
                  context,
                  title: 'Main',
                  items: [
                    NavigationDestination(
                      icon: const Icon(Icons.home_outlined),
                      selectedIcon: const Icon(Icons.home),
                      label: 'Home',
                      onTap: () => Navigator.pop(context),
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.calendar_month_outlined),
                      selectedIcon: const Icon(Icons.calendar_month),
                      label: 'Attendance',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (c) => AttendanceScreen()));
                      },
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.task_outlined),
                      selectedIcon: const Icon(Icons.task),
                      label: 'Tasks',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (c) => PacUpdater()));
                      },
                    ),
                  ],
                ),
                if (networkCaller.isAdminMode)
                  _buildDrawerSection(
                    context,
                    title: 'Admin',
                    items: [
                      NavigationDestination(
                        icon: const Icon(Icons.inventory_2_outlined),
                        selectedIcon: const Icon(Icons.inventory_2),
                        label: 'Products',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (c) => ProductListScreen()));
                        },
                      ),
                    ],
                  ),
                _buildDrawerSection(
                  context,
                  title: 'Account',
                  items: [
                    NavigationDestination(
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings),
                      label: 'Change Password',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (c) => ChangePassWord()));
                      },
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.work_outline),
                      selectedIcon: const Icon(Icons.work),
                      label: 'Work Report',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (c) => WorkReport()));
                      },
                    ),
                    if (networkCaller.canSwitchAccount)
                      NavigationDestination(
                        icon: const Icon(Icons.swap_horiz_outlined),
                        selectedIcon: const Icon(Icons.swap_horiz),
                        label: 'Switch Accounts',
                        subtitle: networkCaller.isAdminMode ? 'To Employee' : 'To Admin',
                        onTap: () => _showSwitchAccountDialog(context),
                      ),
                    NavigationDestination(
                      icon: const Icon(Icons.person_outline),
                      selectedIcon: const Icon(Icons.person),
                      label: 'Change Account',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen(changemode: true)));
                      },
                    ),
                    
                  ],
                ),
                
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.errorContainer,
                foregroundColor: colorScheme.onErrorContainer,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(
    BuildContext context, {
    required String title,
    required List<NavigationDestination> items,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((item) => ListTile(
          leading: item.icon,
          title: Text(item.label),
          subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
          onTap: item.onTap,
          selected: false,
          selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        )),
        const Divider(height: 1),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await networkCaller.removeUser();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (c) => LoginScreen()),
                  (c) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showSwitchAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Account'),
        content: const Text('Are you sure you want to switch accounts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              networkCaller.isAdminMode = !networkCaller.isAdminMode;
              networkCaller.reset();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (c) => LoginScreen()),
                (c) => false,
              );
            },
            child: const Text('Switch'),
          ),
        ],
      ),
    );
  }
}

class NavigationDestination {
  final Widget icon;
  final Widget selectedIcon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const NavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });
}
