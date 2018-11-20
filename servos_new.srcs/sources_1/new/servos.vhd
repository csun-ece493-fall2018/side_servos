library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servos is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (6 DOWNTO 0);
           pwm_left : out STD_LOGIC;
           pwm_right: out STD_LOGIC;
           left_servo_angle : out std_logic_vector (7 downto 0);
           right_servo_angle : out std_logic_vector (7 downto 0));
end servos;

architecture Behavioral of servos is

function rightServo(X : integer range 0 to 90)
              return integer is
  variable countRight : integer;
begin
    countRight := 150000 - (150000-66133)*X/90;
    return countRight;
end rightServo;

function leftServo(X : integer range 0 to 90)
              return integer is
  variable countLeft : integer;
begin
    countLeft := 150000 + (248667-150000)*X/90;
    return countLeft;
end leftServo;

component clkFreqDivider is
    Generic ( originalFreq_Hz : integer;
              desiredFreq_Hz :integer);
    Port ( clkIn : in STD_LOGIC;
           rst : in STD_LOGIC;
           clkOut : out STD_LOGIC);
end component;
    
signal max_count : INTEGER := 2000000;
signal count_mid_90: INTEGER := 211667;
signal count_mid_neg_90: INTEGER :=  88333;
signal count_0: INTEGER := 150000;--0 left
signal count_left_var : integer := 0;
signal count_right_var : integer := 0;
signal count_left_val : integer := 0;
signal count_right_val : integer := 0;
signal clk_40Hz : std_logic := '0';
signal count_right : integer:= 0;
signal count_left : integer := 0;
signal clk_50Hz : std_logic := '0';

begin

uut : clkFreqDivider 
    generic map(originalFreq_Hz => 100000000, desiredFreq_Hz => 50)
    port map (clkIn => clk, rst => rst, clkOut => clk_50Hz);
    
count_right <= rightServo(to_integer(unsigned(SW)));
count_left <= leftServo(to_integer(unsigned(SW)));

count_right_var <= count_0 when rst = '1' else count_right;
count_left_var <= count_0 when rst = '1' else count_left;

process (clk,count_right_var)                                    ----right servo
begin
    if(clk'event and clk= '1') then 
        if(count_right_val < count_right_var) then
            pwm_right <= '1';
            count_right_val <= count_right_val +1 ;
        elsif(count_right_val >= max_count) then
            count_right_val <= 0;
        elsif(count_right_val >= count_right_var and count_right_val < max_count ) then
            pwm_right <= '0';
            count_right_val <= count_right_val + 1;
        end if;
    end if;
end process;

process (clk,count_left_var)                                    ----left servo
begin
    if(clk'event and clk= '1') then 
        if(count_left_val < count_left_var) then
            pwm_left <= '1';
            count_left_val <= count_left_val +1 ;
        elsif(count_left_val >= max_count) then
            count_left_val <= 0 ;
        elsif(count_left_val >= count_left_var and count_left_val < max_count ) then
            pwm_left <= '0';
            count_left_val <= count_left_val + 1;
        end if;
    end if;
end process;

process(clk_50Hz,rst)
begin
    if(rst = '1') then
        left_servo_angle <= (others => '0');
        right_servo_angle <= (others => '0');
    elsif(clk_50Hz'event and clk_50Hz = '1') then
        left_servo_angle <= std_logic_vector(to_unsigned((count_left_val-150000)/1096,8));
        right_servo_angle <= std_logic_vector(to_unsigned((150000-count_right_val)/932,8));
    end if;
end process;
end Behavioral;