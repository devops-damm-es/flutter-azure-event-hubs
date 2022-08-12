const { EventHubProducerClient, EventHubConsumerClient } = require("@azure/event-hubs");

flutterAzureEventHubs = {};
flutterAzureEventHubs.eventHubProducerClient = EventHubProducerClient;
flutterAzureEventHubs.eventHubConsumerClient = EventHubConsumerClient;
flutterAzureEventHubs.instances = {};
flutterAzureEventHubs.instances.eventHubProducerClient = [];
flutterAzureEventHubs.instances.eventHubConsumerClient = [];

flutterAzureEventHubs.setEventHubProducerClient = function (key, value) {
    flutterAzureEventHubs.instances.eventHubProducerClient.push({ key: key, value: value });
}

flutterAzureEventHubs.getEventHubProducerClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.eventHubProducerClient.length; i++) {
        if (flutterAzureEventHubs.instances.eventHubProducerClient[i].key === key) {
            return flutterAzureEventHubs.instances.eventHubProducerClient[i].value;
        }
    }
}

flutterAzureEventHubs.removeEventHubProducerClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.eventHubProducerClient.length; i++) {
        if (flutterAzureEventHubs.instances.eventHubProducerClient[i].key === key) {
            flutterAzureEventHubs.instances.eventHubProducerClient.splice(i, 1);
            i--;
            break;
        }
    }
}

flutterAzureEventHubs.setEventHubConsumerClient = function (key, value) {
    flutterAzureEventHubs.instances.eventHubConsumerClient.push({ key: key, value: value });
}

flutterAzureEventHubs.getEventHubConsumerClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.eventHubConsumerClient.length; i++) {
        if (flutterAzureEventHubs.instances.eventHubConsumerClient[i].key === key) {
            return flutterAzureEventHubs.instances.eventHubConsumerClient[i].value;
        }
    }
}

flutterAzureEventHubs.removeEventHubConsumerClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.eventHubConsumerClient.length; i++) {
        if (flutterAzureEventHubs.instances.eventHubConsumerClient[i].key === key) {
            flutterAzureEventHubs.instances.eventHubConsumerClient.splice(i, 1);
            i--;
            break;
        }
    }
}