import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:flutter_azure_event_hubs/Crosscutting/Container.dart' as package;

class Container {
  static void setup() {
    var container = kiwi.KiwiContainer();
    
    // Package Services
    package.Container.registerInKiwiContainer(container);
    
    // Application Services

    // Domain Services

    // Repository Services
  }

  static T resolve<T>() {
    return kiwi.KiwiContainer().resolve<T>();
  }
}
