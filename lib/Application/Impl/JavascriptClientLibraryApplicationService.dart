import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptClientLibraryApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptClientLibraryDomainService.dart';

class JavascriptClientLibraryApplicationService
    extends IJavascriptClientLibraryApplicationService {
  final IJavascriptClientLibraryDomainService
      _javascriptClientLibraryDomainService;
  final IJavascriptApplicationService _javascriptApplicationService;

  JavascriptClientLibraryApplicationService(
      this._javascriptClientLibraryDomainService,
      this._javascriptApplicationService);

  @override
  Future<void> initialize() async {
    var javascriptClientLibrary = await _javascriptClientLibraryDomainService
        .repositoryService
        .getJavascriptClientLibrary();
    var javascriptTransaction =
        JavascriptTransaction(Uuid().v4(), javascriptClientLibrary);
    await _javascriptApplicationService
        .executeJavascriptCode(javascriptTransaction);
  }
}
