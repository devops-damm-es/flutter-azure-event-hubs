import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializer.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/AvroSerializerOptions.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/JavascriptTransaction.dart';
import 'package:flutter_azure_event_hubs/Domain/Entities/SchemaRegistryClient.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Mappers/IAvroSerializerOptionsMapperService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IAvroSerializerRepositoryService.dart';
import 'package:uuid/uuid.dart';

class AvroSerializerRepositoryService extends IAvroSerializerRepositoryService {
  final IAvroSerializerOptionsMapperService _avroSerializerOptionsMapperService;

  AvroSerializerRepositoryService(this._avroSerializerOptionsMapperService);

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
}
