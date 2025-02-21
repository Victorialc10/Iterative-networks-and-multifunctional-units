library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package definitions is
   constant DATA_WIDTH  : natural := 8;
   constant COUNT_WIDTH : natural := 3;
   type CELL_STATE is (LOOK, DONT_1ST, DONT_2ND);
end package definitions;