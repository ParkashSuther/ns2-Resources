#  www.jgyan.com
#  BlackHole Attack
#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     25                         ;# number of mobilenodes
set val(rp)     AODV                      ;# routing protocol
set val(x)      1186                      ;# X dimension of topography
set val(y)      584                      ;# Y dimension of topography
set val(stop)   100.0                         ;# time of simulation end
set val(t1)     0.0                         ;
set val(t2)     0.0                          ;  

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open program9-1.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open program9-1.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)

set chan [new $val(chan)];#Create wireless channel

#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON


#===================================
#        Nodes Definition        
#===================================
#Create 25 nodes

for {set i 0} {$i < 25} {incr i} {
	set n($i) [$ns node]
}

for {set i 0} {$i < 25} {incr i} {
	set XX [expr rand()*750]
	set YY [expr rand()*750]
	$n($i) set X_ $XX
	$n($i) set Y_ $YY 
	$ns initial_node_pos $n($i) 30
}

$n0 color Red
$n1 color red
$n7 color red
$n9 color blue
$n13 color red
$n17 color blue
$n20 color green
$n21 color green

$n0 start

$ns at 1.8 "$n1 color red"
$ns at 0.0 "$n7 color red"
$ns at 0.0 "$n9 color blue"
$ns at 0.0 "$n13 color red"
$ns at 0.0 "$n17 color blue"
$ns at 0.0 "$n20 color green"
$ns at 0.0 "$n21 color green"


$ns at 1.8 "[$n1 set ragent_] blackhole"
$ns at 0.0 "[$n7 set ragent_] blackhole"
$ns at 0.0 "[$n13 set ragent_] blackhole"

$ns at 0 " $n21 setdest 150 150 40 "
$ns at 0 " $n20 setdest 150 150 40 "

#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n21 $udp0
$udp0 set packetSize_ 1500

set null1 [new Agent/Null]
$ns attach-agent $n17 $null1

$ns connect $udp0 $null1

#Setup a CBR Application over UDP connection
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 0.1Mb
$cbr0 set random_ null

$ns at 1.0 "$cbr0 start"
$ns at 20.0 "$cbr0 stop"

#Setup a UDP connection
set udp1 [new Agent/UDP]
$ns attach-agent $n20 $udp1
$udp1 set packetSize_ 1500

set null2 [new Agent/Null]
$ns attach-agent $n9 $null2

$ns connect $udp1 $null1

#Setup a CBR Application over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 0.1Mb
$cbr1 set random_ null

$ns at 20.0 "$cbr1 start"
$ns at 40.0 "$cbr1 stop"

#Setup a UDP connection
set udp3 [new Agent/UDP]
$ns attach-agent $n11 $udp3
$udp3 set packetSize_ 1500

set null3 [new Agent/Null]
$ns attach-agent $n18 $null3

$ns connect $udp3 $null1

#Setup a CBR Application over UDP connection
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp3
$cbr2 set packetSize_ 1000
$cbr2 set rate_ 0.1Mb
$cbr2 set random_ null

$ns at 40.0 "$cbr2 start"
$ns at 60.0 "$cbr2 stop"

set udp4 [new Agent/UDP]
$ns attach-agent $n17 $udp4
$udp4 set packetSize_ 1500

set null4 [new Agent/Null]
$ns attach-agent $n18 $null4

$ns connect $udp4 $null4

#Setup a CBR Application over UDP connection
set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $udp4
$cbr4 set packetSize_ 1000
$cbr4 set rate_ 0.1Mb
$cbr4 set random_ null

$ns at 60.0 "$cbr4 start"
$ns at 100.0 "$cbr4 stop"

#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam program9-1.nam &
    exit 0
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run

