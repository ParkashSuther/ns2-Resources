if {$argc != 1} {
	error "Command: ns <program6.tcl> <Number_of_Nodes>"
	exit 0
}

#Define the simulation options
set val(chan)       Channel/WirelessChannel 
set val(prop)       Propagation/TwoRayGround 
set val(ant)        Antenna/OmniAntenna 
set val(ll)         LL 
set val(ifq)        Queue/DropTail/PriQueue 
set val(ifqlen)     50 
set val(netif)      Phy/WirelessPhy 
set val(mac)        Mac/802_11 
set val(rp)         AODV
set val(nn)         [lindex $argv 0]
set opt(x)  	    750
set opt(y)          750
set val(stop)       100

# Configure the Wireless Nodes
$ns node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-channelType $val(chan) \
		-propType $val(prop) \
		-antType $val(ant) \
		-ifqLen $val(ifqlen) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace OFF \
        	-movementTrace OFF
        
# Step-1: Object of class Simulator
set ns [new Simulator]

# Step-2: Trace File
set trfd [open program6.tr w]
$ns trace-all $trfd

# Step-3: NAM File
set namfd [open program6.nam w]
$ns namtrace-all-wireless $namfd $opt(x) $opt(y)

set topo [new Topography]
$topo load_flatgrid $opt(x) $opt(y)
set god_ [create-god $val(nn)]

# Step-4: End Procedure
proc stop {} {
	global ns trfd namfd
	close $trfd
	close $namfd
	exec nam program6.nam &
	exec awk -f program6.awk program6.tr &
	exit 0
}

# Step-5: Creating Topology
for {set i 0} {$i < $val(nn)} {incr i} {
	set n($i) [$ns node]
}

for {set i 0} {$i < $val(nn)} {incr i} {
	set XX [expr rand()*750]
	set YY [expr rand()*750]
	$n($i) set X_ $XX
	$n($i) set Y_ $YY 
}

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns initial_node_pos $n($i) 30
}

# Step-6: Configuring Source and Destination TCP/UDP Agent with Application

# Step-6.11: TCP Agent for Source
set tcp1 [new Agent/TCP]
$ns attach-agent $n(1) $tcp1

# Step-6.12: TCP Applicaion for source
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

# Step-6.13: TCP Agent for Destination
set sink1 [new Agent/TCPSink]
$ns attach-agent $n(3) $sink1

# Step-6.14: Connecting TCP Source and Destination Agents
$ns connect $tcp1 $sink1

proc destination {} {
	global ns val n
	set now [$ns now]
	set time 5.0
	for {set i 0} {$i < $val(nn)} {incr i} {
		set XX [expr rand()*750]
		set YY [expr rand()*750]
		$ns at [expr $now + $time] "$n($i) setdest $XX $YY 20.0"
	}
	$ns at [expr $now + $time] "destination"
}

# To reset nodes
for {set i 0} {$i < $val(nn)} {incr i} {
	$ns at $val(stop) "$n($i) reset"
}

# Step-7: Setting Time for simulation
$ns at 0.0 "destination"
$ns at 5.0 "$ftp1 start"
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"

# Step-8: Running the simulation
$ns run


