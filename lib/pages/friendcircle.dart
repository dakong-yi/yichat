import 'package:flutter/material.dart';

class FriendCirclePage extends StatelessWidget {
  final String friendName;

  const FriendCirclePage(this.friendName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friendName),
      ),
      body: Center(
        child: Text('This is the friend circle page for $friendName'),
      ),
    );
  }
}

class CustomizablePage extends StatelessWidget {
  final String itemName;

  const CustomizablePage(this.itemName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
      ),
      body: Center(
        child: Text('This is the customizable page for $itemName'),
      ),
    );
  }
}
