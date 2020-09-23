library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Hamming encoder
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

    DataOut(0) <= DataIn(0) xor DataIn(1) xor DataIn(3);
    DataOut(1) <= DataIn(0) xor DataIn(2) xor DataIn(3);
    DataOut(2) <= DataIn(0);
    DataOut(3) <= DataIn(1) xor DataIn(2) xor DataIn(3);
    DataOut(4) <= DataIn(1);
    DataOut(5) <= DataIn(2);
    DataOut(6) <= DataIn(3);

end architecture;
