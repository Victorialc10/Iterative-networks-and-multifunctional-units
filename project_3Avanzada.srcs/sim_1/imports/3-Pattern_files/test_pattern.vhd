LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;
 
ENTITY test_pattern IS
END test_pattern;
 
ARCHITECTURE behavior OF test_pattern IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT iterative_1D
    GENERIC( data_width:  natural := DATA_WIDTH;
	         count_width: natural := COUNT_WIDTH );
    PORT(
         din : IN  std_logic_vector(data_width - 1 downto 0);
         num_patterns : OUT  std_logic_vector(count_width - 1 downto 0)
        );
    END COMPONENT;

    --Inputs
    signal din1 : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal din2 : std_logic_vector(9 downto 0);

    --Outputs
    signal num_patterns1 : std_logic_vector(COUNT_WIDTH-1 downto 0);
    signal num_patterns2 : std_logic_vector(4 downto 0);
    
BEGIN

	-- Instantiate the Unit Under Test (UUT1)
    -- Default parameters
    uut_1: iterative_1D 
        PORT MAP (
            din => din1,
            num_patterns => num_patterns1
            );
            
	-- Instantiate the Unit Under Test (UUT2)
    uut_2: iterative_1D 
        GENERIC MAP (data_width => 10, count_width => 5)
        PORT MAP (
            din => din2,
            num_patterns => num_patterns2
            );
 
    -- Stimulus process
    stim_proc: process
    begin		
        din1 <=  "01111011";   --Two non-overlapping patterns
        din2 <= "0011110110";  --Two non-overlapping patterns
        wait for 50 ns;
        assert unsigned(num_patterns1)=2
            report "Error with din1, got " & integer'image(to_integer(unsigned(num_patterns1))) & " patterns instead of 2"
            severity error;
        assert unsigned(num_patterns2)=2
            report "Error with din2, got " & integer'image(to_integer(unsigned(num_patterns2))) & " patterns instead of 2"
            severity error;
        wait for 50 ns;

        din1 <=  "01111100";   --One non-overlapping pattern
        din2 <= "0011111000";  --One non-overlapping pattern
        wait for 50 ns;
        assert unsigned(num_patterns1)=1
            report "Error with din1, got " & integer'image(to_integer(unsigned(num_patterns1))) & " patterns instead of 2"
            severity error;
        assert unsigned(num_patterns2)=1
            report "Error with din2, got " & integer'image(to_integer(unsigned(num_patterns2))) & " patterns instead of 2"
            severity error;
        wait for 50 ns;

        din1 <=  "01010101";   --Two non-overlapping patterns
        din2 <= "0001010101";  --Two non-overlapping patterns
        wait for 50 ns;
        assert unsigned(num_patterns1)=2
            report "Error with din1, got " & integer'image(to_integer(unsigned(num_patterns1))) & " patterns instead of 2"
            severity error;
        assert unsigned(num_patterns2)=2
            report "Error with din1, got " & integer'image(to_integer(unsigned(num_patterns2))) & " patterns instead of 2"
            severity error;
        wait for 50 ns;

        wait;
    end process;
END;
