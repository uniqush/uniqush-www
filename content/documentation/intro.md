---
title: Introduction
aliases:
  - /wiki/UniqushStory/index.html
---

# A Story of an App Development

This document helps you understand the basic idea of **uniqush-push** by
telling an imaginary story of a group of app developers.

- Once upon a time, there was a group of developers building a weather report
  app for mobile devices. They were from the open source community and
  preferred open platforms, so Android was their first choice.
- The idea of their app was simple: send a weather report from their server to
  their app every day.

![android-and-android-rain](/documentation/img/intro/android-and-android-rain.png)

- On Android, sending a notification to an app is easy: Google provides a
  cloud service — first GCM, now Firebase Cloud Messaging (FCM) — to help
  developers send data from a server to an app.
- Developers push data to their apps by sending an HTTP request to that cloud.
- Empowered by FCM, the developers were happy: they didn't need to think about
  the system the app ran on. Everything they had to do was gather the weather
  data, connect to FCM over HTTP, and send it. Clean, easy, and little code.

![gcm-demo](/documentation/img/intro/gcm-demo.png)

- After several months, quite a few Android users were using the app. Our
  developers, encouraged by this success, decided to expand to other
  platforms.
- A lot of users carried phones from a certain fruit company — too popular to
  ignore.

![apple-and-iphone](/documentation/img/intro/apple-and-iphone.png)

- The developers found that this company also provides a cloud service: the
  Apple Push Notification service, or APNs. Again, they'd connect to APNs and
  push data to it, and it would deliver the data to the device.

![apns-demo](/documentation/img/intro/apns-demo.png)

- But APNs speaks its own protocol, with its own authentication. The server
  side had to change to support both APNs and FCM.

![apns-gcm](/documentation/img/intro/apns-gcm.png)

- After adding APNs, the project manager wanted to support Kindle tablets too
  — another cloud, specific to Amazon devices.

- The developers grew impatient. Every new platform meant learning another
  cloud's protocol, when all they wanted to do was decide *what* to push, not
  figure out *how*.

![noclouds](/documentation/img/intro/noclouds.png)

- Finally, our developers found **uniqush-push**, which solved the problem.
- They no longer needed to know which cloud a device used. They just push a
  message, and **uniqush-push** speaks to each cloud's own protocol on their
  behalf.
- Running uniqush-push on their server, they could send one HTTP request and
  reach any platform it supports.

![uniqush-demo](/documentation/img/intro/uniqush-demo.png)

******

## Related Topics

- [Installing Uniqush and its Dependencies](/documentation/install.html)
- [Basic Concepts](/documentation/basic-concept.html)
