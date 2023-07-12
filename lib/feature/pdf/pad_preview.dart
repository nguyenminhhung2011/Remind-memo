// import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project/core/services/pdf_service.dart';
import 'package:project/domain/enitites/contact/contact.dart';
import 'package:project/domain/enitites/transaction/transaction.dart';
import 'package:project/feature/auth/notifier/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfPreviewPage extends StatefulWidget {
  final List<TransactionEntity> listTransaction;
  final Contact contact;
  const PdfPreviewPage(
      {Key? key, required this.listTransaction, required this.contact})
      : super(key: key);

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  final PdfService pdfService = PdfService();
  bool loading = false;
  bool loadingShare = false;
  File? file;
  Uint8List? memory;

  @override
  void initState() {
    super.initState();
    convertToFile();
  }

  Future<void> sharePdf() async {
    if(memory == null){
      return; 
    }
    loading = true;
    setState(() {});
    List<int> bytes = Uint8List.fromList(memory!).toList();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/report.pdf').create();
    file.writeAsBytesSync(bytes);
    Share.shareFiles([file.path], text: 'Share image');
    loading = false;
    setState(() {});
  }

  Future<void> downloadPdf() async {
    if (memory == null) {
      return;
    }
    final status = await Permission.storage.request();
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/example.pdf';

    final file = File(path);
    await file.writeAsBytes(memory!);

    // if (status[Permission.storage]!.isGranted) {
    //   var dir = await getExternalStorageDirectory();
    //   if (dir != null) {
    //     final taskId = await FlutterDownloader.enqueue(
    //       url: instructionUrl,
    //       headers: {}, // optional: header send with url (auth token etc)
    //       savedDir: dir.path,
    //       /*fileName:"uniquename",*/
    //       showNotification:
    //           true, // show download progress in status bar (for Android)
    //       saveInPublicStorage: true,
    //       openFileFromNotification:
    //           true, // click on notification to open downloaded file (for Android)
    //     );
    //   }
    // }
    final taskId = await FlutterDownloader.enqueue(
      url: '',
      savedDir: directory.path,
      fileName: 'example.pdf',
      showNotification: true,
      openFileFromNotification: true,
    );

    // Show a success message or perform any other actions.
    print('Download started with task ID: $taskId');
  }
  // Future<void> downloadPDF(Uint8List pdfData) async {
  //   if(memory == null){
  //     return;
  //   }
  //   final url = 'data:application/pdf;base64,${base64Encode(pdfData)}';

  //   final webView = InAppWebView(
  //     initialUrlRequest: URLRequest(url: Uri.parse(url)),
  //     onDownloadStart: (controller, urlIn) async {
  //       final filename = Uri.parse(url).pathSegments.last;
  //       await controller.stopLoading();
  //       Fluttertoast.showToast(msg: 'Downloading $filename');
  //       await controller.android.(url: urlIn, filename: filename);
  //     },
  //   );

  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Scaffold(
  //         appBar: AppBar(title: const Text('Download PDF')),
  //         body: webView,
  //       );
  //     },
  //   );
  // }

  Future<void> savePdf() async {
    if (memory == null) {
      return;
    }
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      return;
    }
    final path = '${directory.path}/example.pdf';

    final file = File(path);
    await file.writeAsBytes(memory!);
    print('PDF saved $path');
  }

  void convertToFile() async {
    loading = true;
    setState(() {});
    memory = await pdfService.convertPdf(
      widget.listTransaction,
      widget.contact,
      context.read<AuthNotifier>().user.name,
    );
    if (memory != null) {
      file = File.fromRawPath(memory!);
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading || file == null || memory == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      );
    }
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('PDF Preview'),
        actions: [
          IconButton(
            onPressed: sharePdf,
            icon: loadingShare
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
          )
        ],
      ),
      body: SfPdfViewer.memory(memory!),
    );
  }
}
