import 'dart:async';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IJavascriptResultMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResultStreamSink.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptDomainService.dart';

class JavascriptApplicationService extends IJavascriptApplicationService {
  final IJavascriptDomainService _javascriptDomainService;
  final IJavascriptResultMapperService _javascriptResultMapperService;

  JavascriptApplicationService(
      this._javascriptDomainService, this._javascriptResultMapperService);

  final StreamController<String> _javascriptMessageStringStreamController =
      StreamController<String>();

  final List<JavascriptResultStreamSink> _javascriptResultStreamSinkList =
      List<JavascriptResultStreamSink>.empty(growable: true);

  @override
  Future<void> initialize() async {
    _javascriptMessageStringStreamController.stream.listen((event) async {
      try {
        var javascriptResult =
            await _javascriptResultMapperService.fromJson(event);
        _javascriptResultStreamSinkList.forEach((element) {
          element.javascriptResultStreamSink.add(javascriptResult);
        });
      } catch (error) {
        print("ERROR: " + error.toString());
      }
      print("JavascriptMessageString event: " + event);
    });
    await _javascriptDomainService.repositoryService
        .initialize(_javascriptMessageStringStreamController.sink);
  }

  @override
  Future<void> subscribeJavascriptResultStreamSink(
      JavascriptResultStreamSink javascriptResultStreamSink) async {
    _javascriptResultStreamSinkList.add(javascriptResultStreamSink);
  }

  @override
  Future<void> unsubscribeJavascriptResultStreamSink(
      JavascriptResultStreamSink javascriptResultStreamSink) async {
    _javascriptResultStreamSinkList
        .removeWhere((element) => element.id == javascriptResultStreamSink.id);
  }

  @override
  Future<void> executeJavascriptCode(
      JavascriptTransaction javascriptTransaction) async {
    await _javascriptDomainService.repositoryService
        .executeJavascriptCode(javascriptTransaction);
  }

  @override
  Future<void> finalize() async {
    await _javascriptMessageStringStreamController.close();
  }
}
