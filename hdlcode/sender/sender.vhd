-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\MVB3sender\sender.vhd
-- Created: 2015-01-20 16:27:43
-- 
-- Generated by MATLAB 8.2 and HDL Coder 3.3
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 160
-- Target subsystem base rate: 160
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        160
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- acceptSignal                  ce_out        160
-- Out1                          ce_out        160
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: sender
-- Source Path: MVB3sender/sender
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY sender IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        In1                               :   IN    std_logic;
        sendSFSign                        :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        BA                                :   IN    std_logic;
        ce_out                            :   OUT   std_logic;
        acceptSignal                      :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        Out1                              :   OUT   std_logic_vector(31 DOWNTO 0)  -- uint32
        );
END sender;


ARCHITECTURE rtl OF sender IS

  -- Component Declarations
  COMPONENT sender_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_const_rate                  :   IN    std_logic;
          BA                              :   IN    std_logic;
          sendSFSignal                    :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          CLK_1                           :   IN    std_logic;
          DataOut                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- uint32
          acceptSignal                    :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
          );
  END COMPONENT;

  COMPONENT Unit_Delay1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          In1                             :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          Out_rsvd                        :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
          );
  END COMPONENT;

  COMPONENT Unit_Delay
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          In1                             :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
          Out_rsvd                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- uint32
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : sender_block
    USE ENTITY work.sender_block(rtl);

  FOR ALL : Unit_Delay1
    USE ENTITY work.Unit_Delay1(rtl);

  FOR ALL : Unit_Delay
    USE ENTITY work.Unit_Delay(rtl);

  -- Signals
  SIGNAL sender_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL sender_out2                      : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL not_ascii                        : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL not_ascii_1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  u_sender : sender_block
    PORT MAP( clk => clk,
              reset => reset,
              enb_const_rate => clk_enable,
              BA => BA,
              sendSFSignal => sendSFSign,  -- uint8
              CLK_1 => In1,
              DataOut => sender_out1,  -- uint32
              acceptSignal => sender_out2  -- uint8
              );

  u_Unit_Delay1 : Unit_Delay1
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              In1 => sender_out2,  -- uint8
              Out_rsvd => not_ascii  -- uint8
              );

  u_Unit_Delay : Unit_Delay
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              In1 => sender_out1,  -- uint32
              Out_rsvd => not_ascii_1  -- uint32
              );

  ce_out <= clk_enable;

  acceptSignal <= not_ascii;

  Out1 <= not_ascii_1;

END rtl;

