import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptRepositoryService.dart';

class JavascriptDomainService extends IJavascriptDomainService {
  final IJavascriptRepositoryService _repositoryService;

  JavascriptDomainService(this._repositoryService);

  @override
  IJavascriptRepositoryService get repositoryService => _repositoryService;
}
