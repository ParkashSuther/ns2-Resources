## TCP FTP Traffic

**Step 1: Initilizing TCP agent for sender**

``set tcp0 [new Agent/TCP]``

**Step 2: Attching TCP agent to source**

``$ns attach-agent $n0 $tcp0``

**Step 3: Initilizing TCP application FTP**

``set ftp0 [new Application/FTP]``

**Step 4: Attaching TCP application FTP to source**

``$ftp0 attach-agent $tcp0``

**Step 5: Initilizing TCP agent for receiver**

``set sink3 [new Agent/TCPSink]``

**Step 6: Attaching TCP agent to receiver**

``$ns attach-agent $n3 $sink3``

**Step 7: Connecting TCP source to TCP receiver**

``$ns connect $tcp0 $sink3``

**Step 8: Setting TCP application FTP properties** (optional)
```
$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.001
```

## UDP CBR Traffic

**Step 1: Initilize UDP agent for sender**

``set udp1 [new Agent/UDP]``

**Step 2: Attach UDP agent to source**

``$ns attach-agent $n1 $udp1``

**Step 3: Initilize UDP application CBR**

``set cbr1 [new Application/Traffic/CBR]``

**Step 4: Attaching UDP application CBR to source**

``$cbr1 attach-agent $udp1``

**Step 5: Initilizing UDP agent for receiver**

``set null3 [new Agent/Null]``

**Step 6: Attaching UDP agent to receiver**

``$ns attach-agent $n3 $null3``

**Step 7: Connecting source application with receiver**

``$ns connect $udp1 $null3``

**Step 8: Setting UDP application CBR properties** (optional)
```
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.001
```

## TCP Telnet Traffic

**Step 1: Initilizing TCP agent for sender**

``set tcp1 [new Agent/TCP]``

**Step 2: Attaching TCP agent to sender**

``$ns attach-agent $n1 $tcp1``

**Step 3: Initilizing TCP application Telnet**

``set telnet1 [new Application/Telnet]``

**Step 4: Attaching TCP application Telnet to source**

``$telnet1 attach-agent $tcp1``

**Step 5: Initilizing TCP agent for receiver**

``set sink5 [new Agent/TCPSink]``

**Step 6: Attaching TCP agent to receiver**

``$ns attach-agent $n5 $sink5``

**Step 7: Connecting TCP source to TCP receiver**

``$ns connect $tcp1 $sink5``

**Step 8: Setting TCP application Telnet properties** (optional)
```
$telnet1 set packetSize_ 1000Mb
$telnet1 set interval_ 0.00001
```

## Ping Traffic

**Step 1: Initializing Ping agent for sender**

``set ping0 [new Agent/Ping]``

**Step 2: Attaching Ping agent to sender**

``$ns attach-agent $n0 $ping0``

**Step 3: Initializing Ping agent for receiver**

``set ping0 [new Agent/Ping]``

**Step 4: Attaching Ping agent to receiver**

``$ns attach-agent $n0 $ping0``

**Step 5: Setiing Ping properties** (optional)
```
$ping0 set packetSize_ 50000
$ping0 set interval_ 0.0001
```
