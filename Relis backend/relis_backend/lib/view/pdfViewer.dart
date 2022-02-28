import 'dart:async';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:relis/authentication/user.dart';
import 'package:relis/globals.dart';

class PDFViewer extends StatefulWidget {
  String? url;
  String? path;
  String? bookId;

  PDFViewer({
    this.url,
    this.path,
    this.bookId,
  });

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  static int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  int _lastPageRead = _initialPage;
  double viewportFraction = 1;
  PdfController _pdfController = PdfController(
    document: PdfDocument.openAsset('ReLis.gif'),
  );

  @override
  void initState() {
    _initialPage = getInitialPage();
    _actualPageNumber = _initialPage;
    _lastPageRead = _initialPage;
    _pdfController = PdfController(
      document: PdfDocument.openAsset(widget.path!),
      initialPage: _initialPage,
      viewportFraction: viewportFraction,
    );
    super.initState();
  }

  int getInitialPage() {
    if(user!.containsKey("booksRead") && user!["booksRead"].containsKey(widget.bookId)) {
      return user!["booksRead"][widget.bookId]["lastPageRead"];
    }
    return 1;
  }

  @override
  void dispose() {
    _pdfController.dispose();
    Timer(
      Duration.zero,
      changeLastPageRead(widget.bookId!, _lastPageRead)
    );
    super.dispose();
    print("...pdfViewer dispose runned");
  }

  @override
  Widget build(BuildContext context) {
    print("viewportFraction: ${viewportFraction}");
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: () {
              viewportFraction = viewportFraction * 2;
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              _pdfController.previousPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              '$_actualPageNumber/$_allPagesCount',
              style: TextStyle(fontSize: 22),
            ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              _pdfController.nextPage(
                curve: Curves.ease,
                duration: Duration(milliseconds: 100),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (isSampleDoc) {
                _pdfController.loadDocument(
                    PdfDocument.openAsset(widget.path!));
              } else {
                _pdfController.loadDocument(
                    PdfDocument.openAsset(widget.path!));
              }
              isSampleDoc = !isSampleDoc;
            },
          )
        ],
      ),
      body: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          _actualPageNumber = page;
          if(page > _lastPageRead) {
            _lastPageRead = page;
          }
          setState(() {});
        },
        backgroundDecoration: BoxDecoration(
          color: appBarBackgroundColor,
        ),
        errorBuilder: (exception) {
          return Container(
            child: Text(
              "Some Error Occured!! Please Log-in again. If Error continues, write email to us",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              softWrap: true,
              style: TextStyle(color: Color(0xFFFF0000)),
            ),
            color: mainAppAmber,
          );
        },
        renderer: (PdfPage page) => page.render(
          width: page.width * 2,
          height: page.height * 2,
          format: PdfPageFormat.PNG,
          backgroundColor: appBarBackgroundColor.toString(),
        ),
      ),
    );
  }
}