library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Hamming decoder test bench for the HammingDecoder IP
--
-- This test bench aims to test the operations of the HammingDecoder IP
--
-- Written by D. Kokkonis (@kokkonisd)


entity HammingDecoder_tb is
end entity;


architecture default of HammingDecoder_tb is
    signal DataIn : std_logic_vector (6 downto 0);
    signal DataOut: std_logic_vector (3 downto 0);

begin

    T0: entity work.HammingDecoder(default) port map (DataIn, DataOut);

    test: process
    begin
        DataIn <= "0000000";
        wait for 1 ns;
        assert DataOut = "0000" report "DataOut is wrong for input '0000000'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "0000" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "0110001";
        wait for 1 ns;
        assert DataOut = "0001" report "DataOut is wrong for input '0000111'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "0001" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "1010010";
        wait for 1 ns;
        assert DataOut = "0010" report "DataOut is wrong for input '0011001'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "0010" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "1100011";
        wait for 1 ns;
        assert DataOut = "0011" report "DataOut is wrong for input '0011110'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "0011" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "1100100";
        wait for 1 ns;
        assert DataOut = "0100" report "DataOut is wrong for input '0101010'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "0100" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "1010101";
        wait for 1 ns;
        assert DataOut = "0101" report "DataOut is wrong for input '0101101'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "0101" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "0110110";
        wait for 1 ns;
        assert DataOut = "0110" report "DataOut is wrong for input '0110011'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "0110" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "0000111";
        wait for 1 ns;
        assert DataOut = "0111" report "DataOut is wrong for input '0110100'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "0111" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "1111000";
        wait for 1 ns;
        assert DataOut = "1000" report "DataOut is wrong for input '1001011'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "1000" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "1001001";
        wait for 1 ns;
        assert DataOut = "1001" report "DataOut is wrong for input '1001100'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "1001" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "0101010";
        wait for 1 ns;
        assert DataOut = "1010" report "DataOut is wrong for input '1010010'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "1010" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "0011011";
        wait for 1 ns;
        assert DataOut = "1011" report "DataOut is wrong for input '1010101'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "1011" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "0011100";
        wait for 1 ns;
        assert DataOut = "1100" report "DataOut is wrong for input '1100001'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "1100" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "0101101";
        wait for 1 ns;
        assert DataOut = "1101" report "DataOut is wrong for input '1100110'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "1101" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "1001110";
        wait for 1 ns;
        assert DataOut = "1110" report "DataOut is wrong for input '1111000'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "1110" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "1111111";
        wait for 1 ns;
        assert DataOut = "1111" report "DataOut is wrong for input '1111111'" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 6 loop
            DataIn(i) <= not DataIn(i);
            wait for 1 ns;
            assert DataOut = "1111" report "DataOut is wrong for noisy input" severity error;
            DataIn(i) <= not DataIn(i);
        end loop;
    end process;

end architecture;
