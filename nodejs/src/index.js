const { EventHubProducerClient, EventHubConsumerClient } = require("@azure/event-hubs");

flutterAzureEventHubs = {};
flutterAzureEventHubs.eventHubProducerClient = EventHubProducerClient;
flutterAzureEventHubs.eventHubConsumerClient = EventHubConsumerClient;
flutterAzureEventHubs.instances = {};
flutterAzureEventHubs.instances.eventHubProducerClientList = [];
flutterAzureEventHubs.instances.eventHubConsumerClientList = [];
flutterAzureEventHubs.instances.subscriptionList = [];
flutterAzureEventHubs.api = {};

flutterAzureEventHubs.setEventHubProducerClient = function (key, value) {
    flutterAzureEventHubs.instances.eventHubProducerClientList.push({ key: key, value: value });
}

flutterAzureEventHubs.getEventHubProducerClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.eventHubProducerClientList.length; i++) {
        if (flutterAzureEventHubs.instances.eventHubProducerClientList[i].key === key) {
            return flutterAzureEventHubs.instances.eventHubProducerClientList[i].value;
        }
    }
}

flutterAzureEventHubs.removeEventHubProducerClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.eventHubProducerClientList.length; i++) {
        if (flutterAzureEventHubs.instances.eventHubProducerClientList[i].key === key) {
            flutterAzureEventHubs.instances.eventHubProducerClientList.splice(i, 1);
            i--;
            break;
        }
    }
}

flutterAzureEventHubs.setEventHubConsumerClient = function (key, value) {
    flutterAzureEventHubs.instances.eventHubConsumerClientList.push({ key: key, value: value });
}

flutterAzureEventHubs.getEventHubConsumerClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.eventHubConsumerClientList.length; i++) {
        if (flutterAzureEventHubs.instances.eventHubConsumerClientList[i].key === key) {
            return flutterAzureEventHubs.instances.eventHubConsumerClientList[i].value;
        }
    }
}

flutterAzureEventHubs.removeEventHubConsumerClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.eventHubConsumerClientList.length; i++) {
        if (flutterAzureEventHubs.instances.eventHubConsumerClientList[i].key === key) {
            flutterAzureEventHubs.instances.eventHubConsumerClientList.splice(i, 1);
            i--;
            break;
        }
    }
}

flutterAzureEventHubs.setSubscription = function (key, value) {
    flutterAzureEventHubs.instances.subscriptionList.push({ key: key, value: value });
}

flutterAzureEventHubs.getSubscriptionByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.subscriptionList.length; i++) {
        if (flutterAzureEventHubs.instances.subscriptionList[i].key === key) {
            return flutterAzureEventHubs.instances.subscriptionList[i].value;
        }
    }
}

flutterAzureEventHubs.removeSubscriptionByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.subscriptionList.length; i++) {
        if (flutterAzureEventHubs.instances.subscriptionList[i].key === key) {
            flutterAzureEventHubs.instances.subscriptionList.splice(i, 1);
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
                flutterAzureEventHubs.removeEventHubProducerClientByKey(eventHubProducerClientId);

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
    subscriptionId,
    subscribeOptions,
    javascriptTransactionId,
    javascriptResultId) {

    var eventHubConsumerClientInstance = flutterAzureEventHubs
        .getEventHubConsumerClientByKey(eventHubConsumerClientId);
    if (eventHubConsumerClientInstance != null) {
        try {
            var subscription = eventHubConsumerClientInstance
                .subscribe({
                    processEvents: function (receivedEventDataList, partitionContext) {
                        var incomingEvent = {};
                        incomingEvent.receivedEventDataList = [];
                        for (var index in receivedEventDataList) {
                            incomingEvent.receivedEventDataList.push({
                                body: receivedEventDataList[index].body,
                                enqueuedTimeUtc: receivedEventDataList[index].enqueuedTimeUtc,
                                partitionKey: receivedEventDataList[index].partitionKey,
                                offset: receivedEventDataList[index].offset,
                                sequenceNumber: receivedEventDataList[index].sequenceNumber
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
                            javascriptTransactionId: subscriptionId,
                            success: true,
                            result: JSON.stringify(incomingEvent)
                        }));
                    },
                    processError: function (error) {
                        proxyInterop.postMessage(JSON.stringify({
                            id: javascriptResultId,
                            javascriptTransactionId: subscriptionId,
                            success: false,
                            result: error.toString()
                        }));
                    }
                }, subscribeOptions);

            flutterAzureEventHubs.setSubscription(
                subscriptionId,
                subscription);

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
    else {
        proxyInterop.postMessage(JSON.stringify({
            id: javascriptResultId,
            javascriptTransactionId: javascriptTransactionId,
            success: false,
            result: "ERROR: EventHubConsumerClient not found."
        }));
    }
}

flutterAzureEventHubs.api.closeSubscription = function (
    subscriptionId,
    javascriptTransactionId,
    javascriptResultId) {

    var subscriptionInstance = flutterAzureEventHubs.getSubscriptionByKey(subscriptionId);
    if (subscriptionInstance != null) {
        subscriptionInstance
            .close()
            .then(function () {
                flutterAzureEventHubs.removeSubscriptionByKey(subscriptionId);

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
            result: "ERROR: Subscription not found."
        }));
    }
}