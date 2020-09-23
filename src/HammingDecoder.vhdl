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
    signal group1: std_logic;
    signal group2: std_logic;
    signal group3: std_logic;
begin

--  D4 D3 D2 P3 D1 P2 P1

    group1 <= DataIn(0) xor DataIn(2) xor DataIn(4) xor DataIn(6);
    group2 <= DataIn(1) xor DataIn(2) xor DataIn(5) xor DataIn(6);
    group3 <= DataIn(3) xor DataIn(4) xor DataIn(5) xor DataIn(6);

    DataOut(0) <= ((not group1) and group2       and group3)       xor DataIn(2);
    DataOut(1) <= (group1       and (not group2) and group3)       xor DataIn(4);
    DataOut(2) <= (group1       and group2       and (not group3)) xor DataIn(5);
    DataOut(3) <= (group1       and group2       and group3)       xor DataIn(6);

end architecture;
