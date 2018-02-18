
# -------- Topology --------

# n0     n1      n3      n4      
#  |      |       |       |      
#  ------------------------
#                         |
#                         n2
#                         |
#                         n6
#                         |
# -------------------------
#  |      |       |       |
# n5     n7      n8      n9


# Step-1: Object of class Simulator
set ns [new Simulator]

# Step-2: Trace File
set f [open program4.tr w]
$ns trace-all $f

# Step-3: NAM File
set nf [open program4.nam w]
$ns namtrace-all $nf

# Step-4: End Procedure
proc finish {} {
	global f nf ns
	$ns flush-trace
	close $f
	close $nf 
	exec nam program4.nam &
	exec awk -f program4.awk program4.tr &
	exit 0
}

# Step-5: Creating Topology
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

$n0 label "US1"
$n3 label "TS1"
$n7 label "UD1"
$n8 label "TD1"

$ns color 1 "Blue"
$ns color 2 "Red"

$ns make-lan "$n0 $n1 $n2 $n3 $n4" 1Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n5 $n6 $n7 $n8 $n9" 1Mb 10ms LL Queue/DropTail Mac/802_3
$ns duplex-link $n2 $n6 1Mb 30ms DropTail

Mac/802_3 set datarate_ 10Mb

# Step-6: Configuring Source and Destination TCP/UDP Agent with Application

# Step-6.11: UDP Agent for Source
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
$udp0 set class_ 2

# Step-6.12: UDP Applicaion for source
set cbr0 [new Application/Traffic/CBR] 
$cbr0 attach-agent $udp0

$cbr0 set packetSize_ 500
$cbr0 set Interval_ 0.05

# Step-6.13: UDP Agent for Destination
set null0 [new Agent/Null]
$ns attach-agent $n7 $null0

# Step-6.14: Connecting UDP Source and Destination Agents
$ns connect $udp0 $null0

# Step-6.21: TCP Agent for Source
set tcp0 [new Agent/TCP]
$ns attach-agent $n3 $tcp0
$tcp0 set class_ 1

# Step-6.22: TCP Applicaion for source
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ftp0 set packetSize_ 500

# Step-6.23: TCP Agent for Destination
set sink0 [new Agent/TCPSink]
$ns attach-agent $n8 $sink0

# Step-6.24: Connecting TCP Source and Destination Agents
$ns connect $tcp0 $sink0

# Step-6.3: Configuring Error Model
set err [new ErrorModel]
$ns lossmodel $err $n2 $n6

$err set rate_ 0.1

# Step-7: Setting Time for simulation
$ns at 1.0 "$cbr0 start"
$ns at 9.0 "$cbr0 stop"

$ns at 1.0 "$ftp0 start"
$ns at 9.0 "$ftp0 stop"

$ns at 10.0 "finish"

# Step-8: Running the simulation
$ns run
