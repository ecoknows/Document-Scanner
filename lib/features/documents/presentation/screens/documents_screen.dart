import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:document_scanner/common/widgets/authenticated_appbar.dart';
import 'package:document_scanner/features/documents/presentation/blocs/get_scanned_documents_bloc.dart';
import 'package:document_scanner/features/documents/presentation/screens/image_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DocumentsScreen extends StatefulWidget {
  static String name = 'Documents';

  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AuthenticatedAppBar(title: DocumentsScreen.name),
      body: BlocBuilder<GetScannedDocumentsBloc, GetScannedDocumentsState>(
        builder: (context, getScannedDocumentsState) {
          if (getScannedDocumentsState is GetScannedDocumentsInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          if (getScannedDocumentsState is GetScannedDocumentsSuccess) {
            List<String> documents = getScannedDocumentsState.documents;

            if (documents.isEmpty) {
              return Column(
                children: [
                  const SizedBox(
                    height: 100.0,
                  ),
                  const Icon(
                    Icons.document_scanner,
                    color: Colors.black,
                    size: 100.0,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "No documents found",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              );
            }

            return GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              crossAxisCount: 4,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: [
                for (final (index, document) in documents.indexed)
                  InkWell(
                    onTap: () {
                      context
                          .pushNamed(ImagePreviewScreen.name, pathParameters: {
                        "index": index.toString(),
                      });
                    },
                    child: Image.network(
                      document,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            );
          }
          return Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100.0,
                ),
                const Icon(
                  Icons.document_scanner,
                  color: Colors.black,
                  size: 100.0,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  "No documents found",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
