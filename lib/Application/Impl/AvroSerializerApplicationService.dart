import 'dart:async';

import 'package:flutter_azure_event_hubs/Application/IAvroSerializerApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/Mappers/IMessageContentMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResult.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptResultStreamSink.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/MessageContent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';
import 'package:flutter_azure_event_hubs/Domain/Services/IAvroSerializerDomainService.dart';
import 'package:uuid/uuid.dart';

class AvroSerializerApplicationService
    extends IAvroSerializerApplicationService {
  final IAvroSerializerDomainService _avroSerializerDomainService;
  final IJavascriptApplicationService _javascriptApplicationService;
  final IMessageContentMapperService _messageContentMapperService;

  AvroSerializerApplicationService(this._avroSerializerDomainService,
      this._javascriptApplicationService, this._messageContentMapperService);

  @override
  Future<AvroSerializer> createAvroSerializer(
      SchemaRegistryClient schemaRegistryClient,
      {AvroSerializerOptions? avroSerializerOptions}) async {
    var avroSerializer = AvroSerializer(Uuid().v4(), schemaRegistryClient);

    var waitStreamController = StreamController<bool>();
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    await _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var createAvroSerializerJavascriptTransaction =
        await _avroSerializerDomainService.repositoryService
            .getCreateAvroSerializerJavascriptTransaction(
                avroSerializer, schemaRegistryClient, avroSerializerOptions);

    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId ==
          createAvroSerializerJavascriptTransaction.id) {
        javascriptResult = event;
        waitStreamController.sink.add(true);
      }
    });
    _javascriptApplicationService
        .executeJavascriptCode(createAvroSerializerJavascriptTransaction);
    await waitStreamController.stream.first;
    await waitStreamController.close();

    await _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    await javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      return Future.value(avroSerializer);
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }

  @override
  Future<MessageContent> serialize(
      AvroSerializer avroSerializer, String value, String schema) async {
    var waitStreamController = StreamController<bool>();
    var javascriptResultStreamController = StreamController<JavascriptResult>();
    var javascriptResultStreamSink = JavascriptResultStreamSink(
        Uuid().v4(), javascriptResultStreamController.sink);
    await _javascriptApplicationService
        .subscribeJavascriptResultStreamSink(javascriptResultStreamSink);

    var getSerializeJavascriptTransaction = await _avroSerializerDomainService
        .repositoryService
        .getSerializeJavascriptTransaction(avroSerializer, value, schema);

    JavascriptResult? javascriptResult;
    javascriptResultStreamController.stream.listen((event) {
      if (event.javascriptTransactionId ==
          getSerializeJavascriptTransaction.id) {
        javascriptResult = event;
        waitStreamController.sink.add(true);
      }
    });
    await _javascriptApplicationService
        .executeJavascriptCode(getSerializeJavascriptTransaction);
    await waitStreamController.stream.first;
    await waitStreamController.close();

    await _javascriptApplicationService
        .unsubscribeJavascriptResultStreamSink(javascriptResultStreamSink);
    await javascriptResultStreamController.close();

    if (javascriptResult!.success == true) {
      var messageContent =
          await _messageContentMapperService.fromJson(javascriptResult!.result);
      return Future.value(messageContent);
    } else {
      throw new Exception(javascriptResult!.result);
    }
  }
}
