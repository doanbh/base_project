import 'package:flutter/material.dart';
import 'package:pd_core/core/base_page.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with BasePageMixin<>{

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
