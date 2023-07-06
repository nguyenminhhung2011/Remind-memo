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


class Data {
  final String name;
  final double percents;
  final Color color;
  final String imagePath;
  Data(
      {required this.imagePath,
      required this.name,
      required this.percents,
      required this.color});
}

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final _rangeDateController = RangeDateController();
 
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
          PieChartVIew(
            header: S.of(context).lendAmount,
            isPay: true,
            data: [
              for (int i = 0; i < 6; i++)
                {
                  'data': ((i + 1) * (i % 2 == 0 ? 80 : 100)).toInt(),
                  'icon': i,
                  'title': 'Person $i'
                }
            ],
          ),
          const SizedBox(height: 10.0),
          PieChartVIew(
            header: S.of(context).loanAmount,
            isPay: false,
            data: [
              for (int i = 0; i < 4; i++)
                {
                  'data': ((i + 1) * (i % 2 == 0 ? 80 : 100)).toInt(),
                  'icon': i,
                  'title': 'Person $i'
                }
            ],
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

class PieChartVIew extends StatefulWidget {
  final String header;
  final bool isPay;
  final List<Map<String, dynamic>> data;
  const PieChartVIew({
    super.key,
    required this.header,
    required this.isPay,
    required this.data,
  });

  @override
  State<PieChartVIew> createState() => _PieChartVIewState();
}

class _PieChartVIewState extends State<PieChartVIew> {
  final ValueNotifier<int> _touchIndex = ValueNotifier<int>(-1);
  int sum = 0;
  @override
  void initState() {
    for (var element in widget.data) {
      sum += element['data'] as int;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Constant.kHMarginCard),
      margin: const EdgeInsets.symmetric(horizontal: Constant.kHMarginCard),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardColor,
        // border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.header,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                sum.toString(),
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.isPay ? Colors.green : Colors.red,
                ),
              )
            ],
          ),
          SizedBox(
            height: 250,
            width: double.infinity,
            child: ValueListenableBuilder<int>(
              valueListenable: _touchIndex,
              builder: (context, touchIndex, chi) => PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchIndex.value = -1;
                        return;
                      }
                      _touchIndex.value =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    },
                  ),
                  startDegreeOffset: 180,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 1,
                  centerSpaceRadius: 0,
                  sections: [
                    ...widget.data.map((e) => Data(
                          imagePath:
                              Constant.icons[e['icon']]['icon'].toString(),
                          name: '',
                          percents: ((e['data'] as int) / sum * 100)
                              .round()
                              .toDouble(),
                          color: Constant.icons[e['icon']]['color'],
                        ))
                  ]
                      .asMap()
                      .map<int, PieChartSectionData>((index, data) {
                        final isTouched = index == touchIndex;

                        return MapEntry(
                          index,
                          PieChartSectionData(
                            color: data.color,
                            value: data.percents,
                            radius: isTouched ? 110 : 90,
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            titlePositionPercentageOffset: 0.55,
                            badgeWidget: Badge(
                              data.imagePath,
                              size: isTouched ? 40.0 : 30.0,
                              borderColor: data.color,
                            ),
                            badgePositionPercentageOffset: .98,
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
              ),
            ),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              ...widget.data.map(
                (e) => Text(
                  '${Constant.icons[e['icon']]['icon'].toString()} ${e['title']} - ${e['data'].toString()}  ',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const Badge(
    this.svgAsset, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      // padding: EdgeInsets.all(size * .15),
      child: Center(child: Text(svgAsset, style: context.titleMedium)),
    );
  }
}
