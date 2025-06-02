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
    return Drawer(
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [

Container(
              height: 75, // Custom height
              width: double.infinity, // Full width of the screen
              color: Appcolors.primary1, // Background color
              child:  Center(
                  child: Text(
                    'MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                
              ),
            ),
            
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xff89c236)),
              title: Text("Home"),
              selected: true,
            ),
            
            Container(
              height: 0, // Space above the line
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFDDDDDD), // Border color
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
            
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => AttendanceScreen()));
              },
              leading: const Icon(Icons.calendar_month),
              title: Text("Attendance"),
            ),
            Container(
              height: 0, // Space above the line
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFDDDDDD), // Border color
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
            
            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => PacUpdater()));
              },
              leading: const Icon(Icons.circle),
              title: Text("Tasks"),
            ),
            Container(
              height: 0, // Space above the line
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFDDDDDD), // Border color
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
            
            if (networkCaller.isAdminMode)
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => ProductListScreen()));
                },
                leading: const Icon(Icons.production_quantity_limits),
                title: Text("Products"),
              ),
                          Container(
              height: 0, // Space above the line
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFDDDDDD), // Border color
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
            

            // ListTile(
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (c) => ProductListScreen()));
            //   },
            //   leading: const Icon(Icons.ad_units_outlined),
            //   title: Text("Options"),
            // ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => ChangePassWord()));
              },
              leading: const Icon(Icons.settings),
              title: Text("Change Password"),
            ),
                        Container(
              height: 0, // Space above the line
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFDDDDDD), // Border color
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
            

            ListTile(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => WorkReport()));
              },
              leading: const Icon(Icons.chalet_rounded),
              title: Text("Work Report"),
            ),
            if (networkCaller.canSwitchAccount)
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (c) => SimpleDialog(
                            title: Text("Are you sure?"),
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("This will switch accounts.")),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("cancel")),
                                  SizedBox(width: 10),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        networkCaller.isAdminMode =
                                            !networkCaller.isAdminMode;
                                        networkCaller.reset();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) => LoginScreen()),
                                            (c) => false);
                                      },
                                      child: Text("ok")),
                                ],
                              )
                            ],
                          ));
                },
                leading: const Icon(Icons.change_circle_outlined),
                title: Text("Switch Accounts"),
                subtitle: Text(
                    networkCaller.isAdminMode ? "To Employee" : "To admin"),
              )
            else
            Container(
              height: 0, // Space above the line
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFDDDDDD), // Border color
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
            
              ListTile(
                onTap: () {
                  log(networkCaller.box.read("user").toString());
                  log(networkCaller.box.read("adminuser").toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => LoginScreen(changemode: true)));
                },
                leading: const Icon(Icons.switch_access_shortcut),
                title: Text("Change Account"),
              ),
            Spacer(),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (c) => SimpleDialog(
                          title: Text("Are you sure?"),
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text("This will log you out.")),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("cancel")),
                                SizedBox(width: 10),
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await networkCaller.removeUser();

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => LoginScreen()),
                                          (c) => false);
                                    },
                                    child: Text("ok")),
                              ],
                            )
                          ],
                        ));
              },
              leading: const Icon(Icons.logout, color: Color(0xff89c236)),
              title: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
