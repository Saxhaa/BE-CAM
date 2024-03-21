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

entity Receiver is
    Port (  
        CLK : in std_logic;
        RBYTEP : out std_logic;
        RENABLE : in std_logic; 
        --TABORTP : in std_logic;
        --TAVAILP : in std_logic;
        RESETN : in std_logic;
        RDATAI : in std_logic_vector(7 downto 0);
        --TDATA : in std_logic_vector(7 downto 0);
        RCLEANP : out std_logic;
        RCVNGP : out std_logic; 
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
        RDATAO : out std_logic_vector(7 downto 0)
    );
end Receiver;

architecture Behavioral of Receiver is
    signal NODADDRI : std_logic_vector(47 downto 0) := x"AABBCCDDEEFF" ;
    constant SFD : std_logic_vector(7 downto 0) := "10101011";
    constant EFD : std_logic_vector(7 downto 0) := "10101011";
    constant FIN : std_logic_vector(7 downto 0) := x"FF";
    signal s_count : integer range 0 to 7 := 0;
    signal receiving_aux : std_logic := '0';
    signal RSMATIP_aux : std_logic := '0';
    signal counter_byte : integer;
    
    
begin
    process
    begin
        wait until CLK'Event and CLK='1'; --synchro
        RSTARTP <= '0';
        RBYTEP <= '0';
        RCLEANP <= '0';
        RDONEP <='0';
        
   
        RCVNGP <= receiving_aux;
        RSMATIP <= RSMATIP_aux;
        
        if (RESETN = '0') then 
            RBYTEP <=  '0';
            counter_byte <=5; 
            RCLEANP <= '1'; 
            receiving_aux <= '0';  
            
        else 
        
            if RENABLE = '1' then 
            
             if (s_count = 0) then 
                s_count <= s_count +1;  
                if ((receiving_aux= '0') and (SFD = RDATAI)) then 
                    RSTARTP <='1';
                    receiving_aux <= '1';
                    
                elsif (receiving_aux = '1') and (RSMATIP_aux = '0') then 
                    if NODADDRI(7+8*counter_byte downto 8*counter_byte) = RDATAI then
                        if (counter_byte = 0) then
                            counter_byte <= 5;
                            RSMATIP_aux <= '1';
                        else
                            counter_byte <= counter_byte - 1 ;
                        end if;
                    else 
                        receiving_aux <='0';
                        RCLEANP <='1';
                        counter_byte <= 5;
                    end if;
                elsif RSMATIP_aux = '1' then 
                    if RDATAI /= EFD then 
                        RDATAO <= RDATAI; 
                        RBYTEP <='1';
                    else 
                        RDONEP <= '1';
                        receiving_aux <= '0';             
                        RSMATIP_aux <= '0';
                        RDATAO <= FIN;
                    end if;
                
                
                end if;
               
             else
                if (s_count = 7) then 
                    s_count <= 0;
                else
                   s_count <= s_count +1;
                end if; 
             end if;
            end if;
          end if;  
    end process;
end Behavioral;

