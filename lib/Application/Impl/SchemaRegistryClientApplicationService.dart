import 'dart:async';

import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/ISchemaRegistryClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/ClientSecretCredential.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResultStreamSink.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClientOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/ISchemaRegistryClientDomainService.dart';
import 'package:uuid/uuid.dart';

class SchemaRegistryClientApplicationService
    extends ISchemaRegistryClientApplicationService {
  final ISchemaRegistryClientDomainService _schemaRegistryClientDomainService;
  final IJavascriptApplicationService _javascriptApplicationService;

  SchemaRegistryClientApplicationService(
      this._schemaRegistryClientDomainService,
      this._javascriptApplicationService);

  @override
  Future<SchemaRegistryClient> createSchemaRegistryClient(
      String fullyQualifiedNamespace,
      ClientSecretCredential clientSecretCredential,
      {SchemaRegistryClientOptions? schemaRegistryClientOptions}) async {
    var schemaRegistryClient =
        SchemaRegistryClient(Uuid().v4(), fullyQualifiedNamespace);

    var waitStreamController = StreamController<bool>();
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var createSchemaRegistryClientJavascriptTransaction =
        await _schemaRegistryClientDomainService.repositoryService
            .getCreateSchemaRegistryClientJavascriptTransaction(
                schemaRegistryClient,
                clientSecretCredential,
                schemaRegistryClientOptions);

    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId ==
          createSchemaRegistryClientJavascriptTransaction.id) {
        javascriptResult = event;
        waitStreamController.sink.add(true);
      }
    });
    await _javascriptApplicationService
        .executeJavascriptCode(createSchemaRegistryClientJavascriptTransaction);
    await waitStreamController.stream.first;
    await waitStreamController.close();

    await _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    await javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      return Future.value(schemaRegistryClient);
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }
}
