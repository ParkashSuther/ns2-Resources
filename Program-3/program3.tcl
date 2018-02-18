
# ---------- Topology ---------

# (Source-1)   (Destination-1)
#     n0             n4
#       \           /
#        \         /
#        n2 ----- n3
#        /         \
#       /           \
#     n1             n5
# (Source-2)   (Destination-2)

# Step-1: Object of class Simulator
set ns [new Simulator]

# Step-2: Trace File
set f [open program3.tr w]
$ns trace-all $f

# Step-3: NAM File
set nf [open program3.nam w]
$ns namtrace-all $nf

# Step-4: End Procedure
proc finish {} {
	global ns f nf
	$ns flush-trace
	close $f
	close $nf
	exec nam program3.nam &
	exit 0
}

# Step-5: Creating Topology
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n0 label "PS1"
$n1 label "PS2"
$n2 label "R1"
$n3 label "R2"
$n4 label "PD1"
$n5 label "PD2"

$ns color 1 red
$ns color 2 blue
$ns color 3 green
$ns color 4 orange

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 30ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n3 $n5 1Mb 10ms DropTail

# Step-6: Configuring Source and Destination TCP/UDP Agent with Application

# Step-6.11: Ping Agent for Source
set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0
$ping0 set class_ 1

# Step-6.12: Ping Agent for Destination
set ping4 [new Agent/Ping]
$ns attach-agent $n4 $ping4
$ping4 set class_ 4

# Step-6.13: Connecting Ping Source and Destination Agents
$ns connect $ping0 $ping4

# Step-6.21: Ping Agent for Source
set ping1 [new Agent/Ping]
$ns attach-agent $n1 $ping1
$ping1 set class_ 2

# Step-6.22: Ping Agent for Destination
set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5
$ping5 set class_ 5

# Step-6.13: Connecting Ping Source and Destination Agents
$ns connect $ping1 $ping5

proc sendPingPacket {} {
	global ns ping0 ping1
	set intervalTime 0.001
	set now [$ns now]
	$ns at [expr $now + $intervalTime] "$ping0 send"
	$ns at [expr $now + $intervalTime] "$ping1 send"
	$ns at [expr $now + $intervalTime] "sendPingPacket"
}

Agent/Ping instproc recv {from rtt} {
	global seq
	$self instvar node_
	puts "The node [$node_ id] received an ACK from the node $from with RTT $rtt ms"
}

# Step-7: Setting Time for simulation
$ns at 0.01 "sendPingPacket"
$ns at 10.0 "finish"

# Step-8: Running the simulation
$ns run 
