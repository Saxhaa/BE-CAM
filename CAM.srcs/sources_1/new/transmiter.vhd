----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2024 12:54:21 PM
-- Design Name: 
-- Module Name: transmiter - Behavioral
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

entity transmiter is
Port (  
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
end transmiter;

architecture Behavioral of transmiter is
    signal NODADDRI : std_logic_vector(47 downto 0) := x"AABBCCDDEEFF" ;
    constant ABORT : std_logic_vector(7 downto 0) := "10101010";
    signal s_count : integer range 0 to 7 := 0;
    signal abort_count : integer range 0 to 3;
    signal counter_byte : integer := 11;
    constant SFD : std_logic_vector(7 downto 0) := "10101011";
    constant EFD : std_logic_vector(7 downto 0) := "10101011";
    signal TRNSMTP_aux : std_logic;
    signal EndAddress : std_logic;
begin
    process
    begin
         wait until CLK'Event and CLK='1'; --synchro
         TDONEP <= '0';
         TREADDP <= '0';
         TSTARTP <= '0';
         
         TRNSMTP <= TRNSMTP_aux;
         if (s_count = 0) then
         s_count <= s_count + 1;
         
            if TAVAILP = '1' then
                TRNSMTP_aux <= '1';
                TSTARTP <= '1';
                TDATAO <= SFD;
                EndAddress <= '0';
            end if;
            if TRNSMTP_aux = '1' then
            -- transmission ongoing
                if (TABORT = '1') or (abort_count /= 0) then
                -- transmit 32 bit of alternating ones and zeros
                    TDATAO <= ABORT;
                    if (abort_count = 3) then
                        abort_count<=0;
                        TRNSMTP_aux <= '0';
                        counter_byte <= 11;
                        TDONEP <= '1';
                    else 
                        abort_count <= abort_count +1;
                    end if; 
                -- forces an invalid end of frame
                elsif EndAddress='0' then
                   if counter_byte >= 6 then
                        TDATAO <= TDATAI;
                        counter_byte <= counter_byte-1;
                        TREADDP <= '1';
                   else
                        TDATAO <= NODADDRI(7+8*counter_byte downto 8*counter_byte);
                        TREADDP <= '1';
                        if (counter_byte = 0) then
                            counter_byte <= 11;
                            EndAddress <= '1';
                        else
                            counter_byte <= counter_byte - 1 ;
                        end if;
                    end if;
                elsif TFINISHP = '0' then
                    TDONEP <= '1';
                    TDATAO <= TDATAI;
                    TREADDP <= '1';                   
                elsif TFINISHP = '1' then
                    TRNSMTP_aux <= '0';
                    TDATAO <= EFD;
                    TDONEP <= '1'; 
                end if;
           end if;
        else 
            if (s_count = 7) then 
                    s_count <= 0;
                else
                   s_count <= s_count +1;
            end if;
        end if;
    end process;
end Behavioral;
