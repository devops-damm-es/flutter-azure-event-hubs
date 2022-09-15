import 'dart:async';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_azure_event_hubs/Application/IAvroSerializerApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IClientSecretCredentialApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubConsumerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IEventHubProducerClientApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/ISchemaRegistryClientApplicationService.dart';
import 'package:flutter_azure_event_hubs_example/Presentation/Widgets/Controls/EventHubControl.dart';
import 'package:flutter_azure_event_hubs_example/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptApplicationService.dart';
import 'package:flutter_azure_event_hubs/Application/IJavascriptClientLibraryApplicationService.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: library_prefixes
import 'Crosscutting/container.dart' as IoC;

Future<void> main() async {
  IoC.Container.setup();
  WidgetsFlutterBinding.ensureInitialized();
  var javascriptApplicationService =
      IoC.Container.resolve<IJavascriptApplicationService>();
  await javascriptApplicationService.initialize();

  var javascriptClientLibraryApplicationService =
      IoC.Container.resolve<IJavascriptClientLibraryApplicationService>();
  await javascriptClientLibraryApplicationService.initialize();

  Globals.eventHubProducerClientApplicationService =
      IoC.Container.resolve<IEventHubProducerClientApplicationService>();
  Globals.eventHubConsumerClientApplicationService =
      IoC.Container.resolve<IEventHubConsumerClientApplicationService>();
  Globals.clientSecretCredentialApplicationService =
      IoC.Container.resolve<IClientSecretCredentialApplicationService>();
  Globals.schemaRegistryClientApplicationService =
      IoC.Container.resolve<ISchemaRegistryClientApplicationService>();
  Globals.avroSerializerApplicationService =
      IoC.Container.resolve<IAvroSerializerApplicationService>();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xffd8262e),
          primaryContainer: Color(0xfffc706c),
          secondary: Color(0xffff5656),
          secondaryContainer: Color(0xffff7e7e),
          tertiary: Color(0xff4a4a4a),
          tertiaryContainer: Color(0xff747474),
          appBarColor: Color(0xffff7e7e),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffoldVariantDialog,
        blendLevel: 20,
        appBarOpacity: 0.95,
        appBarElevation: 10,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xffd8262e),
          primaryContainer: Color(0xfffc706c),
          secondary: Color(0xffff5656),
          secondaryContainer: Color(0xffff7e7e),
          tertiary: Color(0xff4a4a4a),
          tertiaryContainer: Color(0xff747474),
          appBarColor: Color(0xffff7e7e),
          error: Color(0xffcf6679),
        ),
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarOpacity: 0.95,
        appBarElevation: 10,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    var height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
        appBar: AppBar(title: Text('Flutter Azure Event Hubs')),
        body: SafeArea(
            child: Container(
                width: width,
                height: height,
                child: <Widget>[
                  EventHubControl(),
                  Container(child: Text("Avro")),
                  Container(child: Text("Configuration"))
                ].elementAt(Globals.bottomNavigationBarSelectedIndex))),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: "Avro",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: "Configuration",
            )
          ],
          currentIndex: Globals.bottomNavigationBarSelectedIndex,
          onTap: (index) {
            setState(() {
              Globals.bottomNavigationBarSelectedIndex = index;
            });
          },
        ));
  }
}
