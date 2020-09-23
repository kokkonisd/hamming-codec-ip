library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


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
    port (
        DataIn : in  std_logic_vector (3 downto 0);
        DataOut: out std_logic_vector (6 downto 0)
    );
end entity;


architecture default of HammingEncoder is
begin

    -- The output vector has as follows (D are data bits, P are parity bits):
    -- [MSB] P2 P1 P0 D3 D2 D1 D0 [LSB]
    --
    -- where: P0 = D0 xor D1 xor D3
    --        P1 = D0 xor D2 xor D3
    --        P2 = D1 xor D2 xor D3

    DataOut(0) <= DataIn(0);
    DataOut(1) <= DataIn(1);
    DataOut(2) <= DataIn(2);
    DataOut(3) <= DataIn(3);
    DataOut(4) <= DataIn(0) xor DataIn(1) xor DataIn(3);
    DataOut(5) <= DataIn(0) xor DataIn(2) xor DataIn(3);
    DataOut(6) <= DataIn(1) xor DataIn(2) xor DataIn(3);

end architecture;
