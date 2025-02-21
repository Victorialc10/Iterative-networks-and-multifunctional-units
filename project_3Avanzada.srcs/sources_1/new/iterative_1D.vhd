library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use work.definitions.ALL; -- Incluye la definición de CELL_STATE y COUNT_WIDTH

entity iterative_1D is
    generic(
        data_width : natural := DATA_WIDTH; -- Tamaño del vector de datos de entrada
        count_width : natural := COUNT_WIDTH -- Tamaño del contador
    );
    port(
        din         : in std_logic_vector(data_width-1 downto 0); -- Entrada de datos
        num_patterns : out std_logic_vector(count_width-1 downto 0) -- Salida con el número total de patrones detectados
    );
end iterative_1D;

architecture Behavioral of iterative_1D is

    component state_cell is
        generic(width: natural := COUNT_WIDTH);
        port(
            din         : in std_logic;
            pattern_in  : in std_logic_vector(1 downto 0); -- tiene din(i-1) y din(i-2)
            pattern_out : out std_logic_vector(1 downto 0); -- pasa din(i) y din(i-1) a la siguiente celda
            state_in    : in CELL_STATE;
            state_out   : out CELL_STATE;
            count_in    : in std_logic_vector(width-1 downto 0); -- contador de patrones
            count_out   : out std_logic_vector(width-1 downto 0) -- contador +1 si hay patrón
        );
    end component;
    
    -- Señales internas para gestionar el estado, patrones y contadores entre las celdas
    type t_pattern_vector is array(0 to data_width) of std_logic_vector(1 downto 0);
    signal pattern : t_pattern_vector; -- Array de patrones intermedios

    type t_state_vector is array(0 to data_width) of CELL_STATE;
    signal state : t_state_vector; -- Array de estados intermedios

    type t_count_vector is array(0 to data_width) of std_logic_vector(count_width-1 downto 0);
    signal count : t_count_vector; -- Array de contadores intermedios

begin
    -- Condiciones iniciales
    pattern(0) <= "00"; -- Inicializamos el primer patrón como "00" para no contar
    count(0) <= (others => '0'); -- Inicializamos el contador en 0
    state(0) <= DONT_1ST; -- Inicializamos el primer estado en LOOK

    -- Instanciación de las celdas de la red iterativa
    iterative_network: for i in 0 to data_width-1 generate
        i_cell: state_cell
            generic map(width => count_width)
            port map(
                din         => din(i),
                pattern_in  => pattern(i),         -- Conecta con los bits previos
                pattern_out => pattern(i+1),       -- Conecta con la siguiente celda
                state_in    => state(i),           -- Estado actual
                state_out   => state(i+1),         -- Estado siguiente
                count_in    => count(i),           -- Contador actual
                count_out   => count(i+1)          -- Contador siguiente
            );
    end generate iterative_network;
    
    -- La salida num_patterns toma el valor final del contador
    num_patterns <= count(data_width);
end Behavioral;
