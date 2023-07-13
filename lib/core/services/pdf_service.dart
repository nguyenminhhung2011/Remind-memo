import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project/core/constant/image_const.dart';
import 'package:project/core/extensions/handle_time.dart';
import 'package:project/core/extensions/int_extension.dart';

import '../../domain/enitites/contact/contact.dart';
import '../../domain/enitites/transaction/transaction.dart';
import '../../generated/l10n.dart';
import 'package:printing/printing.dart';

class PdfService {
  PdfService() {
    initFont();
  }

  Future<void> initFont() async {
    font = await PdfGoogleFonts.nunitoExtraLight();
  }

  List<String> headers = [
    S.current.time,
    S.current.loanAmount,
    S.current.lendAmount,
  ];

  pw.Font font = pw.Font();
  pw.Widget PaddedText(
    final String text,
    final pw.Font fontF, {
    final pw.TextAlign align = pw.TextAlign.left,
    final bool? lend,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(10),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(
            font: fontF,
            color: (lend != null)
                ? lend
                    ? PdfColors.green
                    : PdfColors.red
                : null,
          ),
        ),
      );
  Future<Uint8List> convertPdf(
    List<TransactionEntity> listTransaction,
    Contact contact,
    String userName,
  ) async {
    final ByteData getImage = await rootBundle.load(ImageConst.gif);
    final pdf = pw.Document();
    font = await PdfGoogleFonts.nunitoExtraLight();
    int lendSummary = 0;
    int loanSummary = 0;
    for (var element in listTransaction) {
      if (element.type.isLend) {
        lendSummary += element.price;
      } else {
        loanSummary += element.price;
      }
    }
    int summary = lendSummary - loanSummary;
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '${S.current.name} ${contact.name}',
                          style: pw.TextStyle(font: font),
                        ),
                        pw.Text(
                          '${S.current.phoneNumber} ${contact.phoneNumber}',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(
                    width: 90.0,
                    height: 90.0,
                    child: pw.Image(
                      pw.MemoryImage(getImage.buffer.asUint8List()),
                    ),
                  )
                ],
              ),
              pw.SizedBox(height: 50.0),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      ...[4, 3, 3].mapIndexed(
                        (index, e) => pw.Expanded(
                          flex: e,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(10.0),
                            color: PdfColors.blue100,
                            child: pw.Text(
                              headers[index],
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(font: font),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...listTransaction.map(
                    (e) => pw.TableRow(
                      children: [
                        pw.Expanded(
                          flex: 4,
                          child: PaddedText(getYmdHmFormat(e.createTime), font),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: PaddedText(
                            !e.type.isLend ? e.price.price : '',
                            font,
                            lend: false,
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: PaddedText(
                            e.type.isLend ? e.price.price : '',
                            font,
                            lend: true,
                          ),
                        )
                      ],
                    ),
                  ),
                  pw.TableRow(
                    children: [
                      pw.Expanded(flex: 4, child: pw.SizedBox()),
                      pw.Expanded(
                        flex: 3,
                        child: PaddedText(
                          loanSummary.price,
                          font,
                          lend: false,
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: PaddedText(
                          lendSummary.price,
                          font,
                          lend: true,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.RichText(
                text: pw.TextSpan(
                  style: pw.TextStyle(font: font),
                  children: [
                    pw.TextSpan(
                      text: summary < 0
                          ? S.current.loanTotal
                          : S.current.lendTotal,
                    ),
                    pw.TextSpan(
                      text: ' ${summary.abs().price}',
                      style: pw.TextStyle(
                        color: summary < 0 ? PdfColors.red : PdfColors.green,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 15.0),
              pw.Divider(),
              pw.SizedBox(height: 15.0),
              pw.SizedBox(height: 20.0),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        getMMMMEEEd(DateTime.now()),
                        style: pw.TextStyle(
                          font: font,
                        ),
                      ),
                      pw.Text(
                        userName,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}
