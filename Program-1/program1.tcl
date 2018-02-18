# --------- Topology 1 ----------

#        n0 ---- n1 ---- n2
#     (Source)      (Destination)


# Step-1: Object of class Simulator
set ns [new Simulator]

# Step-2: Trace File
set tf [open program1.tr w] 
$ns trace-all $tf

# Step-3: NAM File
set nf [open program1.nam w]
$ns namtrace-all $nf

# Step-4: End Procedure
proc finish { } {     
	global ns nf tf
	$ns flush-trace     
	close $nf
	close $tf
	exec nam program1.nam & 
	exit 0
}

# Step-5: Creating Topology
set n0 [$ns node] 
set n1 [$ns node]
set n2 [$ns node]

$n0 label "US1"
$n2 label "UD1"

$ns color 1 "Blue"

$ns duplex-link $n0 $n1 200Mb 10ms DropTail 
$ns duplex-link $n1 $n2 1Mb 1000ms DropTail
$ns queue-limit $n0 $n1 10

# Step-6: Configuring Source and Destination TCP/UDP Agent with Application

# Step-6.11: UDP Agent for Source
set udp0 [new Agent/UDP] 
$ns attach-agent $n0 $udp0
$udp0 set class_ 1

# Step-6.12: UDP Applicaion for source
set cbr0 [new Application/Traffic/CBR] 
$cbr0 set packetSize_ 500 
$cbr0 set interval_ 0.05
$cbr0 attach-agent $udp0

# Step-6.13: UDP Agent for Destination
set null0 [new Agent/Null] 
$ns attach-agent $n2 $null0

# Step-6.14: Connecting UDP Source and Destination Agents
$ns connect $udp0 $null0

# Step-7: Setting Time for simulation
$ns at 0.1 "$cbr0 start"
$ns at 1.0 "finish"

# Step-8: Running the simulation
$ns run

