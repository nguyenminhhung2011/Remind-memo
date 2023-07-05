import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/widgets/button_custom.dart';
import 'package:project/core/widgets/chart_view.dart';
import 'package:project/core/widgets/range_date_picker_custom.dart';
import 'package:project/generated/l10n.dart';

import '../../../core/constant/constant.dart';
import '../../../core/widgets/header_text_custom.dart';

class Step {
  Step(this.name, this.id, this.price, this.isPay, this.count,
      [this.isExpanded = false]);
  String name;
  int id;
  double price;
  bool isPay;
  int count;
  bool isExpanded;
}

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final _rangeDateController = RangeDateController();
  List<Step> listStep = [
    Step('Nguyen Minh Hung', 0, 100.0, false, 3),
    Step('Truong Huynh Duc Hoang', 1, 59.1, true, 2),
    Step('Nguyen Thanh Tung', 2, 200.0, false, 4),
    Step('Hahahahaha', 3, 101.0, true, 2),
  ];

  void _onSelectRangeDate() async {
    final show = await context.pickWeekRange(_rangeDateController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 80,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: context.titleLarge.color),
            const SizedBox(width: 10.0),
            Text(
              S.of(context).chartView,
              style: context.titleLarge.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: <Widget>[
          HeaderTextCustom(
            padding: const EdgeInsets.only(left: Constant.kHMarginCard),
            headerText: S.of(context).overview,
            textStyle: context.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
            onPress: _onSelectRangeDate,
            isShowSeeMore: true,
            afterText:
                '${getYmdFormat(_rangeDateController.startDate)} - ${getYmdFormat(_rangeDateController.endDate)}',
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Constant.kHMarginCard),
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: ChartView(
                header: 'View',
                waterConsume: 100,
                columnData: 100,
                barGroups: [
                  makeGroupData(0, (20 / 100) * 19, (80 / 100) * 19),
                  makeGroupData(1, (20 / 100) * 19, (90 / 100) * 19),
                  makeGroupData(2, (50 / 100) * 19, (10 / 100) * 19),
                  makeGroupData(3, (40 / 100) * 19, (30 / 100) * 19),
                  makeGroupData(4, (30 / 100) * 19, (20 / 100) * 19),
                  makeGroupData(5, (10 / 100) * 19, (50 / 100) * 19),
                  makeGroupData(6, (40 / 100) * 19, (10 / 100) * 19),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonCustom(
                onPress: () {},
                enableWidth: false,
                child: Row(
                  children: [
                    const Icon(Icons.share, color: Colors.white),
                    Text(
                      S.of(context).share,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: 10.0),
          ExpansionPanelList(
            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 10.0),
            elevation: 0,
            animationDuration: const Duration(milliseconds: 300),
            expansionCallback: (index, isExpanded) {
              setState(() {
                listStep[index].isExpanded = !isExpanded;
              });
            },
            children: listStep
                .map((e) => ExpansionPanel(
                      headerBuilder: (context, isExpanded) => Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            margin: const EdgeInsets.symmetric(
                              horizontal: Constant.kHMarginCard,
                              vertical: 10.0,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              e.name[0].toUpperCase(),
                              style: context.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.name,
                                  style: context.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${e.count} ${S.of(context).transaction}',
                                  style: context.titleSmall.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).hintColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            e.price.toString(),
                            style: context.titleMedium.copyWith(
                              color: e.isPay ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < e.count; i++)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: Constant.kHMarginCard * 1.5,
                                vertical: Constant.kHMarginCard,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).primaryColor.withOpacity(
                                          i % 2 == 0 ? 0.2 : 0.1,
                                        ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (i + 1).toString(),
                                    style: context.titleMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...getMMMMEEEd(DateTime.now())
                                            .split(',')
                                            .mapIndexed(
                                              (index, e) => Text(
                                                index == 0
                                                    ? e.trim()
                                                    : '${e.trim()} ${DateTime.now().year}',
                                                style:
                                                    context.titleSmall.copyWith(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            )
                                      ],
                                    ),
                                  ),
                                  Text(
                                    123.12.toString(),
                                    style: context.titleSmall.copyWith(
                                      color: i % 2== 0?  Colors.green:Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          const SizedBox(height: 3.0),
                        ],
                      ),
                      isExpanded: e.isExpanded,
                    ))
                .toList(),
          ),
          const SizedBox(height: 40.0),
        ].expand((element) => [element, const SizedBox(height: 5.0)]).toList(),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        color: Theme.of(context).primaryColor,
        width: 7,
      ),
      BarChartRodData(
        toY: y2,
        color: Colors.red,
        width: 7,
      ),
    ]);
  }
}
