import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project_1st/chatpage/userchatpage.dart';
import 'package:flutter_project_1st/generated/l10n.dart';
import 'package:flutter_project_1st/ipaddress.dart';
import 'package:flutter_project_1st/registerID.dart';
import 'package:flutter_project_1st/settingpage/theme/theme_provider.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BottomNav extends StatefulWidget {
  const BottomNav(
      {super.key,
      required this.itemId,
      required this.isFavorite,
      required this.isReserved});
  final int itemId;
  final bool isFavorite;
  final bool isReserved;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  String errorMessage = '';
  String registerid = '';
  String itemid = '';
  String receiverId = '';
  String receiverFname = '';
  String receiverLname = '';
  bool _isFavorite = false;
  bool _isReserved = false;
  TextEditingController commentController = TextEditingController();

  Future<void> addfavorite({
    required String registerID,
    required String iditem,
    required BuildContext context,
    required String softCopy,
  }) async {
    final ipAddress = await getLocalIPv4Address();
    final url = Uri.parse('http://$ipAddress:3000/addfavorite');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'registerID': registerID,
          'iditem': iditem,
          'softCopy': softCopy,
        },
      );

      if (response.statusCode == 200) {
        // Data sent successfully
        setState(() {
          _isFavorite = true; // Update the local state
        });
        print('added successful');
      } else {
        // Handle errors or server response based on status code
        setState(() {
          errorMessage = 'error';
        });
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  Future<void> deletefavorite({
    required String iditem,
    required BuildContext context,
    required String registerid,
  }) async {
    final ipAddress = await getLocalIPv4Address();
    final url = Uri.parse('http://$ipAddress:3000/deletefavorite');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'iditem': iditem, 'registerID': registerid},
      );

      if (response.statusCode == 200) {
        // Data sent successfully
        setState(() {
          _isFavorite = false; // Update the local state
        });
        print('Deleted successful');
      } else {
        // Handle errors or server response based on status code
        setState(() {
          errorMessage = 'error';
        });
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  //**************Reserved***************//

  Future<void> addReserved({
    required String itemRequester,
    required String itemOwner,
    required String iditem,
  }) async {
    final ipAddress = await getLocalIPv4Address();
    final url = Uri.parse('http://$ipAddress:3000/addReserved');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'itemRequester': itemRequester,
          'itemOwner': itemOwner,
          'iditem': iditem,
        },
      );

      if (response.statusCode == 200) {
        // Data sent successfully

        setState(() {
          _isReserved = true; // Update the local state
        });
        print('added successful');
      } else {
        // Handle errors or server response based on status code
        setState(() {
          errorMessage = 'error';
        });
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  Future<void> deleteReserved({
    required String iditem,
    required String itemRequester,
  }) async {
    final ipAddress = await getLocalIPv4Address();
    final url = Uri.parse('http://$ipAddress:3000/deleteReserved');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'iditem': iditem, 'itemRequester': itemRequester},
      );

      if (response.statusCode == 200) {
        // Data sent successfully
        setState(() {
          _isReserved = false; // Update the local state
        });
        print('Deleted successful');
      } else {
        // Handle errors or server response based on status code
        setState(() {
          errorMessage = 'error';
        });
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  Future<void> recevierID({
    required String iditem,
  }) async {
    final ipAddress = await getLocalIPv4Address();
    final url = Uri.parse('http://$ipAddress:3000/recevierinfo/$iditem');
    print("**********inside recevierID********");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);

        // Check if the response has the 'registerID' field
        if (jsonResponse.containsKey('registerID') &&
            jsonResponse.containsKey('Fname') &&
            jsonResponse.containsKey('Lname')) {
          final registerId = jsonResponse['registerID'];
          final fname = jsonResponse['Fname'];
          final lname = jsonResponse['Lname'];

          setState(() {
            receiverId = registerId;
            receiverFname = fname;
            receiverLname = lname;
          });

          print('Receiver ID: $receiverId');
        } else {
          // Handle unexpected response format
          setState(() {
            errorMessage = 'Invalid response format';
          });
          print('Invalid response format');
        }
      } else {
        // Handle errors or server response based on status code
        setState(() {
          errorMessage = 'Error: ${response.statusCode}';
        });
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _isReserved = widget.isReserved;
  }

  //bool isFavorite = false;
  //bool isResereved = false;

  @override
  Widget build(BuildContext context) {
    print("///////////*****************item:************************");
    print(widget.itemId);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final userData = Provider.of<UserData>(context);
    final registerID = userData.registerID;
    registerid = registerID;
    itemid = widget.itemId.toString();
    List<Map> bottomNavs = [
      {
        "icon": Icons.check_circle_outline,
        "label": Intl.getCurrentLocale() == 'ar' ? "حجز" : "Reserve",
        "alter": Icons.check_circle
      },
      {
        "icon": Icons.favorite_border,
        "label": Intl.getCurrentLocale() == 'ar' ? "المُفضلة" : "Favorite",
        "alter": Icons.favorite
      },
      {
        "icon": Icons.comment_outlined,
        "label": Intl.getCurrentLocale() == 'ar' ? "تعليق" : "Comment",
        "alter": Icons.comment_outlined
      },
      {
        "icon": Icons.report_outlined,
        "label": Intl.getCurrentLocale() == 'ar' ? "إبلاغ" : "Report",
        "alter": Icons.report_outlined
      },
      {
        "icon": Icons.send_rounded,
        "label": Intl.getCurrentLocale() == 'ar' ? "إرسال" : "Send",
        "alter": Icons.send_rounded
      },
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Color(0xFF117a5d).withOpacity(0.7),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  await recevierID(iditem: widget.itemId.toString());
                  setState(() {
                    _isReserved = !_isReserved;
                    print(_isReserved);
                  });
                  if (_isReserved) {
                    await addReserved(
                      itemRequester: registerid,
                      itemOwner: receiverId,
                      iditem: itemid,
                    );
                  } else {
                    await deleteReserved(
                        iditem: itemid, itemRequester: registerid);
                  }
                  print("information: ");
                  print(registerid);
                  print(receiverId);
                  print(itemid);
                },
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: Opacity(
                    opacity: 1,
                    child: Icon(
                      _isReserved
                          ? bottomNavs[0]["alter"]
                          : bottomNavs[0]["icon"],
                      color: themeProvider.isDarkMode
                          ? Color(0xFF000000)
                          : Color(0xFFffffff),
                      size: 25,
                    ),
                  ),
                ),
              ),
              Text(
                bottomNavs[0]["label"],
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Color(0xFF000000)
                      : Color(0xFFffffff),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _isFavorite = !_isFavorite;
                    print(_isFavorite);
                  });
                  if (_isFavorite) {
                    await addfavorite(
                        registerID: registerid,
                        context: context,
                        iditem: itemid,
                        softCopy: '0');
                  } else {
                    await deletefavorite(
                        context: context,
                        iditem: itemid,
                        registerid: registerid);
                  }
                  print(registerid);
                  print(itemid);
                },
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: Opacity(
                    opacity: 1,
                    child: Icon(
                      _isFavorite
                          ? bottomNavs[1]["alter"]
                          : bottomNavs[1]["icon"],
                      color: themeProvider.isDarkMode
                          ? Color(0xFF000000)
                          : Color(0xFFffffff),
                      size: 25,
                    ),
                  ),
                ),
              ),
              Text(
                bottomNavs[1]["label"],
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Color(0xFF000000)
                      : Color(0xFFffffff),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: themeProvider.isDarkMode
                            ? Colors.black87
                            : Colors.white,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Text(
                                S.of(context).comment,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 25,
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: Opacity(
                    opacity: 1,
                    child: Icon(
                      bottomNavs[2]["icon"],
                      color: themeProvider.isDarkMode
                          ? Color(0xFF000000)
                          : Color(0xFFffffff),
                      size: 25,
                    ),
                  ),
                ),
              ),
              Text(
                bottomNavs[2]["label"],
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Color(0xFF000000)
                      : Color(0xFFffffff),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: themeProvider.isDarkMode
                            ? Colors.black87
                            : Colors.white,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Text(
                                S.of(context).Report,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 25,
                                ),
                              ),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                S.of(context).reportDialogTitle,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                S.of(context).reportAnonymousText,
                                style: TextStyle(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: 380,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors
                                        .black), // Set border color to green
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: commentController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  hintText: S.of(context).reportPlaceholder,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 45,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFF000000),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  await sendReport(
                                      itemId: itemid,
                                      reportcomment: commentController.text,
                                      themeProvider: themeProvider);
                                },
                                child: Center(
                                  child: Text(
                                    S.of(context).submit,
                                    style: TextStyle(
                                      color: Color(0xFFffffff),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: Opacity(
                    opacity: 1,
                    child: Icon(
                      bottomNavs[3]["icon"],
                      color: themeProvider.isDarkMode
                          ? Color(0xFF000000)
                          : Color(0xFFffffff),
                      size: 25,
                    ),
                  ),
                ),
              ),
              Text(
                bottomNavs[3]["label"],
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Color(0xFF000000)
                      : Color(0xFFffffff),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 36,
                width: 36,
                child: Opacity(
                  opacity: 1,
                  child: GestureDetector(
                    onTap: () async {
                      print(
                          "///////////*****************item2:************************");
                      print(widget.itemId.toString());
                      await recevierID(iditem: widget.itemId.toString());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserChatPage(
                              senderId: registerid,
                              receiverId: receiverId,
                              receiverFname: receiverFname,
                              receiverLname: receiverLname,
                              gotoChat: false),
                        ),
                      );
                    },
                    child: Icon(
                      bottomNavs[4]["icon"],
                      color: themeProvider.isDarkMode
                          ? Color(0xFF000000)
                          : Color(0xFFffffff),
                      size: 25,
                    ),
                  ),
                ),
              ),
              Text(
                bottomNavs[4]["label"],
                style: TextStyle(
                  color: themeProvider.isDarkMode
                      ? Color(0xFF000000)
                      : Color(0xFFffffff),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void showConfirmationBottomSheet(BuildContext context, themeProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          color: themeProvider.isDarkMode ? Colors.black87 : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                S.of(context).Report,
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Divider(),
              Center(
                child: Lottie.asset(
                  'assets/success.json',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(height: 10),
              Text(
                S.of(context).thanksForLettingUsKnow,
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Container(
                height: 45,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF000000),
                ),
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      S.of(context).close,
                      style: TextStyle(
                        color: Color(0xFFffffff),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 530),
            ],
          ),
        );
      },
    );
  }

  Future<void> sendReport({
    required String itemId,
    required String reportcomment,
    required ThemeProvider themeProvider,
  }) async {
    final ipAddress = await getLocalIPv4Address();
    final url = Uri.parse('http://$ipAddress:3000/sendreport');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'itemId': itemId,
          'reportcomment': reportcomment,
        },
      );

      if (response.statusCode == 200) {
        showConfirmationBottomSheet(context, themeProvider);
        print('HTTP error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }
}
