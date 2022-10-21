import 'package:flutter_azure_event_hubs_example/Application/Mappers/IOrderMapperService.dart';
import 'package:flutter_azure_event_hubs_example/Application/Mappers/Impl/OrderMapperService.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:flutter_azure_event_hubs/Crosscutting/Container.dart'
    as package;

class Container {
  static void setup() {
    var container = kiwi.KiwiContainer();

    // Package Services
    package.Container.registerInKiwiContainer(container);

    // Application Services
    container
        .registerFactory<IOrderMapperService>((c) => new OrderMapperService());

    // Domain Services

    // Repository Services
  }

  static T resolve<T>() {
    return kiwi.KiwiContainer().resolve<T>();
  }
}
