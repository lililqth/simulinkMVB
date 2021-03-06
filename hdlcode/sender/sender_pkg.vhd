-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\MVB3sender\sender_pkg.vhd
-- Created: 2015-01-20 16:27:43
-- 
-- Generated by MATLAB 8.2 and HDL Coder 3.3
-- 
-- -------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE sender_pkg IS
  TYPE vector_of_unsigned16 IS ARRAY (NATURAL RANGE <>) OF unsigned(15 DOWNTO 0);
  TYPE vector_of_unsigned13 IS ARRAY (NATURAL RANGE <>) OF unsigned(12 DOWNTO 0);
  TYPE vector_of_unsigned5 IS ARRAY (NATURAL RANGE <>) OF unsigned(4 DOWNTO 0);
  TYPE T_state_type_is_sender IS (IN_sendInfo, IN_sendOK, IN_sendRandomSF, IN_transmission, IN_wait);
  TYPE T_state_type_is_sendHolder IS (IN_empty, IN_full, IN_judge);
  TYPE T_state_type_b_is_sender IS (IN_sleep, b_IN_transmission, b_IN_wait);
  TYPE T_state_type_b_is_sendHolder IS (IN_empty, IN_full, IN_judge);
  TYPE T_state_type_is_BAHolder IS (IN_false, IN_true);
END sender_pkg;

