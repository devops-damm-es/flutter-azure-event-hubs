import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptClientLibraryRepositoryService.dart';

class JavascriptClientLibraryRepositoryService
    extends IJavascriptClientLibraryRepositoryService {
  Future<String> getJavascriptClientLibrary() async {
    return rootBundle
        .loadString('packages/flutter_azure_event_hubs/assets/js/app.js');
  }
}
