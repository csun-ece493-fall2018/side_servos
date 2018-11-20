library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity servos_tb is
--  Port ( );
end servos_tb;

architecture Behavioral of servos_tb is

component servos is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sensor_angle : in STD_LOGIC_VECTOR (6 downto 0);
           pwm_left : out STD_LOGIC; --pulse width for left servo
           --pwm_mid : out STD_LOGIC;  --pulse width for center servo
           pwm_right : out STD_LOGIC); --pulse width for right servo
end component;


signal clk : STD_LOGIC;
signal rst : STD_LOGIC;
signal sensor_angle : STD_LOGIC_VECTOR (6 downto 0);
signal pwm_left : STD_LOGIC;
signal pwm_right : STD_LOGIC;

begin

uut: servos port map (clk => clk, rst => rst, sensor_angle => sensor_angle, pwm_left => pwm_left, pwm_right => pwm_right);

process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;

process
begin
    rst <= '1';
    wait for 10 ns;
    rst <= '0';
    wait;
end process;

process
begin
    sensor_angle <= "0000001";
    wait for 20 ms;
    sensor_angle <= "0000010";
    wait for 20 ms;
end process;

end Behavioral;
