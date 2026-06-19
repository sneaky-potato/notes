---
date: 
title: Lua in Kernel
---

> Controlling low level systems with a high level langauge

I worked on the following items throughout summer as part of [GSoC with LabLua](https://summerofcode.withgoogle.com/programs/2026/projects/IHF0HPaF):
- Lua eBPF abstraction layer: Scheduler binding [[luasched]]

List of miscellaneous PRs I created while starting out with the project
- [#341](https://github.com/luainkernel/lunatik/pull/341): Added an LLDP example using AF_PACKET to demonstrate low-level packet I/O
- [#360](https://github.com/luainkernel/lunatik/pull/360), [#364](https://github.com/luainkernel/lunatik/pull/364): Standardized raw socket patterns for safer reuse
- [#378](https://github.com/luainkernel/lunatik/pull/378): Enforced explicit (protocol, ifindex) pairing in raw_socket:bind() for API correctness
- [#410](https://github.com/luainkernel/lunatik/pull/410): Eliminated index-based method dispatch by eagerly wrapping class methods at initialization, reducing allocations in hot paths
- [#434](https://github.com/luainkernel/lunatik/pull/434): Added support for non-shared objects within shared classes, bypassing unnecessary object locking

