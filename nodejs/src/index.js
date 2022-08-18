const { EventHubProducerClient, EventHubConsumerClient } = require("@azure/event-hubs");

flutterAzureEventHubs = {};
flutterAzureEventHubs.eventHubProducerClient = EventHubProducerClient;
flutterAzureEventHubs.eventHubConsumerClient = EventHubConsumerClient;
flutterAzureEventHubs.instances = {};
flutterAzureEventHubs.instances.eventHubProducerClient = [];
flutterAzureEventHubs.instances.eventHubConsumerClient = [];
flutterAzureEventHubs.api = {};

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

flutterAzureEventHubs.api.createEventHubProducerClient = function (
    eventHubProducerClientId,
    connectionString,
    eventHubName,
    javascriptTransactionId,
    javascriptResultId) {

    try {
        var eventHubProducerClientInstance = new flutterAzureEventHubs.eventHubProducerClient(
            connectionString,
            eventHubName);
        flutterAzureEventHubs.setEventHubProducerClient(
            eventHubProducerClientId,
            eventHubProducerClientInstance);

        proxyInterop.postMessage(JSON.stringify({
            id: javascriptResultId,
            javascriptTransactionId: javascriptTransactionId,
            success: true,
            result: ""
        }));
    } catch (error) {
        proxyInterop.postMessage(JSON.stringify({
            id: javascriptResultId,
            javascriptTransactionId: javascriptTransactionId,
            success: false,
            result: error.toString()
        }));
    }
}

flutterAzureEventHubs.api.sendEventDataBatch = function (
    eventHubProducerClientId,
    eventDataList,
    sendBatchOptions,
    javascriptTransactionId,
    javascriptResultId) {

    var eventHubProducerClientInstance = flutterAzureEventHubs
        .getEventHubProducerClientByKey(eventHubProducerClientId);

    if (eventHubProducerClientInstance != null) {
        eventHubProducerClientInstance
            .sendBatch(eventDataList, sendBatchOptions)
            .then(function () {
                proxyInterop.postMessage(JSON.stringify({
                    id: javascriptResultId,
                    javascriptTransactionId: javascriptTransactionId,
                    success: true,
                    result: ""
                }));
            })
            .catch(function (error) {
                proxyInterop.postMessage(JSON.stringify({
                    id: javascriptResultId,
                    javascriptTransactionId: javascriptTransactionId,
                    success: false,
                    result: error.toString()
                }));
            });
    }
    else {
        proxyInterop.postMessage(JSON.stringify({
            id: javascriptResultId,
            javascriptTransactionId: javascriptTransactionId,
            success: false,
            result: "ERROR: EventHubProducerClient not found."
        }));
    }
}

flutterAzureEventHubs.api.closeEventHubProducerClient = function (
    eventHubProducerClientId,
    javascriptTransactionId,
    javascriptResultId) {

    var eventHubProducerClientInstance = flutterAzureEventHubs
        .getEventHubProducerClientByKey(eventHubProducerClientId);
    if (eventHubProducerClientInstance != null) {
        eventHubProducerClientInstance
            .close()
            .then(function () {
                proxyInterop.postMessage(JSON.stringify({
                    id: javascriptResultId,
                    javascriptTransactionId: javascriptTransactionId,
                    success: true,
                    result: ""
                }));
            })
            .catch(function (error) {
                proxyInterop.postMessage(JSON.stringify({
                    id: javascriptResultId,
                    javascriptTransactionId: javascriptTransactionId,
                    success: false,
                    result: error.toString()
                }));
            });
    }
    else {
        proxyInterop.postMessage(JSON.stringify({
            id: javascriptResultId,
            javascriptTransactionId: javascriptTransactionId,
            success: false,
            result: "ERROR: EventHubProducerClient not found."
        }));
    }
}

flutterAzureEventHubs.api.createEventHubConsumerClient = function (
    eventHubConsumerClientId,
    consumerGroup,
    connectionString,
    eventHubName,
    javascriptTransactionId,
    javascriptResultId) {

    try {
        var eventHubConsumerClientInstance = new flutterAzureEventHubs.eventHubConsumerClient(
            consumerGroup,
            connectionString,
            eventHubName);
        flutterAzureEventHubs.setEventHubConsumerClient(
            eventHubConsumerClientId,
            eventHubConsumerClientInstance);

        proxyInterop.postMessage(JSON.stringify({
            id: javascriptResultId,
            javascriptTransactionId: javascriptTransactionId,
            success: true,
            result: ""
        }));
    } catch (error) {
        proxyInterop.postMessage(JSON.stringify({
            id: javascriptResultId,
            javascriptTransactionId: javascriptTransactionId,
            success: false,
            result: error.toString()
        }));
    }
}

flutterAzureEventHubs.api.subscribe = function (
    eventHubConsumerClientId,
    subscribeOptions,
    javascriptTransactionId,
    javascriptResultId) {

    var eventHubConsumerClientInstance = flutterAzureEventHubs
        .getEventHubConsumerClientByKey(eventHubConsumerClientId);
    if (eventHubConsumerClientInstance != null) {
        eventHubConsumerClientInstance
            .subscribe({
                processEvents: function (receivedDataList, partitionContext) {
                    var incomingEvent = {};
                    incomingEvent.receivedDataList = [];
                    for (var index in receivedDataList) {
                        incomingEvent.receivedDataList.push({
                            body: receivedDataList[index].body,
                            enqueuedTimeUtc: receivedDataList[index].enqueuedTimeUtc,
                            partitionKey: receivedDataList[index].partitionKey,
                            offset: receivedDataList[index].offset,
                            sequenceNumber: receivedDataList[index].sequenceNumber
                        });
                    }
                    incomingEvent.partitionContext = {
                        fullyQualifiedNamespace: partitionContext._context.fullyQualifiedNamespace,
                        eventHubName: partitionContext._context.eventHubName,
                        consumerGroup: partitionContext._context.consumerGroup,
                        partitionId: partitionContext._context.partitionId
                    };
                    proxyInterop.postMessage(JSON.stringify({
                        id: javascriptResultId,
                        javascriptTransactionId: javascriptTransactionId,
                        success: true,
                        result: JSON.stringify(incomingEvent)
                    }));
                },
                processError: function (error) {
                    proxyInterop.postMessage(JSON.stringify({
                        id: javascriptResultId,
                        javascriptTransactionId: javascriptTransactionId,
                        success: false,
                        result: error.toString()
                    }));
                }
            }, subscribeOptions);
    }
    else {
        proxyInterop.postMessage(JSON.stringify({
            id: javascriptResultId,
            javascriptTransactionId: javascriptTransactionId,
            success: false,
            result: "ERROR: EventHubConsumerClient not found."
        }));
    }
}