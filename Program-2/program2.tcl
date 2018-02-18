
# --------- Topology ----------

#      (TCP Source)
#   		n0
#     		  \
#      		   \
#      			n2 ---- n3 (Destination)
#      		   /
#     		  /
#   		n1
#      (UDP Source)

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
set n3 [$ns node]

$n0 label "TS1"
$n1 label "US2"
$n3 label "D"

$ns color 1 "Blue"
$ns color 2 "Red"

$ns duplex-link $n0 $n2 10Mb 1ms DropTail
$ns duplex-link $n1 $n2 10Mb 1ms DropTail
$ns duplex-link $n2 $n3 10Mb 1ms DropTail

# Step-6: Configuring Source and Destination TCP/UDP Agent with Application

# Step-6.11: TCP Agent for Source
set tcp0 [new Agent/TCP] 
$ns attach-agent $n0 $tcp0
$tcp0 set class_ 1

# Step-6.12: TCP Applicaion for source
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

# Step-6.13: TCP Agent for Destination
set sink0 [new Agent/TCPSink] 
$ns attach-agent $n3 $sink0

# Step-6.14: Connecting TCP Source and Destination Agents
$ns connect $tcp0 $sink0

# Step-6.21: UDP Agent for Source
set udp1 [new Agent/UDP] 
$ns attach-agent $n1 $udp1
$udp1 set class_ 2

# Step-6.22: UDP Applicaion for source
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

# Step-6.23: UDP Agent for Destination
set null0 [new Agent/Null] 
$ns attach-agent $n3 $null0

# Step-6.14: Connecting UDP Source and Destination Agents
$ns connect $udp1 $null0

# Step-7: Setting Time for simulation
$ns at 0.1 "$cbr1 start"
$ns at 0.2 "$ftp0 start"
$ns at 0.5 "finish"

# Step-8: Running the simulation
$ns run
