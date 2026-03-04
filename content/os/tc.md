# Traffic Control

> Scheduling but for packets in Linux kernel

## What is visible

Reassembled packets are visible at this stage. Linear portions of network packets can be
inspected here. We have access to skb (socket buffer) at this level. Examples include:
- Ethernet header
- IP header
- TCP/UDP header
- IP ToS/DSCP bits
- Inspect ports, flags, etc.

It does NOT see:
- Reassembled TCP stream
- Provide full application-layer view

So for instance, parsing HTTP headers reliably at TC layer is not possible.

Read more [here](https://www.lartc.org/lartc.html#LARTC.QDISC.FILTERS)

TC gets access to [struct \_\_sk_buff](https://elixir.bootlin.com/linux/v6.19.3/source/include/uapi/linux/bpf.h#L6309) 
because at this stage kernel allocates `sk_buff` for the packet.
This struct is not visible at XDP, so there are a few things which we can leverage at TC:
- `tc_index`
- `tc_classid`
- `struct bpf_sock* sk`
## Uses

1. ingress: policing, we don't have control over the remote sending the packets, as soon as we inspect it, we have used our bandwidth.
So we cannot shape the ingress traffic but we can drop packets based on policy

2. egress: shaping, we can control the bandwidth to be used for sending outbound packets here, hence we can shape it

Primarily used for modifying scheduler settings but for packets, think of
simulating low bandwidth to see how your system performs.
As an example, only allowing 100MB/s on a network to test your applications.

Classic TC u32 filter can match TCP source port and apply shaping
```shell
tc filter add dev eth1 parent 1:0 protocol ip prio 1 \
   u32 match ip protocol 6 0xff \
   match ip sport 80 0xffff \
   flowid 1:10
```

And eBPF TC filters can match anything in the linear portion of the packet.

Good examples on [Traffic Shaping](https://oneuptime.com/blog/post/2026-01-25-traffic-shaping/view)

Another use is direct action by eBPF programs, basically attach a eBPF program to TC and set the classid of the packets
dynamically, refer to [this commit](https://github.com/torvalds/linux/commit/045efa82ff563cd4e656ca1c2e354fa5bf6bbda4).

So we could shape packets by sending them to defined classes (for instance, setup qdiscs involving HTB).

## What can TC do today?

1. Queueing and Scheduling
- HTB (Hierarchical Token Bucket)
- FQ-CoDel: Fair queuing with active queue management to reduce bufferbloat.
- TBF: rate limiting
- netem: delay, jitter, packet loss, duplication, reordering

2. Declarative Classification
- u32 classifier: Traditional bitmask-based matching on packet headers like protocol, src/dst IP, ports, TOS/DSCP
- example: shape HTTP traffic (port 80/443) differently from SSH (port 22)
- tc flower (flow classifier): rich matching (L2–L4 fields)
- VLAN, MPLS, tunnels, hardware offload to NIC

3. eBPF-based TC Programs
- Two modes
    - Classifier mode -> return classid
    - Direct-action mode -> return `TC_ACT_*`
- Arbitrary packet parsing within linear skb region
- Stateful logic via BPF maps
- Dynamic class assignment

## Components

| traditional element | Linux component |
| --- | --- |
| shaping | class  |
| scheduling | qdisc, can be simple such as the FIFO or complex, containing classes and other qdiscs, such as HTB |
| classifying | filter, performs the classification through the agency of a classifier object. Linux classifiers cannot exist outside of a filter |
| policing | policer exists only as part of a filter |
| dropping | to drop traffic requires a filter with a policer which uses "drop" as an action |

Read more on components: [Traffic-Control-HOWTO](https://tldp.org/HOWTO/Traffic-Control-HOWTO/components.html)

`tc` uses a queue structure to temporarily store and organize packets.
In the tc subsystem, the corresponding data structure and algorithm
control mechanism are abstracted as qdisc (Queueing discipline).

`qdisc` exposes two callback interfaces for enqueuing and dequeuing packets externally,
and internally hides the implementation of queuing algorithms.

In qdisc, we can implement complex tree structures based on filters and
classes. Filters are mounted on qdisc or class to implement specific filtering
logic, and the return value determines whether the packet belongs to a specific
class.

When a packet reaches the top-level qdisc, its enqueue interface is called, and
the mounted filters are executed one by one until a filter matches
successfully. Then the packet is sent to the class pointed to by that filter
and enters the qdisc processing process configured by that class.

The tc framework provides the so-called classifier-action mechanism, that is, when a
packet matches a specific filter, the action mounted by that filter is executed
to process the packet.

The existing tc provides eBPF with the direct-action mode, which allows an eBPF
program loaded as a filter to return values such as `TC_ACT_OK` as tc actions,
instead of just returning a classid like traditional filters and handing over
the packet processing to the action module.

Read more on qdisc [here](https://www.coverfire.com/articles/queueing-in-the-linux-network-stack/)

Several qdiscs are implemented in [/net/sched/sch_*.c](https://elixir.bootlin.com/linux/v6.19.3/source/net/sched)

