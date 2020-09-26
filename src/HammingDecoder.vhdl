library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


-- Hamming decoder
-- This IP decodes a hamming-encoded message, encoded using the HammingEncoder IP.
--
-- Inputs:
--     BlockSize: the size of the message block; not all of it will be used to contain a message, as some of it will
--                be used for parity bits. Specifically, `ceil(log2(BlockSize)) + 1` will be used for parity bits, and
--                the rest can be used for the message. Power of 2 sizes should be preferred for the block size.
--     DataIn   : a `BlockSize`-bit data input, containing the hamming encoding of a message. Bit 0 as well as all bits
--                whose index is a power of 2 (1, 2, 4, 8 etc) are parity bits.
-- Outputs:
--     DataOut  : a data output, containing the original message as decoded from the input. Its size is
--                `BlockSize - (ceil(log2(BlockSize)) + 1)` bits.
--     ErrorCode: an output signifying the result of the decoding process. Value '0' corresponds to OK (message was
--                decoded without errors), value '1' corresponds to KO (at least 2 errors were found, impossible to
--                recover message).
--
-- Written by D. Kokkonis (@kokkonisd)


entity HammingDecoder is
    generic (
        BlockSize : integer range 8 to 256
    );
    port (
        DataIn    : in  std_logic_vector ((BlockSize - 1) downto 0);
        DataOut   : out std_logic_vector ((BlockSize - integer(ceil(log2(real(BlockSize)))) - 2) downto 0);
        ErrorCode : out std_logic
    );
end entity;


architecture default of HammingDecoder is
    constant parity_bits : integer := integer(ceil(log2(real(BlockSize)))); 
    signal decoded_data : std_logic_vector ((BlockSize - parity_bits - 2) downto 0);
    signal error_code : std_logic;
begin

    decoding: process (DataIn)
        -- Counter variable
        variable j : integer;
        -- Vector to hold the result of the decoding, used as a scratch buffer
        variable scratch_output_vector : std_logic_vector ((BlockSize - parity_bits - 2) downto 0);
        -- Vector to hold the calculations & checks performed on the input, used as a scratch buffer
        variable scratch_input_vector : std_logic_vector ((BlockSize - 1) downto 0);
        -- Vector to be used to calculate the position of the error in the input (if there is an error)
        variable error_index : std_logic_vector (7 downto 0);
        -- Variable to help index bits of counter
        variable bit_index : std_logic_vector (7 downto 0);
        -- Variable to help calculate powers of 2 via shifting
        variable pow_2_index : std_logic_vector (7 downto 0);
        -- Variable to help calculate parity
        variable parity : std_logic;
    begin
        -- Set output to be undefined by default
        scratch_output_vector := (others => 'U');
        -- Set error code to KO by default
        error_code <= '1';

        -- Check that input is valid
        if (DataIn /= (DataIn'range => 'U')) then
            scratch_input_vector := DataIn;

            -- Initialize error index to 0
            error_index := (others => '0');
            -- Set error index according to Hamming parity bits
            for i in 0 to (parity_bits - 1) loop
                -- Move to the next power of 2 in terms of index
                pow_2_index := (others => '0');
                pow_2_index(i) := '1';
                parity := '0';

                -- Iterate over all bits of the block
                for k in 1 to (BlockSize - 1) loop
                    bit_index := std_logic_vector(to_unsigned(k, 8));
                    -- If the i-th bit (i corresponding to the i-th parity bit) is 1, this element is in the i-th
                    -- parity group, so we need to take it into account when calculating parity
                    if (bit_index(i) = '1') then
                        parity := parity xor scratch_input_vector(k);
                    end if;
                end loop;

                -- Set the final parity for this parity group in the appropriate error index bit
                error_index(i) := parity;
            end loop;

            -- If the error index is non-zero, then at least one error is present & fixable
            if (error_index /= (error_index'range => '0')) then
                -- Flip the error bit
                scratch_input_vector(to_integer(unsigned(error_index))) :=
                                                           not scratch_input_vector(to_integer(unsigned(error_index)));
            end if;

            -- Check overall parity
            parity := '0';
            for i in 0 to (BlockSize - 1) loop
                parity := parity xor scratch_input_vector(i);
            end loop;

            if (parity = '0') or ((parity = '1') and (error_index = (error_index'range => '0'))) then
                -- If parity is 0 (OK) or 1 but no Hamming errors were found (meaning error must be on the global
                -- parity bit, which we do not care about), then the message is OK, we can copy it over
                j := 0;
                for i in 3 to (BlockSize - 1) loop
                    if (integer(ceil(log2(real(i)))) /= integer(floor(log2(real(i))))) then
                        scratch_output_vector(j) := scratch_input_vector(i);
                        j := j + 1;
                    end if;
                end loop;
                -- Set error code to OK
                error_code <= '0';
            else
                -- Message is KO, set all the bits to 'U'
                scratch_output_vector := (others => 'U');
                -- Set error code to KO
                error_code <= '1';
            end if;

            -- Set decoded data signal
            decoded_data <= scratch_output_vector;
        end if;
    end process;

    -- Set outputs accordingly
    DataOut <= decoded_data;
    ErrorCode <= error_code;

end architecture;
