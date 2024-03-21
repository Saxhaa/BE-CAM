----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2024 05:56:37 PM
-- Design Name: 
-- Module Name: Test_ethernet - Behavioral
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

entity test_ethernet is
end test_ethernet;


architecture behavioral of test_ethernet is
   
    constant Clock_period : time := 10 ns;

    component Receiver is
        Port (  --Clock
            CLK : in std_logic;
                 
            --entrées bit
            RESETN : in std_logic;
            RENABLE : in std_logic;
            -------bus enntrées
            RDATAI : in std_logic_vector(7 downto 0);
           
            --sorties bit
            RCVNGP : out std_logic; 
            RCLEANP : out std_logic;
            RSTARTP : out std_logic;
            RSMATIP : out std_logic;
            RBYTEP : out std_logic;
            RDATAO : out std_logic_vector(7 downto 0)
            ---------bus sorties
);
           
end component;

--input 
constant ADDR1_T : std_logic_vector:=x"AABBCCDDEEFF";
constant ADDR2_T : std_logic_vector:=x"AAAAAAAAAAAA"; 
signal CLK_T : std_logic :='0';
                 
--entrées bit
signal RBYTEP_T : std_logic :='0';
signal RENABLE_T : std_logic := '0';
signal RESETN_T : std_logic := '1';
-------bus enntrées
signal RDATAI_T : std_logic_vector(7 downto 0);
--sorties
signal RCVNGP_T : std_logic := '0';
signal RCLEANP_T :  std_logic := '0';
signal RSTARTP_T :  std_logic := '0';
signal RSMATIP_T :  std_logic := '0';
signal RDATAO_T :  std_logic_vector(7 downto 0);

begin

    Label_uut: Receiver PORT MAP ( 
               CLK => CLK_T,
               RESETN => RESETN_T,
               RDATAI => RDATAI_T,
               RBYTEP => RBYTEP_T,
               RCVNGP => RCVNGP_T,
               RENABLE => RENABLE_T,
               RSTARTP => RSTARTP_T,
               RSMATIP => RSMATIP_T,
               RDATAO => RDATAO_T
    );


Clock_process : 
process
begin
CLK_T <= not(CLK_T);
    wait for Clock_period/2;
end process;

RENABLE_T <= '1';
resetn_t <= '0', '1' after 20 ns ;

RDATAI_T <="10101011",x"AA" after 100 ns, x"BB" after 180 ns, x"CC" after 260 ns, x"DD" after 340 ns, x"EE" after 420 ns, x"FF" after 500 ns, x"EE" after 580ns , x"EE" after 660 ns, x"AB" after 740 ns, x"AA" after 900 ns, x"BB" after 980 ns, x"CD" after 1060 ns;

end behavioral;
