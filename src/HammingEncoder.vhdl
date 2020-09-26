library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


-- Hamming encoder
-- This IP encodes a message using Hamming encoding, in order to make it resilient to 1-bit errors. In order to come 
-- back to the original input, it should be used along with the HammingDecoder IP.
--
-- Inputs:
--     BlockSize: the size of the message block; not all of it will be used to contain a message, as some of it will
--                be used for parity bits. Specifically, `ceil(log2(BlockSize)) + 1` will be used for parity bits, and
--                the rest can be used for the message. Power of 2 sizes should be preferred for the block size.
--     DataIn   : a data input, to be hamming-encoded (`BlockSize - (ceil(log2(BlockSize)) + 1)` bits long)
-- Outputs:
--     DataOut: a `BlockSize`-bit data output, containing the hamming encoding of DataIn. Bit 0 as well as all bits
--              whose index is a power of 2 (1, 2, 4, 8 etc) will be used as parity bits.
--
-- Written by D. Kokkonis (@kokkonisd)


entity HammingEncoder is
    generic (
        BlockSize : integer range 8 to 256
    );
    port (
        DataIn  : in  std_logic_vector ((BlockSize - integer(ceil(log2(real(BlockSize)))) - 2) downto 0);
        DataOut : out std_logic_vector ((BlockSize - 1) downto 0)
    );
end entity;


architecture default of HammingEncoder is
    constant parity_bits : integer := integer(ceil(log2(real(BlockSize))));
    signal encoded_data : std_logic_vector ((BlockSize - 1) downto 0);
begin

    encoding: process (DataIn)
        -- Counter variable
        variable j : integer;
        -- Variable to help index bits of counter
        variable bit_index : std_logic_vector (7 downto 0);
        -- Variable to help calculate powers of 2 via shifting
        variable pow_2_index : std_logic_vector (7 downto 0);
        -- Variable to help calculate parity
        variable parity : std_logic;
        -- Vector to hold the result of the encoding, used as a scratch buffer
        variable scratch_vector : std_logic_vector ((BlockSize - 1) downto 0);
    begin
        -- Initialize output vector to 0
        scratch_vector := (others => '0');

        -- Check that input is valid
        if (DataIn /= (DataIn'range => 'U')) then
            -- Initialize output vector with input message values
            j := 0;
            for i in 3 to (BlockSize - 1) loop
                if (integer(ceil(log2(real(i)))) /= integer(floor(log2(real(i))))) then
                    scratch_vector(i) := DataIn(j);
                    j := j + 1;
                end if;
            end loop;

            -- Set parity bits accordingly 
            for i in 0 to (parity_bits - 1) loop
                -- Move to the next power of 2 in terms of index
                pow_2_index := "00000000";
                pow_2_index(i) := '1';
                parity := '0';

                -- Iterate over all bits of the block
                for k in 1 to (BlockSize - 1) loop
                    bit_index := std_logic_vector(to_unsigned(k, 8));
                    -- If the i-th bit (i corresponding to the i-th parity bit) is 1, this element is in the i-th
                    -- parity group, so we need to take it into account when calculating parity
                    if (bit_index(i) = '1') then
                        parity := parity xor scratch_vector(k);
                    end if;
                end loop;

                -- Set the final parity for this parity group
                scratch_vector(to_integer(unsigned(pow_2_index))) := parity;
            end loop;

            -- Set global parity bit (LSB)
            parity := '0';
            for i in 1 to (BlockSize - 1) loop
                parity := parity xor scratch_vector(i);
            end loop;
            scratch_vector(0) := parity;
        end if;

        -- Update signal based on the final form of the scratch vector
        encoded_data <= scratch_vector;
    end process;

    DataOut <= encoded_data;

end architecture;
