library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use work.definitions.all;

-- Entidad state_cell
entity state_cell is
    generic(width: natural := COUNT_WIDTH);
    port(
        din         : in std_logic;
        pattern_in  : in std_logic_vector(1 downto 0); -- contiene din(i-1) y din(i-2)
        pattern_out : out std_logic_vector(1 downto 0); -- pasa din(i) y din(i-1) a la siguiente celda
        state_in    : in CELL_STATE;
        state_out   : out CELL_STATE;
        count_in    : in std_logic_vector(width-1 downto 0); -- contador de patrones
        count_out   : out std_logic_vector(width-1 downto 0) -- contador +1 si hay patrón
    );
end state_cell;

architecture Behavioral of state_cell is
begin
    process(din, pattern_in, state_in, count_in)
    begin
        -- Actualizamos pattern_out para la siguiente celda
        pattern_out(0) <= din; -- din(i)
        pattern_out(1) <= pattern_in(0); -- din(i-1)

        -- Control de estados para evitar solapamientos
        case state_in is
            when LOOK =>
                -- Detectamos patrón "1X1" o "0X0"
                if ((pattern_in(1) = '1' and din = '1') or (pattern_in(1) = '0' and din = '0')) then
                    count_out <= std_logic_vector(unsigned(count_in) + 1); -- Incrementa el contador
                    state_out <= DONT_1ST; -- Cambia el estado para evitar solapamiento
                    --pattern_out <= "00"; -- Reset de pattern_out para evitar solapamiento
                else
                    count_out <= count_in; -- No se detecta patrón, mantiene el contador
                    state_out <= LOOK; -- Mantiene el estado en LOOK
                end if;

            when DONT_1ST =>
                count_out <= count_in; -- No cambia el contador
                state_out <= DONT_2ND; -- Pasa al siguiente estado

            when DONT_2ND =>
                count_out <= count_in; -- No cambia el contador
                state_out <= LOOK; -- Regresa al estado LOOK
        end case;
    end process;
end Behavioral;
