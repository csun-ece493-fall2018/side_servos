library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clkFreqDivider is
    Generic ( originalFreq_Hz : integer;
              desiredFreq_Hz :integer);
    Port ( clkIn : in STD_LOGIC;
           rst : in STD_LOGIC;
           clkOut : out STD_LOGIC);
end clkFreqDivider;

architecture Behavioral of clkFreqDivider is

    signal scale : integer := originalFreq_Hz / desiredFreq_Hz;
    signal count : integer := 1;
    signal clkSignal : STD_LOGIC := '0';

begin

    clkOut <= clkSignal;
    
    process (clkIn, rst)
    begin
        if (rst = '1') then
            count <= 1;
            clkSignal <= '0';
        elsif (rising_edge(clkIn)) then
            if (count = scale / 2) then
                clkSignal <= not clkSignal;
                count <= 1;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

end Behavioral;
