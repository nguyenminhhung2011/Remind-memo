import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/constant/constant.dart';
import 'package:project/core/extensions/context_exntions.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({super.key});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed:()=>  context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Nguyen Minh Hung',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(Constant.kHMarginCard),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: [],
              ),
            )
          ],
        ));
  }
}
