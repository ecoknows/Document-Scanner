import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

part 'upload_pdf_event.dart';
part 'upload_pdf_state.dart';

class UploadPdfBloc extends Bloc<UploadPdfEvent, UploadPdfState> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  UploadPdfBloc() : super(UploadPdfInitial()) {
    on<UploadPdfStarted>(_uploadPdf);
  }

  Future<void> _uploadPdf(
    UploadPdfStarted event,
    Emitter<UploadPdfState> emit,
  ) async {
    List<String> pictures = event.pictures;
    String documentName = event.documentName;

    User? user = _auth.auth.currentUser;
    final storageRef = FirebaseStorage.instance.ref();

    PdfDocument pdfDocument = PdfDocument();

    emit(UploadPdfInProgress());

    if (user != null) {
      for (String picture in pictures) {
        final File image = File(picture);

        PdfPage page = pdfDocument.pages.add();

        final PdfImage pdfImage = PdfBitmap(image.readAsBytesSync());

        page.graphics.drawImage(
          pdfImage,
          Rect.fromLTWH(
            0,
            0,
            page.size.width,
            page.size.height,
          ),
        );
      }

      UploadTask? uploadPdfImagesTask;
      final String pdfImageUserPath = "pdf/scanned_image/${user.uid}";
      final String pdfImagePath = "$pdfImageUserPath/$documentName.jpg";
      final pdfImageRef = storageRef.child(pdfImagePath);

      String pdfImageFilePath = pictures.first;
      final File pdfImage = File(pdfImageFilePath);
      uploadPdfImagesTask = pdfImageRef.putFile(pdfImage);

      await uploadPdfImagesTask;

      // PDF Process
      final String pdfUserPath = "pdf/scanned_documents/${user.uid}";
      final String pdfPath = "$pdfUserPath/$documentName.pdf";
      final pdfRef = storageRef.child(pdfPath);
      UploadTask? pdfUploadTask;

      List<int> bytes = await pdfDocument.save();

      final File pdfFile =
          await SaveFile.bytesToFile(bytes, "$documentName.pdf");

      pdfUploadTask = pdfRef.putFile(pdfFile);

      await pdfUploadTask;

      pdfDocument.dispose();
    }

    emit(UploadPdfSuccess());
  }
}
