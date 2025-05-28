# Correlation Power Analysis 

> Statistics help crack encryption

This is very similiar to [[dom]], in the sense that requirements and goal for this attack are exactly the same.
I urge you to read about [[dom]], before continuing on this note. I will assume that you know about `pairs.csv` and `power.txt` for this attack.

```python title="cpa.py"
numtrace = 4000 # number of ciphertext-plaintext pairs
# kb is the key byte guessed for an iteration in the loop
for kb in range(0, 256):
    pairs = open_csv("pairs.csv")
    count = 0
    # iterate on rows of the ciphertext-plaintext pairs
    for row in pairs:
        ct = get_ciphertext(row)
        # take the least significant byte of the ciphertext
        ct_temp = get_lsb(ct)
        # find the last round inverse sbox value for the current byte of key guess
        b_temp = inv_s_box(ct_temp ^ kb)
        # get the number of ones present in b_temp
        binexp = get_number_of_ones(b_temp)

        # assign this value to a hypothetical vector
        hypo_vector[count] = binexp

        # get the corresponding power value from the power trace file
        power_vector[count] = get_power(count, "power.txt")

        # increment count and break out of loop if it reaches numtrace
        count += 1
        if count == numtrace:
            break

    # find the pearson correlation value and if it is less than corr_val
    # update the prob_key
    # idea: in a random simulation this value will be very large
    # hence if it correlates (almost zero), we know we made a right guess
    corr = get_pearson_correlation(hypo_vector, power_vector)
    if corr < corr_val:
        corr_val = corr
        prob_key = kb

print("probable Key Byte:", hexadecimal_format(prob_key))
```

## References
- [Pearson Correlation Coefficient](https://en.wikipedia.org/wiki/Pearson_correlation_coefficient)
