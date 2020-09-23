library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Hamming decoder
-- This IP decodes a 7-bit hamming-encoded message, encoded using the HammingEncoder IP.
--
-- Inputs:
--     DataIn is a 7-bit data input, which is the hamming-encoded version of a 4-bit message
-- Outputs:
--     DataOut is a 4-bit data output, containing the original message as decoded from the 7-bit input
--
-- Written by D. Kokkonis (@kokkonisd)


entity HammingDecoder is
    port (
        DataIn : in  std_logic_vector (6 downto 0);
        DataOut: out std_logic_vector (3 downto 0)
    );
end entity;


architecture default of HammingDecoder is
    signal group1: std_logic; -- tied to data digits 0, 1 and 3
    signal group2: std_logic; -- tied to data digits 0, 2 and 3
    signal group3: std_logic; -- tied to data digits 1, 2 and 3
begin

    -- The input vector has as follows (D are data bits, P are parity bits):
    -- [MSB] P2 P1 P0 D3 D2 D1 D0 [LSB]
    --
    -- where: P0 = D0 xor D1 xor D3
    --        P1 = D0 xor D2 xor D3
    --        P2 = D1 xor D2 xor D3
    group1 <= DataIn(0) xor DataIn(1) xor DataIn(3) xor DataIn(4);
    group2 <= DataIn(0) xor DataIn(2) xor DataIn(3) xor DataIn(5);
    group3 <= DataIn(1) xor DataIn(2) xor DataIn(3) xor DataIn(6);

    -- If groups 1 and 2 are triggered, D0 must be flipped
    DataOut(0) <= (group1       and group2       and (not group3)) xor DataIn(0);
    -- If groups 1 and 3 are triggered, D1 must be flipped
    DataOut(1) <= (group1       and (not group2) and group3)       xor DataIn(1);
    -- If groups 2 and 3 are triggered, D2 must be flipped
    DataOut(2) <= ((not group1) and group2       and group3)       xor DataIn(2);
    -- If all groups are triggered, D3 must be flipped
    DataOut(3) <= (group1       and group2       and group3)       xor DataIn(3);

end architecture;
