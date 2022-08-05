const { EventHubProducerClient, EventHubConsumerClient } = require("@azure/event-hubs");

eventHubProducerClient = EventHubProducerClient;
eventHubConsumerClient = EventHubConsumerClient;

var instances = {};
instances.eventHubProducerClient = [];
instances.eventHubConsumerClient = [];

function setEventHubProducerClient(key, value) {
    instances.eventHubProducerClient.push({ key: key, value: value });
}

function getEventHubProducerClientByKey(key) {
    for (var instance in instances.eventHubProducerClient) {
        if (instance.key === key) {
            return instance.value;
        }
    }
}

function removeEventHubProducerClientByKey(key) {
    for (var i = 0; i < instances.eventHubProducerClient.length; i++) {
        if (instances.eventHubProducerClient[i].key === key) {
            instances.eventHubProducerClient.splice(i, 1);
            i--;
            break;
        }
    }
}

function setEventHubConsumerClient(key, value) {
    instances.eventHubConsumerClient.push({ key: key, value: value });
}

function getEventHubConsumerClientByKey(key) {
    for (var instance in instances.eventHubConsumerClient) {
        if (instance.key === key) {
            return instance.value;
        }
    }
}

function removeEventHubConsumerClientByKey(key) {
    for (var i = 0; i < instances.eventHubConsumerClient.length; i++) {
        if (instances.eventHubConsumerClient[i].key === key) {
            instances.eventHubConsumerClient.splice(i, 1);
            i--;
            break;
        }
    }
}