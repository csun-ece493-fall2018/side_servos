library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servos is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (7 DOWNTO 0);
           pwm_left : out STD_LOGIC;
           pwm_right: out STD_LOGIC);  --pulse width for center servo
end servos;

architecture Behavioral of servos is

component clkFreqDivider is
    Generic ( originalFreq_Hz : integer;
              desiredFreq_Hz :integer);
    Port ( clkIn : in STD_LOGIC;
           rst : in STD_LOGIC;
           clkOut : out STD_LOGIC);
end component;


function rightServo(X : integer range 0 to 90)
              return integer is
  variable countRight : integer;
begin
  countRight := 39000 + (150000-39000)*X/90;
    return countRight;
end rightServo;


function leftServo(X : integer range 0 to 90)
              return integer is
  variable countLeft : integer;
begin
  countLeft := 150000 + (261000-150000)*X/90;
    return countLeft;
end leftServo;

signal max_count : INTEGER := 2000000;
signal count_mid_90: INTEGER := 211667;
signal count_mid_neg_90: INTEGER :=  88333;
signal count_0: INTEGER := 150000;--0 left

signal count_left_var : integer := 0;
signal count_right_var : integer := 0;


signal clk_40Hz : std_logic := '0';
signal count_right : integer:= 0;
signal count_left : integer := 0;
begin

count_right <= rightServo(to_integer(unsigned(SW)));
count_left <= leftServo(to_integer(unsigned(SW)));

uut : clkFreqDivider 
    generic map(originalFreq_Hz => 100000000, desiredFreq_Hz => 5)
    port map (clkIn => clk, rst => rst, clkOut => clk_40Hz);
    
process (clk,count_right)                                    ----right servo
begin
    if(clk'event and clk= '1') then 
        if(count_right_var < count_right) then
            pwm_right <= '1';
            count_right_var <= count_right_var +1 ;
        elsif(count_right_var >= max_count) then
            count_right_var <= 0 ;
        elsif(count_right_var >= count_right and count_right_var < max_count ) then
            pwm_right <= '0';
            count_right_var <= count_right_var + 1;
        end if;
    end if;
end process;

process (clk,count_left)                                    ----left servo
begin
    if(clk'event and clk= '1') then 
        if(count_left_var < count_left) then
            pwm_left <= '1';
            count_left_var <= count_left_var +1 ;
        elsif(count_left_var >= max_count) then
            count_left_var <= 0 ;
        elsif(count_left_var >= count_left and count_left_var < max_count ) then
            pwm_left <= '0';
            count_left_var <= count_left_var + 1;
        end if;
    end if;
end process;



process(clk_40Hz, rst, count_right) begin
    if(rst = '1') then
        count_right_var <= 39000;
    elsif(clk_40Hz'event and clk_40Hz = '1') then
        if(count_right_var <= count_right) then
            count_right_var <= count_right_var + 3426;
        elsif(count_right_var > count_right) then
            count_right_var <= 0;
        end if;
    end if;
end process;

process(clk_40Hz, rst, count_left) begin
    if(rst = '1') then
        count_left_var <= 150000;
    elsif(clk_40Hz'event and clk_40Hz = '1') then
        if(count_left_var <= count_left) then
            count_left_var <= count_left_var + 3426;
        elsif(count_left_var > count_left) then
            count_left_var <= 0;
        end if;
    end if;
end process;
  
end Behavioral;