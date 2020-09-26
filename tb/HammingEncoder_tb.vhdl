library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Hamming encoder test bench for the HammingEncoder IP
--
-- This test bench aims to test the operations of the HammingEncoder IP
--
-- Written by D. Kokkonis (@kokkonisd)


entity HammingEncoder_tb is
end entity;


architecture default of HammingEncoder_tb is
    signal BlockSize : integer          := 8;
    signal DataIn    : std_logic_vector (3 downto 0);
    signal DataOut   : std_logic_vector (7 downto 0);

begin

    T0: entity work.HammingEncoder(default) generic map (BlockSize) port map (DataIn, DataOut);

    test: process
    begin
        DataIn <= "0000";
        wait for 1 us;
        assert DataOut = "00000000" report "DataOut is wrong for input '0000'" severity error;

        DataIn <= "0001";
        wait for 1 us;
        assert DataOut = "00001111" report "DataOut is wrong for input '0001'" severity error;

        DataIn <= "0010";
        wait for 1 us;
        assert DataOut = "00110011" report "DataOut is wrong for input '0010'" severity error;
    
        DataIn <= "0011";
        wait for 1 us;
        assert DataOut = "00111100" report "DataOut is wrong for input '0011'" severity error;
    
        DataIn <= "0100";
        wait for 1 us;
        assert DataOut = "01010101" report "DataOut is wrong for input '0100'" severity error;

        DataIn <= "0101";
        wait for 1 us;
        assert DataOut = "01011010" report "DataOut is wrong for input '0101'" severity error;

        DataIn <= "0110";
        wait for 1 us;
        assert DataOut = "01100110" report "DataOut is wrong for input '0110'" severity error;

        DataIn <= "0111";
        wait for 1 us;
        assert DataOut = "01101001" report "DataOut is wrong for input '0111'" severity error;

        DataIn <= "1000";
        wait for 1 us;
        assert DataOut = "10010110" report "DataOut is wrong for input '1000'" severity error;

        DataIn <= "1001";
        wait for 1 us;
        assert DataOut = "10011001" report "DataOut is wrong for input '1001'" severity error;

        DataIn <= "1010";
        wait for 1 us;
        assert DataOut = "10100101" report "DataOut is wrong for input '1010'" severity error;

        DataIn <= "1011";
        wait for 1 us;
        assert DataOut = "10101010" report "DataOut is wrong for input '1011'" severity error;

        DataIn <= "1100";
        wait for 1 us;
        assert DataOut = "11000011" report "DataOut is wrong for input '1100'" severity error;

        DataIn <= "1101";
        wait for 1 us;
        assert DataOut = "11001100" report "DataOut is wrong for input '1101'" severity error;

        DataIn <= "1110";
        wait for 1 us;
        assert DataOut = "11110000" report "DataOut is wrong for input '1110'" severity error;

        DataIn <= "1111";
        wait for 1 us;
        assert DataOut = "11111111" report "DataOut is wrong for input '1111'" severity error;
    end process;

end architecture;
