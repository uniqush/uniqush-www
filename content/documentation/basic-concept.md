---
title: Basic Concept
aliases:
  - /wiki/UniqushBasicConcepts/index.html
---

This document explains uniqush-push's terminology. Understanding these terms
is useful before reading anything else.

## Sending Notifications Through Clouds

- Many clouds are available for pushing data from a server to mobile devices.

![manyclouds](/documentation/img/basic-concept/manyclouds.png)

- Each cloud is dedicated to its own platform: FCM for Android, APNs for iOS,
  and so on.

![clouds2platforms](/documentation/img/basic-concept/clouds2platforms.png)

- If an app server wants to send data to its end user, it first sends the
  data to the corresponding cloud.

![server2cloud](/documentation/img/basic-concept/server2cloud.png)

- Then the cloud delivers the data to the app running on the device.

![cloud2device](/documentation/img/basic-concept/cloud2device.png)

- To support multiple platforms, a server has to speak to different clouds
  through different protocols.

![serverandseveralclouds](/documentation/img/basic-concept/serverandseveralclouds.png)

******

## Uniqush Gets Involved

- By running uniqush-push, a server can reach multiple clouds through
  **one and only one** protocol. The server sends data to the uniqush-push
  process over HTTP; uniqush-push sends it on to each cloud using that
  cloud's own protocol. We call each cloud a **Push Service Provider**.
- **Definition**: *Push Service Provider* — an entity that can push data to a
  device. uniqush-push handles the protocol for each one, hiding the details
  from the server.

![uniqushinvolved](/documentation/img/basic-concept/uniqushinvolved.png)

- The server only needs to care about **who** subscribes to **which**
  service. For example, a server may provide a weather report service called
  *Local Weather*. John installs the Local Weather app and **subscribes** to
  the service.
- **Definition**: *Service* — an entity that generates data to be sent to a
  remote device. A service is the source of information.
- **Definition**: *Subscriber* — an entity that consumes the information a
  service generates. A subscriber is the sink of information.

![johnsubweather](/documentation/img/basic-concept/johnsubweather.png)

- To send John a weather report, the server tells uniqush-push three things:
  the **Service** (Local Weather), the **Subscriber** (John), and the
  **Data** (rain, cloudy, etc.).

![john-weather-data](/documentation/img/basic-concept/john-weather-data.png)

- John has several devices, all subscribed to Local Weather. We call each
  device a **Delivery Point**. A subscriber may have several delivery points.
- **Definition**: *Delivery Point* — an entity that receives data from one or
  more services. It has a subscriber as its owner; one subscriber may have
  more than one delivery point.
- The server tells uniqush-push three things: **who** (the subscriber),
  **where** (the service), and **what** (the data). uniqush-push sends the
  data to every delivery point of that subscriber.

![john-received-msgs](/documentation/img/basic-concept/john-received-msgs.png)

******

## Review

### Push Service Provider
A push service provider can push data to a device. uniqush-push handles the
protocol for each one, hiding the details from the server.

Examples: FCM sends notifications to Android devices; APNs to iOS devices;
ADM to Kindle tablets; UnifiedPush and Web Push to de-Googled Android, Linux
desktops and browsers.

### Service
A service generates data to be sent to apps on a remote device — the source
of information. One server may provide more than one service.

Examples: a weather service; a news service.

### Subscriber
A subscriber consumes the information a service generates — the sink of
information. Usually a real person.

Example: someone who installed a news app on their phone.

### Delivery Point
A delivery point receives data from one or more services, and has a
subscriber as its owner. One subscriber may have more than one delivery
point.

Examples: an Android device; an iOS device.

******

## Related Topics

- [Introduction](/documentation/intro.html)
- [Installing Uniqush and its Dependencies](/documentation/install.html)
