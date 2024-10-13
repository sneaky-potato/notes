# Spectre

This attack is based on one of the features introduced in computers to speed up repeatitive tasks.

## Out-of-order execution

Imagine a restaurant, and now imagine a cutomer who comes there every morning and orders the exact same breakfast. Naturally, the chef will start making the breakfast beforehand to save his time. This will save his time a lot.
But what if the customer, out of the blue decides one day to order something different on the morning. The chef will have to throw the dish of course.
This is an example of out-of-order execution, since the chef chose not to execute the instructions of the customer but rather made his own assumptions to save some time.

## Attack

Consider the following code snippet

```c
data = [1, 2, 3, 4];       // could be any set of information
input = 1000;              // much larger than 4 which is the size of above array

if (input < data.size) {   // obviously will evaluate to false
    secret = data[input];                 // some private information which we are interested in
}
```

Here line number 4 is of interest, it is of course false, but say 
- calculating `data.size` requires some time as the cpu will have to request this information from the memory. 
- What can the cpu do in that time?
- Speculative execution, that is the cpu will do an out-of-order execution and try executing the next line. 
- The cpu stores the `data[input]` value in its cache.
This is done in case the speculation is true, cpu gets an upper hand in terms of time.

However because of various side channel attacks already discovered the attacker can retrieve this private information from the cache as follows-

```c
chars = ['a', 'b', 'c', ... 'z'];
for (int i = 0; i < 26; i++) {
    measure_time(chars[i]);
}
```

If the measured time for `i=15` comes out to be very low as compared to all the other characters, this means `secret = chars[15]`
Or `secret = p`.

