import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project_1st/categorise/RecentlyAddedItems.dart';
import 'package:flutter_project_1st/categorise/appbar_page.dart';
import 'package:flutter_project_1st/ipaddress.dart';
import 'package:flutter_project_1st/settingpage/theme/theme_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Slidespage extends StatefulWidget {
  final int index;
  final int registerid;
  final int faculty;
  final int major;
  const Slidespage(
      {super.key,
      required this.index,
      required this.registerid,
      required this.faculty,
      required this.major});

  @override
  State<Slidespage> createState() => _SlidespageState();
}

class _SlidespageState extends State<Slidespage> {
  List<Map> slides = [];
  late final PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    fetchDataFromAPI(widget.registerid, widget.faculty,
        widget.major); // Call the method to fetch data
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> fetchDataFromAPI(int registerId, int faculty, int major) async {
    final ipAddress = await getLocalIPv4Address();
    final response = await http.get(Uri.parse(
        'http://$ipAddress:3000/slidespage/$registerId/$faculty/$major'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        slides = data.map((item) {
          return {
            "iditem": item["iditem"],
            "image": item["image"],
            "name": item["title"],
            "category": item["CategoryName"],
            "registerID": item["registerID"],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load slides items');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: appBarPage(slidepage: true, index: 1),
      ),
      backgroundColor: themeProvider.isDarkMode
          ? Color.fromARGB(255, 25, 25, 25)
          : Color(0xFFffffff).withOpacity(0.93),
      body: RecentlyaddedItems(array: slides, indexx: widget.index),
    );
  }
}
