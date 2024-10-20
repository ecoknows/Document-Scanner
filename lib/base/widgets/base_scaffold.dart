import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/documents/presentation/blocs/upload_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/screens/images_screen.dart';
import 'package:document_scanner/features/home/presentation/screens/home_screen.dart';
import 'package:document_scanner/features/notifications/presentation/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final FloatingActionButton? floatingActionButton;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  FloatingActionButtonLocation? floatingActionButtonLocation;

  BaseScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.appBar,
    this.floatingActionButtonLocation =
        FloatingActionButtonLocation.centerDocked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: appBar,
      body: body,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BaseScaffoldDocumentScanner extends StatefulWidget {
  final Widget child;

  const BaseScaffoldDocumentScanner({
    super.key,
    required this.child,
  });

  @override
  State<BaseScaffoldDocumentScanner> createState() =>
      _BaseScaffoldDocumentScannerState();
}

class _BaseScaffoldDocumentScannerState
    extends State<BaseScaffoldDocumentScanner> {
  var _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home,
    Icons.notifications,
  ];
  String appBarTitle = HomeScreen.name;

  @override
  void initState() {
    // context.read<AuthBloc>().add(SignOutUserStarted());
    // context.goNamed(SignInScreen.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<String> pictures;
          try {
            pictures = await CunningDocumentScanner.getPictures() ?? [];
            if (!mounted) return;
            if (pictures.isNotEmpty) {
              PdfDocument document = PdfDocument();

              for (String picture in pictures) {
                PdfPage page = document.pages.add();

                final PdfImage image =
                    PdfBitmap(await SaveFile.readImageData(picture));

                page.graphics.drawImage(image,
                    Rect.fromLTWH(0, 0, page.size.width, page.size.height));
              }

              document.dispose();

              context.read<UploadScannedDocumentsBloc>().add(
                    UploadScannedDocumentsStarted(pictures: pictures),
                  );

              context.pushNamed(ImagesScreen.name);
            }
          } catch (exception) {
            // Handle exception here
          }
        },
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.document_scanner_rounded,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          String name = HomeScreen.name;
          switch (index) {
            case 0:
              context.goNamed(HomeScreen.name);
              name = HomeScreen.name;
              break;
            case 1:
              context.goNamed(NotificationScreen.name);
              name = NotificationScreen.name;
              break;
          }
          setState(() {
            _bottomNavIndex = index;
            appBarTitle = name;
          });
        },
        backgroundColor: Colors.black,
        inactiveColor: Colors.white,
        activeColor: Colors.orange,
      ),
      appBar: AuthenticatedAppBar(
        title: appBarTitle,
      ),
      body: widget.child,
    );
  }
}
