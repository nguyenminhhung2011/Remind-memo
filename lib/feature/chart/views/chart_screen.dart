import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project/app_coordinator.dart';
import 'package:project/core/extensions/context_exntions.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/extensions/int_extension.dart';
import 'package:project/core/widgets/button_custom.dart';
import 'package:project/core/widgets/chart_view.dart';
import 'package:project/core/widgets/range_date_picker_custom.dart';
import 'package:project/domain/enitites/contact/contact.dart';
import 'package:project/feature/list_contact/notifier/contact_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/constant/constant.dart';
import '../../../core/widgets/header_text_custom.dart';
import '../notifier/chart_notifier.dart';

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
  final ScreenshotController _screenshotController = ScreenshotController();

  ChartNotifier get _chart => context.read<ChartNotifier>();
  PaidNotifier get _paid => context.read<PaidNotifier>();
  // ContactNotifier get _contact => context.read<ContactNotifier>();

  void _onSelectRangeDate() async {
    final show = await context.pickWeekRange(_rangeDateController);
    _chart.getData(show ?? [], _paid.pay?.id ?? '');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chart.getData(_rangeDateController.listDateUI, _paid.pay?.id ?? '');
    });
  }

  @override
  void dispose() {
    _rangeDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChartNotifier, ContactNotifier>(
      builder: (context, chartModal, contactModal, child) {
        if (contactModal.loadingGet1) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
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
                  style:
                      context.titleLarge.copyWith(fontWeight: FontWeight.bold),
                ), 
                const Spacer(),
                ButtonCustom(
                  onPress: () async {
                    _screenshotController.capture().then((res) {
                      if (res != null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Capture(res: res);
                          },
                        );
                      }
                    });
                  },
                  enableWidth: false,
                  child: Row(
                    children: [
                      const Icon(Icons.camera, color: Colors.white),
                      Text(
                        'Screen shot',
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
          ),
          body: Screenshot(
            controller: _screenshotController,
            child: ListView(
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
                      '${getYmdFormat(chartModal.timeStart)} - ${getYmdFormat(chartModal.timeEnd)}',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constant.kHMarginCard),
                  child: SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: ChartView(
                      header: 'View',
                      waterConsume: chartModal.maxColumnData.toDouble(),
                      columnData: chartModal.maxColumnData.toDouble(),
                      barGroups: [
                        ...chartModal.columnData.entries
                            .mapIndexed((index, element) {
                          final maxColumn = chartModal.maxColumnData;
                          return makeGroupData(
                            index,
                            maxColumn == 0
                                ? 0
                                : (element.value.lend / maxColumn) * 19,
                            maxColumn == 0
                                ? 0
                                : (element.value.loan / maxColumn) * 19,
                          );
                        })
                      ],
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10.0),
                PieChartVIew(
                  header: S.of(context).lendAmount,
                  isPay: true,
                  sum: chartModal.lendSummary,
                  data: [
                    ...chartModal.lendCircleData.entries.map((e) {
                      Contact? contact = contactModal.mapContacts[e.key];
                      return {
                        'data': e.value,
                        'icon': contact?.type ?? 0,
                        'title': contact?.name ?? 'Empty',
                      };
                    })
                  ],
                ),
                const SizedBox(height: 10.0),
                PieChartVIew(
                  header: S.of(context).loanAmount,
                  isPay: false,
                  sum: chartModal.loanSummary,
                  data: [
                    ...chartModal.loanCircleData.entries.map((e) {
                      Contact? contact = contactModal.mapContacts[e.key];
                      return {
                        'data': e.value,
                        'icon': contact?.type ?? 0,
                        'title': contact?.name ?? 'Empty',
                      };
                    })
                  ],
                ),
                const SizedBox(height: 40.0),
              ]
                  .expand((element) => [element, const SizedBox(height: 5.0)])
                  .toList(),
            ),
          ),
        );
      },
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

class Capture extends StatefulWidget {
  const Capture({
    super.key,
    required this.res,
  });

  final Uint8List res;

  @override
  State<Capture> createState() => _CaptureState();
}

class _CaptureState extends State<Capture> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.memory(widget.res),
        ButtonCustom(
          radius: 5.0,
          loading: loading,
          height: 45.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
          onPress: () async {
            loading = true;
            setState(() {});
            List<int> bytes = Uint8List.fromList(widget.res).toList();
            final tempDir = await getTemporaryDirectory();
            final file = await File('${tempDir.path}/image.png').create();
            file.writeAsBytesSync(bytes);
            Share.shareFiles([file.path], text: 'Share image');
            loading = false;
            setState(() {});
          },
        ),
      ],
    ));
  }
}

class PieChartVIew extends StatefulWidget {
  final String header;
  final bool isPay;
  final List<Map<String, dynamic>> data;
  final int sum;
  const PieChartVIew({
    super.key,
    required this.header,
    required this.isPay,
    required this.data,
    required this.sum,
  });

  @override
  State<PieChartVIew> createState() => _PieChartVIewState();
}

class _PieChartVIewState extends State<PieChartVIew> {
  final ValueNotifier<int> _touchIndex = ValueNotifier<int>(-1);

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
                widget.sum.toString(),
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.isPay ? Colors.green : Colors.red,
                ),
              )
            ],
          ),
          if (widget.data.isNotEmpty)
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
                        _touchIndex.value = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
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
                            percents: ((e['data'] as int) / widget.sum * 100)
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
              ...widget.data.map((e) => RichText(
                    text: TextSpan(
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '${Constant.icons[e['icon']]['icon'].toString()} ${e['title']} -',
                        ),
                        TextSpan(
                            text: ' ${(e['data'] as int ).price}  ',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            )),
                      ],
                    ),
                  ))
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
