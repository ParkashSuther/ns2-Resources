**Initilizing Traffic colour** (red, blue, green, orange)
```
$ns color 1 "red"
$ns color 2 "blue"
```
**Assigning Traffic colour** (udp0 and udp1 are UDP agent (source))
```
$udp0 set class_ 1
$udp1 set class_ 2
```

**Assigning labels to nodes**
```
$n0 label "Source/udp0"
$n1 label "Source/udp1"
$n2 label "Router"
$n3 label "Destination/Null"
```

**Link Positioning for NAM**
```
$ns duplex-link-op  $n0 $n2 orient right-down
$ns duplex-link-op  $n1 $n2 orient right-up
$ns duplex-link-op  $n2 $n3 orient right
$ns duplex-link-op  $n3 $n4 orient right-up
$ns duplex-link-op  $n3 $n5 orient right-down
```

**Link failure**
```
$ns rtmodel-at 0.9 down $n2 $n6
$ns rtmodel-at 1.5 up $n2 $n6
```

**Creating Ethernet LAN**
```
$ns make-lan “ $n0 $n1 $n2 $n3 ” 100Mb 10ms LL Queue/DropTail Mac/802_3
```

## Error model

**Initializing error model**

``set err [new ErrorModel]``

**Connecting between two nodes**

``$ns lossmodel $err $n3 $n6``

**Setting property (optional)**

``$err set rate_ 0.2``

## Congestion Window

**File for recording congestion window data**

``set file1 [open file1.tr w]``

**Attaching file to TCP agent**

``$tcp0 attach $file1``

**Initializing to trace congestion window**

``$tcp0 trace cwnd_``

**Setting congestion window size (optional)**

``$tcp0 set maxcwnd_ 10``
