# --------- Topology 1 ----------

#        n0 ---- n1 ---- n2
#     (Source)      (Destination)


# Step-1: Object of class Simulator
set ns [new Simulator]

# Step-2: Trace File
set tf [open program2.tr w] 
$ns trace-all $tf

# Step-3: NAM File
set nf [open program2.nam w]
$ns namtrace-all $nf

# Step-4: End Procedure
proc finish { } {     
	global ns nf tf
	$ns flush-trace     
	close $nf
	close $tf
	exec nam program2.nam & 
	exit 0
}

# Step-5: Creating Topology
set n0 [$ns node] 
set n1 [$ns node]
set n2 [$ns node]

$n0 label "US1"
$n2 label "UD1"

$ns color 1 "Blue"

$ns duplex-link $n0 $n1 10Mb 1ms DropTail 
$ns duplex-link $n1 $n2 10Mb 1ms DropTail
$ns queue-limit $n0 $n1 10

# Step-6: Configuring Source and Destination TCP/UDP Agent with Application

# Step-6.11: UDP Agent for Source
set tcp0 [new Agent/TCP] 
$ns attach-agent $n0 $tcp0
$tcp0 set class_ 1

# Step-6.12: UDP Applicaion for source
set ftp0 [new Application/FTP] 
$ftp0 attach-agent $tcp0

# Step-6.13: UDP Agent for Destination
set sink0 [new Agent/TCPSink] 
$ns attach-agent $n2 $sink0

# Step-6.14: Connecting UDP Source and Destination Agents
$ns connect $tcp0 $sink0

$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.01

# Step-7: Setting Time for simulation
$ns at 0.1 "$ftp0 start"
$ns at 1.0 "finish"

# Step-8: Running the simulation
$ns run

