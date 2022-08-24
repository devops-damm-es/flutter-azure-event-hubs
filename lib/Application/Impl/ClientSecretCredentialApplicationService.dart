import 'dart:async';

import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IClientSecretCredentialApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResultStreamSink.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/ClientSecretCredential.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/TokenCredentialOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IClientSecretCredentialDomainService.dart';
import 'package:uuid/uuid.dart';

class ClientSecretCredentialApplicationService
    extends IClientSecretCredentialApplicationService {
  final IClientSecretCredentialDomainService
      _clientSecretCredentialDomainService;
  final IJavascriptApplicationService _javascriptApplicationService;

  ClientSecretCredentialApplicationService(
      this._clientSecretCredentialDomainService,
      this._javascriptApplicationService);

  @override
  Future<ClientSecretCredential> createClientSecretCredential(
      String tenantId, String clientId, String clientSecret,
      {TokenCredentialOptions? tokenCredentialOptions}) async {
    var clientSecretCredential =
        ClientSecretCredential(Uuid().v4(), tenantId, clientId, clientSecret);

    var waitStreamController = StreamController<bool>();
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var createClientSecretCredentialJavascriptTransaction =
        await _clientSecretCredentialDomainService.repositoryService
            .getCreateClientSecretCredentialJavascriptTransaction(
                clientSecretCredential, tokenCredentialOptions);

    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId ==
          createClientSecretCredentialJavascriptTransaction.id) {
        javascriptResult = event;
        waitStreamController.sink.add(true);
      }
    });
    await _javascriptApplicationService.executeJavascriptCode(
        createClientSecretCredentialJavascriptTransaction);
    await waitStreamController.stream.first;
    await waitStreamController.close();

    await _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    await javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      return Future.value(clientSecretCredential);
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }
}
