# Difference of Means

> Powerful mathematical tool to predict a key

This is a very good example of a side channel attack on AES to obtain the last round key.

## Requirements
- Access to AES encryption box
- Ability to obtain ciphertext for any plaintext from the box
- Obtain some 4000 such pairs of ciphertext-plaintext
- Power trace data for AES encryption during this process

## Goal
- Obtain the last round AES key

Say the you have obtained ciphertext-plaintext pairs as follows:

```csv title="pairs.csv"
bfdd0c7cb42a5cc3556c0f6d8a846265l,12786e6e08af735b5504a0a5c7ca950el
bbf5ace82102b6c9321f781f657bd22fl,932c9712be474e202b9717fcaa90e61dl
b0837585740e07d510001a0b8019bdf5l,f6ebbc4be2a45a9e139e5acaf124475dl
683a7d943b663def1b8267b61cbeca4fl,f8293c17af9af3f7cc11e8d66339a0cel
89ecdf843ae9dd510c43a5cd87df3da9l,a33d96daf5da06f669ea879d871c601cl
...
```

Say the power trace data looks something like this (note that this relative power trace for each encryption pair):

```text title="power.txt"
1
5
3
5
...
```

Now, using the above two information and some cool maths, we develop the following algorithm:

```python title="dom.py"
numtrace = 4000 # number of ciphertext-plaintext pairs 
max_mean = 0
# kb is the key byte guessed for an iteration in the loop
for kb in range(0, 256):
    pairs = open_csv("pairs.csv")
    bin_0 = 0, bin_1 = 0
    count_bin_0 = 0, count_bin_1 = 0
    count = 0
    # iterate on rows of the ciphertext-plaintext pairs
    for row in pairs:
        ct = get_ciphertext(row)
        # take the least significant byte of the ciphertext
        ct_temp = get_lsb(ct)
        # find the last round inverse sbox value for the current byte of key guess
        b_temp = inv_s_box(ct_temp ^ kb)
        # get the corresponding power trace for the current row
        binexp = get_power(count, "power.txt")
        if get_lsb(b_temp) == 0:
            bin_0 += binexp
            count_bin_0 += 1
        else:
            bin_1 += binexp
            count_bin_1 += 1
        # increment count and break out of loop if it reaches numtrace
        count += 1
        if count == numtrace:
            break

    # find the absolute difference between bin_0 and bin_1 and if it is greater than max_mean
    # update the prob_key
    # idea: in a random simulation this difference of means should be close to 0
    # hence if it goes off (not zero), we know we made a right guess
    diff = abs(bin_0 - bin_1)
    if diff > max_mean:
        max_mean = diff
        prob_key = kb

print("probable Key Byte:", hexadecimal_format(prob_key))
```
