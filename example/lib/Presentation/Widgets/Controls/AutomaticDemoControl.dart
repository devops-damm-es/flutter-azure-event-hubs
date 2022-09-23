import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_azure_event_hubs_example/Presentation/Widgets/State/AutomaticDemoState.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-legend.dart';

class AutomaticDemoControl extends StatefulWidget {
  @override
  State<AutomaticDemoControl> createState() => _AutomaticDemoControlState();
}

class _AutomaticDemoControlState extends State<AutomaticDemoControl> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext layoutContext, BoxConstraints boxConstraints) {
      var width = boxConstraints.maxWidth;
      if (width < 360) {
        width = 360;
      }

      var height = boxConstraints.maxHeight;
      if (height < 480) {
        height = 480;
      }

      var widthBreakpoint = Breakpoint.fromConstraints(
          BoxConstraints(maxWidth: width, maxHeight: height));
      var breakpointMarginWidth = widthBreakpoint.gutters;
      var breakpointGutterWidth = widthBreakpoint.gutters;

      var breakpointColumnsWidth = (width -
              (((breakpointMarginWidth + breakpointGutterWidth) / 2) *
                  (widthBreakpoint.columns + 1))) /
          widthBreakpoint.columns;

      var heightBreakpoint = Breakpoint.fromConstraints(
          BoxConstraints(maxWidth: height, maxHeight: width));
      var breakpointMarginHeight = heightBreakpoint.gutters;
      var breakpointGutterHeight = heightBreakpoint.gutters;

      var breakpointColumnsHeight = (height -
              (((breakpointMarginHeight + breakpointGutterHeight) / 2) *
                  (heightBreakpoint.columns + 1))) /
          heightBreakpoint.columns;

      var eventHubProducerWidth =
          (breakpointColumnsWidth * widthBreakpoint.columns) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 1));

      var eventHubProducerHeight = breakpointColumnsHeight;

      var eventHubConsumerWidth =
          (breakpointColumnsWidth * widthBreakpoint.columns) +
              (breakpointGutterWidth * (widthBreakpoint.columns - 1));

      var eventHubConsumerHeight =
          (breakpointColumnsHeight * (heightBreakpoint.columns - 1)) +
              (breakpointGutterHeight * (heightBreakpoint.columns - 2));

      var eventHubProducerWidgets = <Widget>[
        Container(
            width: eventHubProducerWidth,
            height: eventHubProducerHeight,
            child: TextField(
                decoration: InputDecoration(
                    labelText: 'Name:',
                    counterText: "",
                    border: OutlineInputBorder()),
                controller: AutomaticDemoState.textEditingController,
                keyboardType: TextInputType.name,
                textAlignVertical: TextAlignVertical.top,
                readOnly: false,
                maxLength: 100))
      ];

      var eventHubConsumerWidgets = <Widget>[
        Container(
            width: eventHubConsumerWidth,
            height: eventHubConsumerHeight,
            child: VerticalBarchart(
                maxX: 55,
                data: AutomaticDemoState.vBarChartModelList,
                showLegend: true,
                showBackdrop: true,
                barStyle: BarStyle.CIRCLE,
                alwaysShowDescription: true,
                legend: [
                  Vlegend(
                    isSquare: false,
                    color: Theme.of(context).primaryColor,
                    text: "Messages",
                  )
                ]))
      ];

      return Scrollbar(
          thumbVisibility: true,
          trackVisibility: true,
          controller: AutomaticDemoState.verticalScrollController,
          child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notificationPredicate) =>
                  notificationPredicate.depth == 1,
              controller: AutomaticDemoState.horizontalScrollController,
              child: SingleChildScrollView(
                  controller: AutomaticDemoState.verticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      controller: AutomaticDemoState.horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                          width: width,
                          height: height,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 10, height: breakpointMarginHeight),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: eventHubProducerWidgets),
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10)
                                    ]),
                                Container(
                                    width: 10, height: breakpointGutterHeight),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: eventHubConsumerWidgets),
                                      Container(
                                          width: breakpointMarginWidth,
                                          height: 10)
                                    ]),
                                Container(
                                    width: 10, height: breakpointMarginHeight)
                              ]))))));
    });
  }
}
