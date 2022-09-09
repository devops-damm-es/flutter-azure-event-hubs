import 'package:flutter_azure_event_hubs/Crosscutting/Mappers/IMessageContentMapperService.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/DeserializeOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/MessageContent.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IAvroSerializerOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IDeserializeOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IAvroSerializerRepositoryService.dart';
import 'package:uuid/uuid.dart';

class AvroSerializerRepositoryService extends IAvroSerializerRepositoryService {
  final IAvroSerializerOptionsMapperService _avroSerializerOptionsMapperService;
  final IMessageContentMapperService _messageContentMapperService;
  final IDeserializeOptionsMapperService _deserializeOptionsMapperService;

  AvroSerializerRepositoryService(this._avroSerializerOptionsMapperService,
      this._messageContentMapperService, this._deserializeOptionsMapperService);

  @override
  Future<JavascriptTransaction> getCreateAvroSerializerJavascriptTransaction(
      AvroSerializer avroSerializer,
      SchemaRegistryClient schemaRegistryClient,
      AvroSerializerOptions? avroSerializerOptions) async {
    var jsonAvroSerializerOptions = "{}";
    if (avroSerializerOptions != null) {
      jsonAvroSerializerOptions = await _avroSerializerOptionsMapperService
          .toJson(avroSerializerOptions);
    }

    var javascriptTransactionId = Uuid().v4();
    var javascriptCode = "flutterAzureEventHubs.api.createAvroSerializer('" +
        avroSerializer.id +
        "', '" +
        schemaRegistryClient.id +
        "', " +
        jsonAvroSerializerOptions +
        ", '" +
        javascriptTransactionId +
        "', '" +
        Uuid().v4() +
        "');";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }

  @override
  Future<JavascriptTransaction> getSerializeJavascriptTransaction(
      AvroSerializer avroSerializer, String jsonValue, String schema) async {
    var javascriptTransactionId = Uuid().v4();
    var javascriptCode = "flutterAzureEventHubs.api.serialize('" +
        avroSerializer.id +
        "', " +
        jsonValue +
        ", '" +
        schema +
        "', '" +
        javascriptTransactionId +
        "', '" +
        Uuid().v4() +
        "');";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }

  @override
  Future<JavascriptTransaction> getDeserializeJavascriptTransaction(
      AvroSerializer avroSerializer,
      MessageContent messageContent,
      DeserializeOptions? deserializeOptions) async {
    var jsonMessageContent =
        await _messageContentMapperService.toJson(messageContent);

    var jsonDeserializeOptions = "{}";
    if (deserializeOptions != null) {
      jsonDeserializeOptions =
          await _deserializeOptionsMapperService.toJson(deserializeOptions);
    }

    var javascriptTransactionId = Uuid().v4();
    var javascriptCode = "flutterAzureEventHubs.api.deserialize('" +
        avroSerializer.id +
        "', " +
        jsonMessageContent +
        ", " +
        jsonDeserializeOptions +
        ", '" +
        javascriptTransactionId +
        "', '" +
        Uuid().v4() +
        "');";

    var javascriptTransaction =
        JavascriptTransaction(javascriptTransactionId, javascriptCode);
    return Future.value(javascriptTransaction);
  }
}
