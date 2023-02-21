---
title: "Chat systems explained"
---

## Facebook Messenger

```
+-------------+                    +-------------+           +-------------+
|  Alice's    | Unencrypted msg    |  Facebook   |           |   Bob's     |
|  client     | -----------------> |  servers    | --------> |   client    |
| (untrusted) |                    | (untrusted*)|           | (untrusted) |
+-------------+                    +-------------+           +-------------+
                                          |
                                          | Duplicated
                                          | message
                                          |
                                          v
                                    +-------------+
                                    |   Eve's     |
                                    |  server     |
                                    | (NSA/GCHQ   |
                                    |  probably)  |
                                    +-------------+


* Facebook uses this data for advertising and so on, as well as giving it to 3rd parties.
```

## Whatsapp (and Telegram)

```
+--------------+                    +-------------+           +-------------+
|  Alice's     | E2E Encrypted msg  |  Whatsapp   |           |   Bob's     |
|  client      | -----------------> |  servers    | --------> |   client    |
| (untrusted*) | (but backdoored)   | (untrusted) |           | (untrusted) |
+--------------+    (probably)      +-------------+           +-------------+
                                          |
                                          | Duplicated
                                          | message
                                          | (with broken
                                          |  encryption)
                                          | (probably)
                                          v
                                    +-------------+
                                    |   Eve's     |
                                    |  server     |
                                    | (NSA/GCHQ   |
                                    |  probably)  |
                                    +-------------+

* It is very plausible that the Whatsapp client's encryption is backdoored, intentionally or not. How would we know, when we can't see the code? Maybe it isn't: many security experts don't think it is. But why take the risk? Regardless, we know that Facebook uses Whatsapp metadata for tracking and advertising. We still shouldn't use it.
```


## Signal

```
+-------------+                    +--------------+           +-------------+
|  Alice's    | E2E Encrypted msg  |   Signal     |           |   Bob's     |
|  client     | -----------------> |   servers    | --------> |   client    |
| (trusted)   |                    | (untrusted*) |           |  (trusted)  |
+-------------+                    +--------------+           +-------------+
                                          |
                                          | Metadata only
                                          | (i.e. "Alice
                                          | just sent Bob
                                          | a message")
                                          | (probably)
                                          v
                                    +-------------+
                                    |   Eve's     |
                                    |  server     |
                                    | (NSA/GCHQ   |
                                    |  probably)  |
                                    +-------------+

* Because Alice and Bob cannot verify the code that is running. There is a significant possibility that Signal is an NSA metadata honeypot.
```

## Matrix (ideally)

```
+-------------+                    +--------------+           +-------------+           +-------------+
|   Alice's   | E2E Encrypted msg  |   Alice's    |           |   Bob's     |           |   Bob's     |
|   client    | -----------------> |   server     | --------> |   server    | --------> |   client    |
|  (trusted)  |                    |  (trusted*)  |           |  (trusted)  |           |  (trusted)  |
+-------------+                    +--------------+           +-------------+           +-------------+

                                            +-------------+
                                            | The NSA is  |
                                            | is sad/angy |
                                            |             |
                                            |    \  /     |
                                            |   x    x    |
                                            |    .--.     |
                                            |   /____\    |
                                            |             |
                                            +-------------+

* Because Alice has good reasons to trust her server operator.
```

## Matrix (current situation, with most people on matrix.org)

```
+-------------+                    +--------------+           +---------------+           +-------------+
|   Tim's     | E2E Encrypted msg  | Tim's server |           |   Alice's     |           |   Alice's   |
|   client    | -----------------> |  (trusted*)  | --------> |   server      | --------> |   client    |
|  (trusted)  |                    |              |           | (untrusted**) |           |  (trusted)  |
+-------------+                    +--------------+           +---------------+           +-------------+
                                                                     |
                                                                     | Metadata only
                                                                     | (i.e. "Tim
                                                                     | just sent Alice
                                                                     | a message")
                                                                     | (probably)
                                                                     v
                                                               +-------------+
                                                               |   Eve's     |
                                                               |  server     |
                                                               | (NSA/GCHQ   |
                                                               |  probably)  |
                                                               +-------------+

* Because Tim is running his own server, and can verify its code. But is Tim's server backdoored in a way he can't detect? Who knows.

** Because neither Tim nor Alice can verify the code that is running on the matrix.org server.
```

Despite this currently being functionally identical to the Signal threat model,
there is potential for the whole chain to be trusted in the future. This might
be achieved by the SRCF running a matrix server (and people trusting the SRCF
by proxy since they (hopefully) trust Tim).

In addition, it is less likely that the matrix.org server is an NSA honeypot
than that the Signal server is an NSA honeypot.
