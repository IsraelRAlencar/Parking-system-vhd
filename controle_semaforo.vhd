library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity controle_semaforo is
    port (
        clock: in std_logic;
        alert: in std_logic;
        ledr: out std_logic_vector(17 downto 0);
        ledg: out std_logic_vector(17 downto 0)
    );
end entity;

architecture behavioral of controle_semaforo is
    type states is (RG, RY, GR, YR, YY);
    signal current_state: states;
    signal counter : natural := 0;

begin
    process (current_state)
    begin
        case current_state is
            when RG =>
                ledr(1 downto 0) <= "01";
                ledg(1 downto 0) <= "10";
            when RY =>
                ledr(1 downto 0) <= "11";
                ledg(1 downto 0) <= "10";
            when GR =>
                ledr(1 downto 0) <= "10";
                ledg(1 downto 0) <= "01";
            when YR =>
                ledr(1 downto 0) <= "11";
                ledg(1 downto 0) <= "01";
            when YY =>
                ledr(1 downto 0) <= "11";
                ledg(1 downto 0) <= "11";
            when others =>
                ledr(1 downto 0) <= "00";
                ledg(1 downto 0) <= "00";
        end case;
    end process;

    process (clock)
    begin
        if (rising_edge(clock)) then
            if (alert = '1') then
                current_state <= YY;
                counter <= 0;
            else
                case current_state is
                    when RG =>
                        if counter = 2500 then
                            current_state <= RY;
                            counter <= 0;
                        else
                            counter <= counter + 1;
                        end if;
                    when RY =>
                        if counter = 1500 then
                            current_state <= GR;
                            counter <= 0;
                        else
                            counter <= counter + 1;
                        end if;
                    when GR =>
                        if counter = 3000 then
                            current_state <= YR;
                            counter <= 0;
                        else
                            counter <= counter + 1;
                        end if;
                    when YR =>
                        if counter = 1500 then
                            current_state <= RG;
                            counter <= 0;
                        else
                            counter <= counter + 1;
                        end if;
                    when YY =>
                        if alert = '0' then
                            current_state <= RG;
                            counter <= 0;
                        else
                            counter <= counter + 1;
                        end if;
                    when others =>
                        counter <= 0;
                end case;
            end if;
        end if;
    end process;
end architecture;