----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2024 05:16:22 PM
-- Design Name: 
-- Module Name: Receiver - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ethController is
    Port (  
        CLK : in std_logic;
        RBYTEP : out std_logic;
        RENABLE : in std_logic; 
        TABORTP : in std_logic;
        TAVAILP : in std_logic;
        RESET : in std_logic;
        RDATAI : in std_logic_vector(7 downto 0);
        TDATA : in std_logic_vector(7 downto 0);
        RCLEANP : out std_logic;
        RCVNGP : out std_logic; -- added a missing semicolon
        RDONEP : out std_logic;
        RSMATIP : out std_logic;
        RSTARTP : out std_logic;
        TDONEP : out std_logic;
        TFINISH : out std_logic;
        TREADP : out std_logic;
        TRNSMTP : out std_logic ;
        TSTART : out std_logic;
        TSOCOLP : out std_logic;
        TDATAO : out std_logic_vector(7 downto 0);
        RDATA : out std_logic_vector(7 downto 0)
    );
end ethController;

architecture Behavioral of ethController is
    signal NODADDRI : std_logic_vector(47 downto 0) := x"AABBCCDDEEFF" ;
    constant SED : std_logic_vector(7 downto 0) := "10101011";
    signal s_count : natural range 1 to 8 := 1;
    signal receiving_aux : std_logic := '0';
    
begin
    process
    begin
        wait until CLK'Event and CLK='1';
        if (s_count = 8) then 
            s_count <= 1;
        else 
            s_count <= s_count+1;
        end if;

        if (s_count = 0) then 
            RBYTEP <= '1';  
        elsif (s_count = 1) then 
            RBYTEP <= '0';
        end if;
        
        if (RESET = '1') then 
            RBYTEP <=  '0'; 
            RCLEANP <= '1'; 
            receiving_aux <= '0';
            wait until CLK'Event; 
            RCLEANP <= '0';
        else 
            if ((receiving_aux= '0') and (SED /= RDATAI)) then 
                RBYTEP <=  '0'; 
                RCLEANP <= '1';
                
            else 
                receiving_aux <= '1';
                wait until CLK'Event and s_count = 1;
                if ((receiving_aux= '1') and (NODADDRI(47 downto 40) /= RDATAI)) then 
                    RBYTEP <=  '0'; 
                    RCLEANP <= '1';
                    receiving_aux <='0';
                else 
                wait until CLK'Event and s_count = 1;
                    if ((receiving_aux= '1') and (NODADDRI(39 downto 32) /= RDATAI)) then 
                        RBYTEP <=  '0'; 
                        RCLEANP <= '1';
                        receiving_aux <='0';
                    else
                        wait until CLK'Event and s_count = 1; 
                        if ((receiving_aux= '1') and (NODADDRI(31 downto 24) /= RDATAI)) then 
                            RBYTEP <=  '0'; 
                            RCLEANP <= '1';
                            receiving_aux <='0';
                        else 
                            wait until CLK'Event and s_count = 1; 
                            if ((receiving_aux= '1')and (NODADDRI(23 downto 16) /= RDATAI)) then 
                                RBYTEP <=  '0'; 
                                RCLEANP <= '1';
                                receiving_aux <='0';
                            else 
                                wait until CLK'Event and s_count = 1; 
                                if ((receiving_aux= '1') and (NODADDRI(15 downto 8) /= RDATAI)) then 
                                    RBYTEP <=  '0'; 
                                    RCLEANP <= '1';
                                    receiving_aux <='0';
                                else
                                    wait until CLK'Event and s_count =1; 
                                    if ((receiving_aux= '1') and (NODADDRI(7 downto 0) = RDATAI)) then 
                                        RSMATIP <= '1';
                                        RDATA <= RDATAI;
                                    else 
                                        RBYTEP <=  '0'; 
                                        RCLEANP <= '1';
                                        receiving_aux <= '0';
                                    end if;
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;

entity Receiver is
--  Port ( );
end Receiver;

architecture Behavioral of Receiver is

begin


end Behavioral;
