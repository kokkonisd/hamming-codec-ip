library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


-- Hamming encoder
-- This IP encodes a 4-bit message using Hamming encoding, in order to make it resilient to 1-bit errors. In order to
-- come back to the original input, it should be used along with the HammingDecoder IP.
--
-- Inputs:
--     DataIn is a 4-bit data input, to be hamming-encoded
-- Outputs:
--     DataOut is a 7-bit data output, containing the hamming encoding of DataIn. Bits 0, 1 and 3 are parity, bits 2
--     and 4 through 6 correspond to DataIn bits 0 through 3 respectively.
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

    encoding: process(DataIn)
        -- Counter variable
        variable j : integer := 0;
        -- Variable to help index bits of counter
        variable bit_index : std_logic_vector (7 downto 0);
        -- Variable to help calculate powers of 2 via shifting
        variable pow_2_index : std_logic_vector (7 downto 0);
        -- Variable to help calculate parity
        variable parity : std_logic;
        -- Scratch vector to hold the result of all calculations
        variable scratch_vector : std_logic_vector ((BlockSize - 1) downto 0);
    begin
        -- Initialize output vector to 0
        scratch_vector := (others => '0');

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
