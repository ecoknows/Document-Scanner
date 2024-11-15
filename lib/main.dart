import 'package:document_scanner/app.dart';
import 'package:document_scanner/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/create_image_folder_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_folder_images_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/image_preview_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/move_image_folder_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/rename_folder_bloc.dart';
import 'package:document_scanner/features/documents/presentation/blocs/upload_scanned_documents_bloc.dart';
import 'package:document_scanner/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => GetScannedDocumentsBloc()),
        BlocProvider(create: (_) => UploadScannedDocumentsBloc()),
        BlocProvider(create: (_) => CreateImageFolderBloc()),
        BlocProvider(create: (_) => MoveImageFolderBloc()),
        BlocProvider(create: (_) => RenameFolderBloc()),
        BlocProvider(create: (_) => GetFolderImagesBloc()),
        BlocProvider(create: (_) => ImagePreviewBloc()),
      ],
      child: const App(),
    );
  }
}
