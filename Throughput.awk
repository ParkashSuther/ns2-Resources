BEGIN {
  recv = 0
  t1=0
  t2=0
  recv_in_delta = 0
  time = 0
}

{
  if ( t2 == 0 ) {
     t2 = delta
  }

  # Get information when Trace line format: normal
  if ($2 != "-t") {
    event = $1
    time = $2
    if (event == "+" || event == "-") node_id = $3
    if (event == "r" || event == "d") node_id = $4
    flow_id = $8
    pkt_id = $12
    pkt_size = $6
  }
  # Get information Trace line format: new
  if ($2 == "-t") {
    event = $1
    time = $3
    node_id = $5
    flow_id = $39
    pkt_id = $41
    pkt_size = $37
  }

  while ( time > t2 ) {
     printf("%5g  %10g\n", t1, (8*recv_in_delta)/(1000000*delta) )
     recv_in_delta = 0
     t1 = t2
     t2 += delta
  }

  # event: "r" is crucial for throughput
  # printf("recv[%d] = %d --> tot: %d\n", node_id, pkt_size-hdr_size, pkt_size)

  # Calculate total received packets' size
  if (flow_id == flow && event == "r" && node_id == dst) {
    if (flow_t != "sctp") {

      recv += pkt_size - hdr_size
      recv_in_delta += pkt_size - hdr_size

      #printf("recv[%d] = %d --> tot: %d\n",node_id,pkt_size-hdr_size,recv)
    } else {
      # Rip off SCTP header, whose size depends
      # on the number of chunks in each packet
      if (pkt_size == 40) pkt_size = 0
      if (pkt_size == 448) pkt_size = 400
      if (pkt_size == 864) pkt_size = 800
      if (pkt_size == 1280) pkt_size = 1200

      recv += pkt_size
      recv_in_delta += pkt_size
      #printf("recv[%d] = %d --> tot: %d\n",node_id,pkt_size,recv)
    }
  }

  simtime = time
}
END {
  printf("%5g  %10g\n", t1, (8*recv_in_delta)/(1000000*delta) )
  printf("\n\n");
  printf("Simulation time = %5g, t1 = %g\n", simtime, t1)
  printf("Avg Throughput: %10g %10s %10g\n",flow,flow_t,(recv/t1)*(8/1000000))
}
