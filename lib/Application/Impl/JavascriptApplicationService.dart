import 'dart:async';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptDomainService.dart';

class JavascriptApplicationService extends IJavascriptApplicationService {
  final IJavascriptDomainService _javascriptDomainService;
  final IJavascriptResultMapperService _javascriptResultMapperService;

  JavascriptApplicationService(
      this._javascriptDomainService, this._javascriptResultMapperService);

  final StreamController<String> _javascriptMessageStringStreamController =
      StreamController<String>();

  @override
  Future<void> initialize() async {
    _javascriptMessageStringStreamController.stream.listen((event) async {
      try {
        var javascriptResult =
            await _javascriptResultMapperService.fromJson(event);
      } catch (_) {}
      print("JavascriptMessageString event: " + event);
    });
    _javascriptDomainService.repositoryService
        .initialize(_javascriptMessageStringStreamController.sink);
  }

  @override
  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction) async {
    _javascriptDomainService.repositoryService
        .executeJavascriptCode(javascriptTransaction);
  }

  @override
  Future<void> finalize() async {
    _javascriptMessageStringStreamController.close();
  }
}
