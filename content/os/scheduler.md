# Scheduler

## Runqueue
It is the rendezvous of all data structures involved in the scheduler. Reference: [linux/kernel/sched/sched.h](https://github.com/torvalds/linux/blob/v5.5/kernel/sched/sched.h#L847-L1002)
```c
struct rq {
    unsigned int       nr_running; /* number of tasks in the rq */
    struct cfs_rq      cfs;        /* completely fair scheduler specific rq  */
    struct rt_rq       rt;         /* real time specific rq  */
    struct dl_rq       dl;         /* deadline specific rq  */
    /* ... */
    struct task_struct *curr;      /* task currently executing in the rq */
    struct task_struct *idle;      /* task used when nothing else is to run on this rq */
    /* ... */
    u64                clock;      /* time when the rq was last updated */
};
```

> [!TIP] Each CPU has its own run queue
> A ready thread can belong to a single run queue at
a time, since it is impossible that multiple CPUs process the same thread
simultaneously.

## Scheduler class

This is the scheduler class defined inside linux source code [linux/kernel/sched/sched.h](https://github.com/torvalds/linux/blob/v5.5/kernel/sched/sched.h#L1702-L1760)
```c
struct sched_class {
	const struct sched_class *next;
    /* called when new task need to be added to sched_class runqueue */
	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
    /* called when a new task must be chosen to run on the CPU */
	struct task_struct *(*pick_next_task)(struct rq *rq);
    /* called when a task must be put back into the sched_class runqueue*/
	void (*put_prev_task)(struct rq *rq, struct task_struct *p);
    /* called as part of timer interrupt request handling */
	void (*task_tick)(struct rq *rq, struct task_struct *p, int queued);
    /* ... */
};
```

Each scheduling algorithm gets an instance of `struct sched_class` and connects the function pointers with their corresponding implementations.
The `rt_sched_class` implements real-time (RT) scheduler.

This is how a scheduler is initialized (example taken from [linux/kernel/sched/rt.c](https://github.com/torvalds/linux/blob/v5.5/kernel/sched/rt.c#L2357-L2391)):
```c
const struct sched_class rt_sched_class = {
    .next         = &fair_sched_class,
    .enqueue_task = enqueue_task_rt,
    .dequeue_task = dequeue_task_rt,
    .yield_task   = yield_task_rt,

    .check_preempt_curr = check_preempt_curr_rt,

    .pick_next_task = pick_next_task_rt,
    .put_prev_task  = put_prev_task_rt,
    .set_next_task  = set_next_task_rt,

    /* ... */

    .task_tick = task_tick_rt,
    /* ... */
};
```

Similarly, the completely fair scheduler (CFS) is implemented by the `fair_sched_class`.
```c
const struct sched_class fair_sched_class = {
    .next = &idle_sched_class,
    /* ... */
    .pick_next_task = pick_next_task_fair,
    .put_prev_task  = put_prev_task_fair,
    /* ... */
    .task_tick = task_tick_fair,
    /* ... */
};
```

Next up, eBPF allows us to script the kernel and add custom scheduler via [[sched-ext]]

