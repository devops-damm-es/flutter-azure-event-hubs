import 'package:flutter_azure_event_hubs/Domain/Services/IJavascriptClientLibraryDomainService.dart';
import 'package:flutter_azure_event_hubs/Infrastructure/Repositories/IJavascriptClientLibraryRepositoryService.dart';

class JavascriptClientLibraryDomainService
    extends IJavascriptClientLibraryDomainService {
  final IJavascriptClientLibraryRepositoryService _repositoryService;

  JavascriptClientLibraryDomainService(this._repositoryService);

  @override
  IJavascriptClientLibraryRepositoryService get repositoryService =>
      _repositoryService;
}
