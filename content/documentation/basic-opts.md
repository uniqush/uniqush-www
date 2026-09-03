---
title: Basic Operations
aliases:
  - /wiki/UniqushOperations/index.html
---

This document covers the operations uniqush-push provides, without
implementation detail. See [Basic Concepts](/documentation/basic-concept.html)
first if you haven't already.

## How to Communicate with Uniqush

uniqush-push runs as a standalone service; you don't write code against a
library. It listens on a TCP port (configurable) and accepts an HTTP POST
request with parameters in the body.

## Adding Push Service Providers to a Service

Before uniqush-push can send anything for a service, it needs to know about a
push service provider: the type (FCM, APNs, ADM, UnifiedPush/Web Push) and
its authentication information — an API credential for FCM, private/public
keys for APNs, and so on.

A service can have more than one provider, to support multiple platforms at
once.

## Subscribing to a Service

When a subscriber subscribes to a service, uniqush-push needs at least three
things: the subscriber's id, the service name, and the delivery point
information (the device's identity, its platform, and any other
platform-specific details).

Sending this information from a mobile app directly to uniqush-push is
possible but not recommended: if your uniqush-push server is publicly
reachable, an unauthenticated `/subscribe` lets anyone register or remove
subscriptions. Put uniqush-push behind a server that authenticates the
request, and have your own backend forward only the fields uniqush-push
needs.

As mentioned in [Basic Concepts](/documentation/basic-concept.html), a
subscriber may have more than one delivery point for a service, so the server
side needs some way to authenticate the subscriber's identity before adding
one.

## Sending Push Notifications to a Subscriber

Once a service has at least one provider and at least one subscriber,
uniqush-push can push on that service's behalf. The server provides the
service name, subscriber id, and data; uniqush-push pushes to every active
delivery point of that subscriber.

## Removing a Push Service Provider and Unsubscribing

Removing a provider and unsubscribing a device are the reverse of adding one
and subscribing — see [Using Uniqush](/documentation/usage.html) for the
exact API.

## Summary

In general, uniqush-push provides:

- Add / remove a push service provider to/from a service.
- Add / remove a subscription to/from a subscriber.
- Send a push notification.
- Get a subscriber's subscriptions.
- Get the configuration for all services.
- Check the database for inconsistencies.

******

## Related Topics

- [Introduction](/documentation/intro.html)
- [Installing Uniqush and its Dependencies](/documentation/install.html)
- [Basic Concept](/documentation/basic-concept.html)
