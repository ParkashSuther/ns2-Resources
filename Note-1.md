## Relation among Bandwidth, Propogation Delay, Packet Size and Interval in ns2

**Propogation Delay**

> Represents the time distance between 2-nodes or length of a link between 2-nodes.

**Bandwidth and Packet size**
```
Transmission Time = Packet Size / Bandwidth
```

> Transmission time (s) represents length of a packet in a propogation delay (s) length of a link between 2-nodes.

**Interval**

> Represents the time (s) gap between adjacent packets of transmission time (s) length in a propogation delay (s) length of a link between 2-nodes.

**Case 1: (Bandwidth = 10 Mbps, Propogation Delay = 4ms, Packet Size = 500B and Interval = 4ms)**

>Transmission Time = 500\*8/10000000 = 4ms indicates at any time a link between 2-nodes can occupy maximum of 10 packets, which further depends on interval. In the above case |propogation delay - interval| = 0, indicates time (s) gap between two adjacent packets is 0. i.e in case 1 link between 2-nodes occupy 10 packets.


