# Atomic

An operation which can be done by a single thread of execution.

Thread A: Before state -- atomic operation --> After state
Other threads can only see Before state and after state and nothing in between.

```cpp
#include <atomic>
#include <thread>
#include <iostream>

std::atomic<int>  x(0);

void add_to_x_atomic(int id) {
    for (int i=0; i<100; i++) {
        x++; // atomic operation
    }
}

int main() {

    std::thread t1(add_to_x_atomic, 1);
    std::thread t2(add_to_x_atomic, 2);

    t1.join();
    t2.join();

    std::cout << "x = " << x << "\n";

    return 0;
}

```

Refer to this list for atomic expressions

- ++x
- x++
- x +=1
- x |= 2
- x *= 2 (will not compile at all)
- x = y + 1
- x = x * 2  (not atomic)
- x = x + 1  (not atomic, atomic read, followed by atomic write)

Assignment and copy are defined for all T in atomic<T>

- Increment and decrement for raw pointers
- Addition, subtraction, bitwise for integers
- `std::atomic<bool>` is valid but no special operations (only read and write)
- `std::atomic<double>` is valid but no special operations (only read and write)

## Member functions

For atomic<T> x we have the following:

- `T y = x.load()  // is same as T y = x;`
- `x.store(y)        // is same as x = y;`
- `T z = x.exchange(y) // z = x; x = y;`
- Compare and Swap (CAS) key to most lock free programs uses the following
    - `bool success = x.compare_exchange_strong(y, z);`
    - if x == y, make x =z, return true
    - else set y = x, return false

## CAS

Can write lock-free (not wait-free) programs
Can atomic increment using this:

```cpp
// following is not wait free but lock free
std::stomic<int> x{0};
int x0 = x;
while (!x.compare_exchange_strong(x0, x0 + 1)) {}
// we have atomic increment for ints but this method can be extended for atomically
// incrementing floats, doubles, multiply integers

// atomic multiply
while (!x.compare_exchange_strong(x0, x0 * 2)) {}
```

Time:

atomic++ < CAS++ < mutex++

## Atomic not always lock free

```cpp
long x;
struct A { long x; }; // lock free
struct B { long x; long y }; // lock free on x86
struct C { long x; long y; long z; }; // not lock free
```

## Atomics sometimes wait on each other

- Thread 1: ++x[0]
- Thread 2: ++x[1]

Cache line sharing: two operations are in same cache lines

whole array loads in 64 byte cache and thread 2 now has to wait for thread 1 to finish

## Atomic Queue

```cpp
int N = 1024;
int q[N];                  // non atomic data structure in memory
std::atomic<size_t> front; // atomic

void push(int x) {
	size_t my_slot = front.fetch_add(1); // atomic operation to get exclusive slot
	q[my_slot] = x;
}
```


