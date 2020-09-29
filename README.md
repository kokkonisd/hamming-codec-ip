# Hamming codec IP

![CI](https://github.com/kokkonisd/hamming-codec-ip/workflows/CI/badge.svg)

Inspired by [Ben Eater](https://www.youtube.com/watch?v=h0jloehRKas&ab_channel=BenEater) and
[Grant Sanderson (3blue1brown)](https://www.youtube.com/watch?v=X8jsijhllIA&ab_channel=3Blue1Brown).


## About this IP

This IP implements a simple encoder-decoder pair using [Hamming codes](https://en.wikipedia.org/wiki/Hamming_code) to
encode ~~a 4-bit message~~ a message of **arbitrary length** in order to make it resilient to 1-bit errors.
Specifically, 1-bit errors can always be corrected automatically, and 2-or-more-bit errors can be detected.


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

Let us take a 8-bit message block in order to examine how this codec works. For reasons that will become apparent
later, for a block of size `X` only `X - log2(X) - 1` bits can actually be used for the message itself; the other
bits will be used for parity.

Bit `0` is always used for global parity (parity amongst _all_ the bits of the block); bits whose index is a power of
two - that is to say, bits `1`, `2` and `4` in this case - are used for _Hamming parity_. The block layout is displayed
on the following table:

<table>
    <tr>
        <td>GP</td>
        <td>P1</td>
    </tr>
    <tr>
        <td>P2</td>
        <td>D1</td>
    </tr>
    <tr>
        <td>P3</td>
        <td>D2</td>
    </tr>
    <tr>
        <td>D3</td>
        <td>D4</td>
    </tr>
</table>

`GP` is the global parity bit, `Px` are Hamming parity bits and `Dx` are data (or message) bits.

Hamming parity bits ensure parity over specific groups of bits. For example, `P1` ensures parity amongst `D1`, `D2` and
`D4`. This allows us to sort of _binary-search_ the message block in order to pinpoint 1-bit errors efficiently. Blocks
are thus split in the following fashion:

<table>
    <tr>
        <td>GP</td>
        <td><strong>P1</strong></td>
    </tr>
    <tr>
        <td>P2</td>
        <td><strong>D1</strong></td>
    </tr>
    <tr>
        <td>P3</td>
        <td><strong>D2</strong></td>
    </tr>
    <tr>
        <td>D3</td>
        <td><strong>D4</strong></td>
    </tr>
</table>

<table>
    <tr>
        <td>GP</td>
        <td>P1</td>
    </tr>
    <tr>
        <td><strong>P2</strong></td>
        <td><strong>D1</strong></td>
    </tr>
    <tr>
        <td>P3</td>
        <td>D2</td>
    </tr>
    <tr>
        <td><strong>D3</strong></td>
        <td><strong>D4</strong></td>
    </tr>
</table>

<table>
    <tr>
        <td>GP</td>
        <td>P1</td>
    </tr>
    <tr>
        <td>P2</td>
        <td>D1</td>
    </tr>
    <tr>
        <td><strong>P3</strong></td>
        <td><strong>D2</strong></td>
    </tr>
    <tr>
        <td><strong>D3</strong></td>
        <td><strong>D4</strong></td>
    </tr>
</table>

By `XOR`ing bits in each parity group we can detect which groups have the wrong parity, and their overlap allows us to
pinpoint _exactly_ which bit caused the parity error.

The groups themselves are formed by following a very simple rule: for `n` from `0` to `log2(X) - 1`, where `X` is the
block size, Hamming parity group `n` consists of all the bits whose index's `n`th bit is equal to `1`. For example, for
the first parity group (meaning we have to "look" at bit `0`, the LSB) in the previous example, we have: 

<table>
    <tr>
        <td>000</td>
        <td><strong>001</strong></td>
    </tr>
    <tr>
        <td>010</td>
        <td><strong>011</strong></td>
    </tr>
    <tr>
        <td>100</td>
        <td><strong>101</strong></td>
    </tr>
    <tr>
        <td>110</td>
        <td><strong>111</strong></td>
    </tr>
</table>

In order to perform the decoding, we must first `XOR` the elements of each parity group together. If we then form a
vector whose bits are the results of the previous `XOR`s, with the first parity group corresponding to bit `0`, the
second corresponding to bit `1` etc, this vector will give us the index of the erroneous bit in the message block.

If the index of the erroneous bit is non-zero, we should first correct it (by flipping it) and then verify the global
parity of the message block using bit `0`. If the global parity is correct, then there was only one error, and we
successfully corrected it. If not, then there is at least one more error, which cannot be pinpointed, and thus the
decoder IP should communicate an error code to the user.

If the index of the erroneous bit is zero and the global parity is correct, then there is no error. If, on the other
hand, the global parity is incorrect, then there are at least two errors, and the IP should once again communicate an
error code to the user.

Finally, for a block of size 256 (bits) this method of encoding is very efficient, as it only uses 3.5% of the message
block for parity checks, and leaves the remaining 96.5% for useful message data. This IP limits the maximum block size
to 256 bits however, because even though Hamming codes become more efficient as the block size increases, the blocks
themselves also become more vulnerable to more-than-one-bit errors, which this IP cannot recover from.
