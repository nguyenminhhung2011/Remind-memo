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

  pw.Font font = pw.Font();
  pw.Widget PaddedText(
    final String text,
    final pw.Font fontF, {
    final pw.TextAlign align = pw.TextAlign.left,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.all(10),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(font: fontF),
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
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
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
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20.0),
                        child: pw.Text(
                          S.current.lendAmount,
                          style: pw.Theme.of(context).header4.copyWith(
                                font: font,
                                color: PdfColors.green,
                              ),
                          textAlign: pw.TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  ...listTransaction
                      .where((element) => element.type.isLend)
                      .map(
                        (e) => pw.TableRow(
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: PaddedText(
                                  getYmdHmFormat(e.createTime), font),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: PaddedText(e.price.price, font),
                            )
                          ],
                        ),
                      ),
                ],
              ),
              pw.SizedBox(height: 15.0),
              pw.Divider(),
              pw.SizedBox(height: 15.0),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(20.0),
                        child: pw.Text(
                          S.current.loanAmount,
                          style: pw.Theme.of(context).header4.copyWith(
                                font: font,
                                color: PdfColors.red,
                              ),
                          textAlign: pw.TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  ...listTransaction
                      .where((element) => !element.type.isLend)
                      .map(
                        (e) => pw.TableRow(
                          children: [
                            pw.Expanded(
                              flex: 2,
                              child: PaddedText(
                                getYmdHmFormat(e.createTime),
                                font,
                              ),
                            ),
                            pw.Expanded(
                              flex: 1,
                              child: PaddedText(e.price.price, font),
                            )
                          ],
                        ),
                      ),
                ],
              ),
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
