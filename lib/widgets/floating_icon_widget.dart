import '../pages/user_payment_page.dart';
import 'package:flutter/material.dart';

class FloatingIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(UserPaymentPage.routeName);
      },
      tooltip: 'Increment',
      child: Icon(Icons.account_balance_wallet),
      elevation: 2.0,
    );
  }
}
