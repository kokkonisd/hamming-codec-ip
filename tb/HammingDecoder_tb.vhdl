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
    signal BlockSize : integer          := 8;
    signal DataIn    : std_logic_vector (7 downto 0);
    signal DataOut   : std_logic_vector (3 downto 0);
    signal ErrorCode : std_logic;
begin

    T0: entity work.HammingDecoder(default) generic map (BlockSize) port map (DataIn, DataOut, ErrorCode);

    test: process
    begin
        DataIn <= "00000000";
        wait for 1 us;
        assert DataOut = "0000" report "DataOut is wrong for input '00000000'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "0000" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "00001111";
        wait for 1 us;
        assert DataOut = "0001" report "DataOut is wrong for input '00001111'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "0001" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "00110011";
        wait for 1 us;
        assert DataOut = "0010" report "DataOut is wrong for input '00110011'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "0010" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "00111100";
        wait for 1 us;
        assert DataOut = "0011" report "DataOut is wrong for input '00111100'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "0011" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "01010101";
        wait for 1 us;
        assert DataOut = "0100" report "DataOut is wrong for input '01010101'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "0100" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "01011010";
        wait for 1 us;
        assert DataOut = "0101" report "DataOut is wrong for input '01011010'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "0101" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "01100110";
        wait for 1 us;
        assert DataOut = "0110" report "DataOut is wrong for input '01100110'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "0110" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "01101001";
        wait for 1 us;
        assert DataOut = "0111" report "DataOut is wrong for input '01101001'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "0111" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "10010110";
        wait for 1 us;
        assert DataOut = "1000" report "DataOut is wrong for input '10010110'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "1000" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "10011001";
        wait for 1 us;
        assert DataOut = "1001" report "DataOut is wrong for input '10011001'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "1001" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "10100101";
        wait for 1 us;
        assert DataOut = "1010" report "DataOut is wrong for input '10100101'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "1010" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "10101010";
        wait for 1 us;
        assert DataOut = "1011" report "DataOut is wrong for input '10101010'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "1011" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "11000011";
        wait for 1 us;
        assert DataOut = "1100" report "DataOut is wrong for input '11000011'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "1100" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "11001100";
        wait for 1 us;
        assert DataOut = "1101" report "DataOut is wrong for input '11001100'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "1101" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;            

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "11110000";
        wait for 1 us;
        assert DataOut = "1110" report "DataOut is wrong for input '11110000'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "1110" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;


        DataIn <= "11111111";
        wait for 1 us;
        assert DataOut = "1111" report "DataOut is wrong for input '11111111'" severity error;
        assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;

        -- Test resiliency by flipping every bit once
        for i in 0 to 7 loop
            -- Flip bit
            DataIn(i) <= not DataIn(i);
            wait for 1 us;
            assert DataOut = "1111" report "DataOut is wrong for simple noisy input" severity error;
            assert ErrorCode = '0' report "Error code should be OK for simple noisy input" severity error;
            
            -- Add more noise, should fail
            for j in 0 to 7 loop
                if (j /= i) then
                    -- Flip bit
                    DataIn(j) <= not DataIn(j);
                    wait for 1 us;
                    assert DataOut = "UUUU" report "DataOut is wrong for complex noisy input" severity error;
                    assert ErrorCode = '1' report "Error code should be KO for complex noisy input" severity error;
                    -- Un-flip bit
                    DataIn(j) <= not DataIn(j);
                end if;
            end loop;

            -- Un-flip bit
            DataIn(i) <= not DataIn(i);
        end loop;
    end process;

end architecture;
