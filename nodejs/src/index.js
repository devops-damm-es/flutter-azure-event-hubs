const { EventHubProducerClient, EventHubConsumerClient } = require("@azure/event-hubs");
const { ClientSecretCredential } = require("@azure/identity");
const { SchemaRegistryClient } = require("@azure/schema-registry");
const { AvroSerializer } = require("@azure/schema-registry-avro");

flutterAzureEventHubs = {};
flutterAzureEventHubs.eventHubProducerClient = EventHubProducerClient;
flutterAzureEventHubs.eventHubConsumerClient = EventHubConsumerClient;
flutterAzureEventHubs.clientSecretCredential = ClientSecretCredential;
flutterAzureEventHubs.schemaRegistryClient = SchemaRegistryClient;
flutterAzureEventHubs.avroSerializer = AvroSerializer;
flutterAzureEventHubs.instances = {};
flutterAzureEventHubs.instances.eventHubProducerClientList = [];
flutterAzureEventHubs.instances.eventHubConsumerClientList = [];
flutterAzureEventHubs.instances.subscriptionList = [];
flutterAzureEventHubs.instances.clientSecretCredentialList = [];
flutterAzureEventHubs.instances.schemaRegistryClientList = [];
flutterAzureEventHubs.instances.avroSerializerList = [];
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

flutterAzureEventHubs.setClientSecretCredential = function (key, value) {
    flutterAzureEventHubs.instances.clientSecretCredentialList.push({ key: key, value: value });
}

flutterAzureEventHubs.getClientSecretCredentialByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.clientSecretCredentialList.length; i++) {
        if (flutterAzureEventHubs.instances.clientSecretCredentialList[i].key === key) {
            return flutterAzureEventHubs.instances.clientSecretCredentialList[i].value;
        }
    }
}

flutterAzureEventHubs.removeClientSecretCredentialByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.clientSecretCredentialList.length; i++) {
        if (flutterAzureEventHubs.instances.clientSecretCredentialList[i].key === key) {
            flutterAzureEventHubs.instances.clientSecretCredentialList.splice(i, 1);
            i--;
            break;
        }
    }
}

flutterAzureEventHubs.setSchemaRegistryClient = function (key, value) {
    flutterAzureEventHubs.instances.schemaRegistryClientList.push({ key: key, value: value });
}

flutterAzureEventHubs.getSchemaRegistryClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.schemaRegistryClientList.length; i++) {
        if (flutterAzureEventHubs.instances.schemaRegistryClientList[i].key === key) {
            return flutterAzureEventHubs.instances.schemaRegistryClientList[i].value;
        }
    }
}

flutterAzureEventHubs.removeSchemaRegistryClientByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.schemaRegistryClientList.length; i++) {
        if (flutterAzureEventHubs.instances.schemaRegistryClientList[i].key === key) {
            flutterAzureEventHubs.instances.schemaRegistryClientList.splice(i, 1);
            i--;
            break;
        }
    }
}

flutterAzureEventHubs.setAvroSerializer = function (key, value) {
    flutterAzureEventHubs.instances.avroSerializerList.push({ key: key, value: value });
}

flutterAzureEventHubs.getAvroSerializerByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.avroSerializerList.length; i++) {
        if (flutterAzureEventHubs.instances.avroSerializerList[i].key === key) {
            return flutterAzureEventHubs.instances.avroSerializerList[i].value;
        }
    }
}

flutterAzureEventHubs.removeAvroSerializerByKey = function (key) {
    for (var i = 0; i < flutterAzureEventHubs.instances.avroSerializerList.length; i++) {
        if (flutterAzureEventHubs.instances.avroSerializerList[i].key === key) {
            flutterAzureEventHubs.instances.avroSerializerList.splice(i, 1);
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
            var subscriptionInstance = eventHubConsumerClientInstance
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
                subscriptionInstance);

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

flutterAzureEventHubs.api.closeEventHubConsumerClient = function (
    eventHubConsumerClientId,
    subscriptionIdList,
    javascriptTransactionId,
    javascriptResultId) {

    var eventHubConsumerClientInstance = flutterAzureEventHubs
        .getEventHubConsumerClientByKey(eventHubConsumerClientId);
    if (eventHubConsumerClientInstance != null) {
        eventHubConsumerClientInstance
            .close()
            .then(function () {
                for (var index in subscriptionIdList) {
                    flutterAzureEventHubs.removeSubscriptionByKey(subscriptionIdList[index]);
                }
                flutterAzureEventHubs.removeEventHubConsumerClientByKey(eventHubConsumerClientId);

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
            result: "ERROR: EventHubConsumerClient not found."
        }));
    }
}

flutterAzureEventHubs.api.createClientSecretCredential = function (
    clientSecretCredentialId,
    tenantId,
    clientId,
    clientSecret,
    tokenCredentialOptions,
    javascriptTransactionId,
    javascriptResultId) {

    try {
        var clientSecretCredentialInstance = new flutterAzureEventHubs.clientSecretCredential(
            tenantId,
            clientId,
            clientSecret,
            tokenCredentialOptions);
        flutterAzureEventHubs.setClientSecretCredential(
            clientSecretCredentialId,
            clientSecretCredentialInstance);

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

flutterAzureEventHubs.api.createSchemaRegistryClient = function (
    schemaRegistryClientId,
    fullyQualifiedNamespace,
    clientSecretCredentialId,
    schemaRegistryClientOptions,
    javascriptTransactionId,
    javascriptResultId) {

    var clientSecretCredentialInstance = flutterAzureEventHubs
        .getClientSecretCredentialByKey(clientSecretCredentialId);
    if (clientSecretCredentialInstance != null) {
        try {
            var schemaRegistryClientInstance = new flutterAzureEventHubs.schemaRegistryClient(
                fullyQualifiedNamespace,
                clientSecretCredentialInstance,
                schemaRegistryClientOptions);
            flutterAzureEventHubs.setSchemaRegistryClient(
                schemaRegistryClientId,
                schemaRegistryClientInstance);

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
            result: "ERROR: ClientSecretCredential not found."
        }));
    }
}

flutterAzureEventHubs.api.getSchemaProperties = function (
    schemaRegistryClientId,
    schemaDescription,
    javascriptTransactionId,
    javascriptResultId) {

    var schemaRegistryClientInstance = flutterAzureEventHubs
        .getSchemaRegistryClientByKey(schemaRegistryClientId);
    if (schemaRegistryClientInstance != null) {
        schemaRegistryClientInstance
            .getSchemaProperties(schemaDescription)
            .then(function (schemaProperties) {
                proxyInterop.postMessage(JSON.stringify({
                    id: javascriptResultId,
                    javascriptTransactionId: javascriptTransactionId,
                    success: true,
                    result: JSON.stringify({
                        id: schemaProperties.id,
                        format: schemaProperties.format,
                        groupName: schemaProperties.groupName,
                        name: schemaProperties.name
                    })
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
            result: "ERROR: SchemaRegistryClient not found."
        }));
    }
}

flutterAzureEventHubs.api.createAvroSerializer = function (
    avroSerializerId,
    schemaRegistryClientId,
    avroSerializerOptions,
    javascriptTransactionId,
    javascriptResultId) {
    var schemaRegistryClientInstance = flutterAzureEventHubs
        .getSchemaRegistryClientByKey(schemaRegistryClientId);
    if (schemaRegistryClientInstance != null) {
        try {
            var avroSerializerInstance = new flutterAzureEventHubs.avroSerializer(
                schemaRegistryClientInstance,
                avroSerializerOptions);
            flutterAzureEventHubs.setAvroSerializer(
                avroSerializerId,
                avroSerializerInstance);

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
            result: "ERROR: SchemaRegistryClient not found."
        }));
    }
}

flutterAzureEventHubs.api.serialize = function (
    avroSerializerId,
    value,
    schema,
    javascriptTransactionId,
    javascriptResultId) {
    var avroSerializerInstance = flutterAzureEventHubs
        .getAvroSerializerByKey(avroSerializerId);
    if (avroSerializerInstance != null) {
        avroSerializerInstance
            .serialize(value, schema)
            .then(function (messageContent) {
                proxyInterop.postMessage(JSON.stringify({
                    id: javascriptResultId,
                    javascriptTransactionId: javascriptTransactionId,
                    success: true,
                    result: JSON.stringify({
                        data: Array.apply([], messageContent.data),
                        contentType: messageContent.contentType
                    })
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
            result: "ERROR: AvroSerializer not found."
        }));
    }
}

flutterAzureEventHubs.api.deserialize = function (
    avroSerializerId,
    messageContent,
    deserializeOptions,
    javascriptTransactionId,
    javascriptResultId) {

    var avroSerializerInstance = flutterAzureEventHubs
        .getAvroSerializerByKey(avroSerializerId);
    if (avroSerializerInstance != null) {
        avroSerializerInstance
            .deserialize(messageContent, deserializeOptions)
            .then(function (value) {
                proxyInterop.postMessage(JSON.stringify({
                    id: javascriptResultId,
                    javascriptTransactionId: javascriptTransactionId,
                    success: true,
                    result: JSON.stringify(value)
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
            result: "ERROR: AvroSerializer not found."
        }));
    }
}