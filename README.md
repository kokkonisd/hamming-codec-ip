# Hamming codec IP

Inspired by [Ben Eater](https://www.youtube.com/watch?v=h0jloehRKas&ab_channel=BenEater) and
[Grant Sanderson (3blue1brown)](https://www.youtube.com/watch?v=X8jsijhllIA&ab_channel=3Blue1Brown).


## About this IP

This IP implements a simple encoder-decoder pair using [Hamming codes](https://en.wikipedia.org/wiki/Hamming_code\
                                                                       #:~:text=In%20computer%20science%20and%20\
                                                                       telecommunication,without%20detection%20of%20\
                                                                       uncorrected%20errors.)
to encode a 4-bit message (which will soon be extended to account for messages of arbitrary length) in order to make it
resilient to 1-bit errors.


## How to use

In order to use this IP in this specific project, you need to install [ghdl](http://ghdl.free.fr/) and
[gtkwave](http://gtkwave.sourceforge.net/) in order to run tests and also visualize the test benches of the IPs. You
will also need [GNU Make](https://www.gnu.org/software/make/) in order to `make` this project.

Once you have these dependencies installed, you can simply `make` the project:

```bash
$ make
```

The two IPs will then be compiled and unit tests will run for each IP in order to confirm their functionality.


## How it works

_Note: this is not an in-depth mathematical explanation. For more details, visit the links at the beginning of this
README._

Let us take a 4-bit message as an example to demonstrate how Hamming codes work. A very basic idea for error-resilience
is to check for parity: for every bit, we could have another bit that ensures that the total number of 1s in the 
message is a pair number. However, this doubles the size of the message we have to send, and also can be very
ambiguous: how can we tell if the "noisy" bit (the bit that has flipped during transfer) is the parity bit or the real
bit?

We could try to replace this parity bit with two copies of the original bit (for every bit), and then collapse the 3
bits to 1 bit, the value of which is the "majority vote" among the values of the 3 bits (if at most one flips, then the
other two should stay the same). However this is very inefficient space-wise, as we are effectively tripling the memory
footprint of our message.

A more clever way to tackle this problem would be to use "groups" of parity in order to determine which bit has
flipped. Consider for example the following configuration, where `D` bits refer to data bits and `P` bits refer to
parity bits:

| P2 | P1 | P0 | D3 | D2 | D1 | D0 |
|----|----|----|----|----|----|----|
|    |    | x  | x  |    | x  | x  |
|    | x  |    | x  | x  |    | x  |
| x  |    |    | x  | x  | x  |    |

What this table describes is three parity bits, which ensure parity as follows:

- `P0` ensures parity for `D0`, `D1` and `D3`
- `P1` ensures parity for `D0`, `D2` and `D3`
- `P2` ensures parity for `D1`, `D2` and `D3`

For example, the message `1011` would be encoded as follows:

- `P0 = 1`, because there are three 1s among `D0`, `D1` and `D3` (`D0 = 1`, `D1 = 1` and `D3 = 1`)
- `P1 = 0`, because there are two 1s among `D0`, `D2` and `D3` (`D0 = 1` and `D3 = 1`)
- `P2 = 0`, because there are two 1s among `D1`, `D2` and `D3` (`D1 = 1` and `D3 = 1`)

So `1011` would be encoded as `0011011`.

In order to decode it, we first must determine which of the three groups, associated to the three parity bits, are
"triggered" (meaning that an error is detected in them). In order to do that, we can simply `XOR` the elements of each
group:

- `group1 = D0 xor D1 xor D3 xor P0`
- `group2 = D0 xor D2 xor D3 xor P1`
- `group3 = D1 xor D2 xor D3 xor P2`

In this case, `group1 = 0` (four 1s), `group2 = 0` (two 1s) and `group3 = 0` (two 1s). No errors are detected, as
expected.

To come back to the original message, we can just `AND` all three groups, in all possible "triggered" configurations,
and simply `XOR` them with the corresponding data bit in order to find out if the bit should be flipped back or not.

For example, if groups 1 and 2, but not group 3, have been triggered, that means that `D0` (the only data bit present
in groups 1 and 2 but not in 3) is wrong and should be flipped. In boolean logic, this can be translated to:

```
D0_out = (group1 AND group2 AND (NOT group3)) XOR D0
```

If we apply the same logic to the other data bits, we get:
```
D0_out = (group1       AND group2       AND (NOT group3)) XOR D0
D1_out = (group1       AND (NOT group2) AND group3)       XOR D1
D2_out = ((NOT group1) AND group2       AND group3)       XOR D2
D3_out = (group1       AND group2       AND group3)       XOR D3
```

Thus, if we decode `0011011` following that logic we come back to `1011`.

If, however, we flip the LSB, for example transforming the encoded message to `0011010`, we can see that groups 1 and 2
are "triggered" (`group1 = 1` and `group2 = 1`), which will cause bit 0 to be flipped in the decoder, thus transforming
it back to a 1 and getting the correct version of the original message.
