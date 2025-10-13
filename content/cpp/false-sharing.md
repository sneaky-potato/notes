> When algorithm cannot go any faster, you exploit the hardware

## Multiple threads

Consider this scenario: you have 2 variables (like ints or long long) and you perform a long running task on each of them. Now to speed things up you use 2 threads hoping they would take half the amount of time.

```cpp
long long x = 0;
long long y = 0;

void increment(long long& a) {
    for (int i=0; i<100'000'000; i++) {
        a++;
    }
}
```

Now measure the time taken when `increment` is invoked on x and y on separate threads.

```cpp
int main() {
    auto start = std::chrono::high_resolution_clock::now();

    std::thread t1([&](){ increment(a); });
    std::thread t2([&](){ increment(b); });
    t1.join();
    t2.join();

    auto end = std::chrono::high_resolution_clock::now();
    std::cout << "time: " << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count() << " ms\n";

    return 0;
}
```

Run the program and note the time taken, for my machine this turned out to be close to `500ms`
Another metric we can use here is the IPC or instruction per cycle, which you can get using `perf`
```shell
$ perf stat ./a.out
time: 503 ms

 Performance counter stats for './a.out':

            893.16 msec task-clock:u                     #    1.760 CPUs utilized
                 0      context-switches:u               #    0.000 /sec
                 0      cpu-migrations:u                 #    0.000 /sec
               139      page-faults:u                    #  155.627 /sec
     1,602,565,788      instructions:u                   #    0.67  insn per cycle
     2,385,620,324      cycles:u                         #    2.671 GHz
       200,447,733      branches:u                       #  224.424 M/sec
            14,482      branch-misses:u                  #    0.01% of all branches
                        TopdownL1                 #     68.2 %  tma_backend_bound
                                                  #     11.9 %  tma_bad_speculation
                                                  #      4.3 %  tma_frontend_bound
                                                  #     15.6 %  tma_retiring

       0.507340864 seconds time elapsed

       0.892937000 seconds user
       0.000000000 seconds sys
```

We can see `0.67 insn per cycle`, hmm ok.

## Struct instead of int

Now, let us use this padded struct instead of the long longs which we used earlier

```cpp
struct PaddedStruct {
    long long value;
    char pad[64 - sizeof(long long)];
};

PaddedStruct pa = {};
PaddedStruct pb = {};
```

Overload the earlier defined function to handle this structure as well
```cpp
void increment(Padding& a) {
    for (int i=0; i<100'000'000; i++) {
        a.value++;
    }
}
```

Now invoke the functions on two thread, similar to what we did earlier
```cpp
std::thread t1([&](){ increment(pa); });
std::thread t2([&](){ increment(pb); });
```

This time, you will notice time takes turns out to be roughly half of what was observed earlier. For my machine, this new time was `300ms`.  
Again, we can get the IPC using `perf`
```
$ perf stat ./a.out
time: 297 ms

 Performance counter stats for './a.out':

            594.66 msec task-clock:u                     #    1.975 CPUs utilized
                 0      context-switches:u               #    0.000 /sec
                 0      cpu-migrations:u                 #    0.000 /sec
               138      page-faults:u                    #  232.066 /sec
     1,602,565,643      instructions:u                   #    1.06  insn per cycle
     1,508,069,432      cycles:u                         #    2.536 GHz
       200,447,663      branches:u                       #  337.080 M/sec
            14,506      branch-misses:u                  #    0.01% of all branches
                        TopdownL1                 #     71.2 %  tma_backend_bound
                                                  #      1.5 %  tma_bad_speculation
                                                  #      2.8 %  tma_frontend_bound
                                                  #     24.6 %  tma_retiring

       0.301146813 seconds time elapsed

       0.594276000 seconds user
       0.000000000 seconds sys
```

We can clearly see 1.06 insn per cycle, that is roughly double of what we saw in case of long longs.



