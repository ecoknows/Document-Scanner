import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:document_scanner/common/classes/firebase_helpers.dart';
import 'package:document_scanner/common/classes/get_scanned_document.dart';
import 'package:document_scanner/common/classes/get_scanned_document_offline.dart';
import 'package:document_scanner/common/classes/save_image_class.dart';
import 'package:document_scanner/features/auth/core/services/cloud_firestore_services.dart';
import 'package:document_scanner/features/auth/core/services/firebase_auth_services.dart';
import 'package:document_scanner/features/documents/data/entities/document_model.dart';
import 'package:document_scanner/features/documents/core/image_folder.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';

part 'get_scanned_documents_event.dart';
part 'get_scanned_documents_state.dart';

class GetScannedDocumentsBloc
    extends Bloc<GetScannedDocumentsEvent, GetScannedDocumentsState> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final CloudFirestoreService _firestore = CloudFirestoreService();

  GetScannedDocumentsBloc() : super(GetScannedDocumentsInitial()) {
    on<GetScannedDocumentsStarted>(_getScannedDocuments);
    on<GetScannedDocumentsOfflineStarted>(_getScannedDocumentsOffline);
    on<AddScannedDocumentsStarted>(_addScannedDocuments);
    on<RemoveImagesStarted>(_removeImages);
    on<AddScannedDocumentsOfflineStarted>(_addScannedDocumentsOfflineStarted);
  }

  void _getScannedDocumentsOffline(
    GetScannedDocumentsOfflineStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) async {
    if (event.showLoadingIndicator) {
      EasyLoading.show();
    }

    final box = await Hive.openBox<DocumentModel>('documentsBox');

    final documents = box.values.toList();
    List<File> images = [];
    List<String> imagesPath = [];
    List<GetScannedDocumentOffline> documentOffline = [];

    for (var document in documents) {
      File image = await SaveFile.uint8ListToFile(
        document.pdf.imageBytes,
        "${document.name}.jpg",
      );

      File pdf = await SaveFile.uint8ListToFile(
        document.pdf.bytes,
        "${document.name}.pdf",
      );

      documentOffline.add(
        GetScannedDocumentOffline(
          document: document,
          name: document.name,
          image: image,
          pdf: pdf,
        ),
      );

      for (var (index, image) in document.images.indexed) {
        File convertedImage = await SaveFile.uint8ListToFile(
          image.bytes,
          "${document.name}.$index.jpg",
        );

        images.add(convertedImage);
        imagesPath.add(convertedImage.path);
      }
    }

    emit(
      GetScannedDocumentsOfflineSuccess(
        documents: documentOffline,
        images: images,
        imagesPath: imagesPath,
      ),
    );

    if (event.showLoadingIndicator) {
      EasyLoading.dismiss();
    }
  }

  void _getScannedDocuments(
    GetScannedDocumentsStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) async {
    User? user = _auth.auth.currentUser;

    if (event.showLoadingIndicator) {
      EasyLoading.show();
    }

    if (user != null) {
      final List<GetScannedDocument> documents = [];
      final List<String> images = [];
      final List<String> imagesFilename = [];
      final List<String> pdfs = [];

      final String documentsUserPath = "images/scanned_documents/${user.uid}";
      final String pdfsUserPath = "pdf/scanned_documents/${user.uid}";
      final String pdfImagesUserPath = "pdf/scanned_image/${user.uid}";

      final documentStorage = FirebaseStorage.instance.ref(documentsUserPath);

      GetScannedDocumentsInProgress();

      ListResult documentResult = await documentStorage.listAll();

      for (Reference documentRef in documentResult.prefixes) {
        ListResult imageResult = await documentRef.listAll();

        for (Reference imageRef in imageResult.items) {
          final imageUrl = await imageRef.getDownloadURL();
          images.add(imageUrl);
          imagesFilename.add(imageRef.name);
        }
      }

      final pdfStorage = FirebaseStorage.instance.ref().child(pdfsUserPath);
      ListResult pdfResult = await pdfStorage.listAll();

      for (Reference pdfRef in pdfResult.items) {
        final pdfUrl = await pdfRef.getDownloadURL();
        final pdfName = pdfRef.name.split(".").first;

        final imagePath = "$pdfImagesUserPath/$pdfName.jpg";
        final imageDownload =
            await FirebaseHelpers.getDownloadUrlIfExists(imagePath);

        final document = GetScannedDocument(
          name: pdfRef.name.split(".").first,
          image: imageDownload!,
          pdf: pdfUrl,
        );

        pdfs.add(pdfUrl);
        documents.add(document);
      }

      List<ImageFolder> imageFolders = await _firestore.getImageFolder();

      emit(GetScannedDocumentsSuccess(
        imageFolders: imageFolders,
        documents: documents,
        images: images,
        imagesFilename: imagesFilename,
        pdfs: pdfs,
      ));
    } else {
      emit(GetScannedDocumentsFail(message: "User not found."));
    }

    if (event.showLoadingIndicator) {
      EasyLoading.dismiss();
    }
  }

  void _addScannedDocuments(
    AddScannedDocumentsStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) {
    GetScannedDocumentsState currentState = state;

    if (currentState is GetScannedDocumentsSuccess) {
      List<ImageFolder> imageFolders = List.from(currentState.imageFolders);
      List<GetScannedDocument> documents = List.from(currentState.documents);
      List<String> images = List.from(currentState.images);
      List<String> imagesFilename = List.from(currentState.imagesFilename);
      List<String> pdfs = List.from(currentState.pdfs);

      documents.addAll(event.documents);
      images.addAll(event.images);
      imagesFilename.addAll(event.imagesFilename);
      pdfs.addAll(event.pdfs);

      emit(GetScannedDocumentsSuccess(
        imageFolders: imageFolders,
        documents: documents,
        images: images,
        imagesFilename: imagesFilename,
        pdfs: pdfs,
      ));
    }
  }

  void _removeImages(
    RemoveImagesStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) {
    GetScannedDocumentsState currentState = state;

    if (currentState is GetScannedDocumentsSuccess) {
      List<String> images = List.from(currentState.images);
      List<String> imagesFilename = List.from(currentState.imagesFilename);

      images.removeWhere((element) => event.images.contains(element));
      imagesFilename
          .removeWhere((element) => event.imagesFilename.contains(element));

      emit(GetScannedDocumentsSuccess(
        imageFolders: currentState.imageFolders,
        documents: currentState.documents,
        images: images,
        imagesFilename: imagesFilename,
        pdfs: currentState.pdfs,
      ));
    }
  }

  void _addScannedDocumentsOfflineStarted(
    AddScannedDocumentsOfflineStarted event,
    Emitter<GetScannedDocumentsState> emit,
  ) async {
    GetScannedDocumentsState currentState = state;

    if (currentState is GetScannedDocumentsOfflineSuccess) {
      List<GetScannedDocumentOffline> documents =
          List.from(currentState.documents);
      List<File> images = List.from(currentState.images);
      List<String> imagesPath = List.from(currentState.imagesPath);

      for (var (index, image) in event.document.images.indexed) {
        images.add(
          await SaveFile.uint8ListToFile(
            image.bytes,
            "${event.document.name}.$index.jpg",
          ),
        );
      }

      File image = await SaveFile.uint8ListToFile(
        event.document.images.first.bytes,
        "${event.document.name}.0.jpg",
      );

      File pdf = await SaveFile.uint8ListToFile(
        event.document.pdf.bytes,
        "${event.document.name}.pdf",
      );

      imagesPath.add(image.path);

      documents.add(
        GetScannedDocumentOffline(
          document: event.document,
          name: event.document.name,
          image: image,
          pdf: pdf,
        ),
      );

      emit(GetScannedDocumentsOfflineSuccess(
        documents: documents,
        images: images,
        imagesPath: imagesPath,
      ));
    }
  }
}
