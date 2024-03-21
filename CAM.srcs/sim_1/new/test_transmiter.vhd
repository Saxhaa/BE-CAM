----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2024 03:11:57 PM
-- Design Name: 
-- Module Name: test_transmiter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_transmiter is
--  Port ( );
end test_transmiter;

architecture Behavioral of test_transmiter is

constant Clock_period : time := 10 ns;

component Transmiter is
        Port (  --Clock
            CLK : in std_logic;
                 
           
            -- Inputs
        TABORT : in std_logic;
        TAVAILP : in std_logic;
        TFINISHP : in std_logic;
        TLASTP : in std_logic;
        TDATAI : in std_logic_vector(7 downto 0);
        -- Outputs
        TDONEP : out std_logic; -- pulse
        TREADDP : out std_logic; -- pulse
        TRNSMTP : out std_logic;
        TSTARTP : out std_logic; -- pulse
        TDATAO : out std_logic_vector(7 downto 0)
           
);

end component;

constant ADDR1_T : std_logic_vector:=x"AABBCCDDEEFF";
constant ADDR2_T : std_logic_vector:=x"AAAAAAAAAAAA"; 
signal CLK_T : std_logic :='0';
                 
--entrées bit
signal TABORT_T : std_logic :='0';
signal TAVAILP_T : std_logic := '0';
signal TFINISHP_T : std_logic := '0';
signal TLASTP_T : std_logic := '0';
-------bus enntrées
signal TDATAI_T : std_logic_vector(7 downto 0);
signal TDONEP_T : std_logic :='0';
signal TRNSMTP_T : std_logic := '0';
signal TSTARTP_T : std_logic := '0';
signal TDATAO_T :  std_logic_vector(7 downto 0);



begin
    
     Label_uut: Transmiter PORT MAP ( 
               CLK => CLK_T,
               TABORT => TABORT_T,
               TAVAILP => TAVAILP_T,
               TFINISHP => TFINISHP_T,
               TLASTP => TLASTP_T,
               TDATAI => TDATAI_T,
               TDONEP => TDONEP_T,
               TRNSMTP => TRNSMTP_T,
               TSTARTP => TSTARTP_T,
               TDATAO =>  TDATAO_T
             
    );


Clock_process : 
process
begin
CLK_T <= not(CLK_T);
    wait for Clock_period/2;
end process;

TAVAILP_T <= '1' after 20 ns, '0' after 100 ns;
TABORT_T <= '1' after 300 ns;
TDATAI_T <="10101011" after 20 ns,x"AB" after 100 ns, x"CD" after 180 ns, x"EF" after 260 ns, x"AB" after 340 ns, x"CD" after 420 ns, x"EF" after 500 ns, x"EE" after 580ns, x"50" after 980ns , x"70" after 1060 ns, x"50" after 1140 ns, x"50" after 1220 ns, x"BB" after 1300 ns, x"CD" after 1380 ns;
TFINISHP_T <= '1' after 1140 ns;
end Behavioral;
