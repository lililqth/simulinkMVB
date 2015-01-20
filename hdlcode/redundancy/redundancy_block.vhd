-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\MVB3three\redundancy_block.vhd
-- Created: 2015-01-20 16:25:46
-- 
-- Generated by MATLAB 8.2 and HDL Coder 3.3
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: redundancy_block
-- Source Path: redundancy/redundancy
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.redundancy_pkg.ALL;

ENTITY redundancy_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        In1                               :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        In2                               :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        CLK_1                             :   IN    std_logic;
        out_rsvd                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- uint32
        );
END redundancy_block;


ARCHITECTURE rtl OF redundancy_block IS

  -- Functions
  -- HDLCODER_TO_SIGNED
  FUNCTION hdlcoder_to_signed(arg: boolean; width: integer) RETURN signed IS
  BEGIN
    IF arg THEN
      RETURN to_signed(1, width);
    ELSE
      RETURN to_signed(0, width);
    END IF;
  END FUNCTION;

  -- HDLCODER_TO_UNSIGNED
  FUNCTION hdlcoder_to_unsigned(arg: real; width: integer) RETURN unsigned IS
  BEGIN
    RETURN to_unsigned(integer(arg), width);
  END FUNCTION;


  -- Signals
  SIGNAL enb_gated                        : std_logic;
  SIGNAL CLK_delayed                      : std_logic;
  SIGNAL CLK_emulated                     : std_logic;
  SIGNAL In1_unsigned                     : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL In2_unsigned                     : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL is_sign1                         : T_state_type_is_sign1;  -- uint8
  SIGNAL is_sign2                         : T_state_type_is_sign2;  -- uint8
  SIGNAL is_Timer1                        : T_state_type_is_Timer1;  -- uint8
  SIGNAL is_observer                      : T_state_type_is_observer;  -- uint8
  SIGNAL is_trans                         : T_state_type_is_trans;  -- uint8
  SIGNAL out_rsvd_1                       : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL trust                            : std_logic;
  SIGNAL sign1                            : std_logic;
  SIGNAL sign2                            : std_logic;
  SIGNAL buffer_rsvd                      : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL count                            : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL b_buffer                         : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL b_count                          : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL temporalCounter_i1               : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL is_sign1_next                    : T_state_type_is_sign1;  -- enumerated type (3 enums)
  SIGNAL is_sign2_next                    : T_state_type_is_sign2;  -- enumerated type (3 enums)
  SIGNAL is_Timer1_next                   : T_state_type_is_Timer1;  -- enumerated type (3 enums)
  SIGNAL is_observer_next                 : T_state_type_is_observer;  -- enumerated type (2 enums)
  SIGNAL is_trans_next                    : T_state_type_is_trans;  -- enumerated type (2 enums)
  SIGNAL trust_next                       : std_logic;
  SIGNAL sign1_next                       : std_logic;
  SIGNAL sign2_next                       : std_logic;
  SIGNAL buffer_next                      : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL count_next                       : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL b_buffer_next                    : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL b_count_next                     : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL temporalCounter_i1_next          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL out_last_value                   : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL out_bypass_1                     : unsigned(31 DOWNTO 0);  -- uint32

BEGIN
  CLK_delay_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      CLK_delayed <= '1';
    ELSIF clk'event AND clk = '1' THEN
      IF enb = '1' THEN
        CLK_delayed <= CLK_1;
      END IF;
    END IF;
  END PROCESS CLK_delay_process;

  CLK_emulated <= NOT CLK_delayed AND CLK_1;

  In1_unsigned <= unsigned(In1);

  In2_unsigned <= unsigned(In2);

  enb_gated <= CLK_emulated AND enb;

  redundancy_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      temporalCounter_i1 <= to_unsigned(2#00000000#, 8);
      sign1 <= '0';
      sign2 <= '0';
      is_sign1 <= IN_none;
      count <= to_unsigned(16#00000002#, 32);
      buffer_rsvd <= to_unsigned(16#00000001#, 32);
      is_sign2 <= IN_none;
      b_count <= to_unsigned(16#00000002#, 32);
      b_buffer <= to_unsigned(16#00000001#, 32);
      is_Timer1 <= IN_start;
      is_observer <= IN_A;
      trust <= '1';
      is_trans <= IN_A;
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_gated = '1' THEN
        is_sign1 <= is_sign1_next;
        is_sign2 <= is_sign2_next;
        is_Timer1 <= is_Timer1_next;
        is_observer <= is_observer_next;
        is_trans <= is_trans_next;
        trust <= trust_next;
        sign1 <= sign1_next;
        sign2 <= sign2_next;
        buffer_rsvd <= buffer_next;
        count <= count_next;
        b_buffer <= b_buffer_next;
        b_count <= b_count_next;
        temporalCounter_i1 <= temporalCounter_i1_next;
      END IF;
    END IF;
  END PROCESS redundancy_process;

  redundancy_output : PROCESS (is_sign1, is_sign2, is_Timer1, is_observer, is_trans, In1_unsigned,
       In2_unsigned, trust, sign1, sign2, buffer_rsvd, count, b_buffer, b_count,
       temporalCounter_i1)
    VARIABLE i : signed(31 DOWNTO 0);
    VARIABLE x0 : signed(31 DOWNTO 0);
    VARIABLE x1 : signed(31 DOWNTO 0);
    VARIABLE bitkm1 : unsigned(7 DOWNTO 0);
    VARIABLE bitkm1_0 : unsigned(7 DOWNTO 0);
    VARIABLE mask : signed(31 DOWNTO 0);
    VARIABLE mask_0 : signed(31 DOWNTO 0);
    VARIABLE r : std_logic;
    VARIABLE data : unsigned(15 DOWNTO 0);
    VARIABLE bit1 : unsigned(15 DOWNTO 0);
    VARIABLE bit2 : unsigned(15 DOWNTO 0);
    VARIABLE bit3 : unsigned(15 DOWNTO 0);
    VARIABLE bit4 : unsigned(15 DOWNTO 0);
    VARIABLE i_0 : signed(31 DOWNTO 0);
    VARIABLE x0_0 : signed(31 DOWNTO 0);
    VARIABLE x1_0 : signed(31 DOWNTO 0);
    VARIABLE bitkm1_1 : unsigned(7 DOWNTO 0);
    VARIABLE bitkm1_2 : unsigned(7 DOWNTO 0);
    VARIABLE mask_1 : signed(31 DOWNTO 0);
    VARIABLE mask_2 : signed(31 DOWNTO 0);
    VARIABLE r_0 : std_logic;
    VARIABLE data_0 : unsigned(15 DOWNTO 0);
    VARIABLE bit1_0 : unsigned(15 DOWNTO 0);
    VARIABLE bit2_0 : unsigned(15 DOWNTO 0);
    VARIABLE bit3_0 : unsigned(15 DOWNTO 0);
    VARIABLE bit4_0 : unsigned(15 DOWNTO 0);
    VARIABLE r_1 : std_logic;
    VARIABLE r_2 : std_logic;
    VARIABLE r_3 : std_logic;
    VARIABLE r_4 : std_logic;
    VARIABLE r_5 : std_logic;
    VARIABLE trust_temp : std_logic;
    VARIABLE sign1_temp : std_logic;
    VARIABLE sign2_temp : std_logic;
    VARIABLE buffer_temp : unsigned(31 DOWNTO 0);
    VARIABLE b_buffer_temp : unsigned(31 DOWNTO 0);
    VARIABLE temporalCounter_i1_temp : unsigned(7 DOWNTO 0);
    VARIABLE add_temp : unsigned(32 DOWNTO 0);
    VARIABLE add_cast : vector_of_signed35(0 TO 15);
    VARIABLE add_cast_0 : vector_of_unsigned6(0 TO 15);
    VARIABLE add_temp_0 : vector_of_unsigned6(0 TO 15);
    VARIABLE sub_cast : vector_of_unsigned6(0 TO 15);
    VARIABLE cast : std_logic;
    VARIABLE cast_0 : std_logic;
    VARIABLE cast_1 : std_logic;
    VARIABLE cast_2 : std_logic;
    VARIABLE sub_cast_0 : vector_of_unsigned6(0 TO 15);
    VARIABLE add_temp_1 : unsigned(32 DOWNTO 0);
    VARIABLE add_cast_1 : vector_of_signed35(0 TO 15);
    VARIABLE add_cast_2 : vector_of_unsigned6(0 TO 15);
    VARIABLE add_temp_2 : vector_of_unsigned6(0 TO 15);
    VARIABLE sub_cast_1 : vector_of_unsigned6(0 TO 15);
    VARIABLE cast_3 : std_logic;
    VARIABLE cast_4 : std_logic;
    VARIABLE cast_5 : std_logic;
    VARIABLE cast_6 : std_logic;
    VARIABLE sll_temp : vector_of_unsigned16(0 TO 15);
    VARIABLE sll_temp_0 : vector_of_unsigned16(0 TO 15);
    VARIABLE cast_7 : vector_of_unsigned16(0 TO 15);
    VARIABLE cast_8 : vector_of_unsigned16(0 TO 15);
    VARIABLE sub_cast_2 : vector_of_unsigned6(0 TO 15);
    VARIABLE sll_temp_1 : vector_of_unsigned16(0 TO 15);
    VARIABLE sll_temp_2 : vector_of_unsigned16(0 TO 15);
    VARIABLE cast_9 : vector_of_unsigned16(0 TO 15);
    VARIABLE cast_10 : vector_of_unsigned16(0 TO 15);
  BEGIN
    trust_temp := trust;
    sign1_temp := sign1;
    sign2_temp := sign2;
    buffer_temp := buffer_rsvd;
    b_buffer_temp := b_buffer;
    temporalCounter_i1_temp := temporalCounter_i1;
    is_sign1_next <= is_sign1;
    is_sign2_next <= is_sign2;
    is_Timer1_next <= is_Timer1;
    is_observer_next <= is_observer;
    is_trans_next <= is_trans;
    count_next <= count;
    b_count_next <= b_count;
    out_rsvd_1 <= to_unsigned(16#00000000#, 32);
    IF temporalCounter_i1 < 255 THEN 
      temporalCounter_i1_temp := temporalCounter_i1 + 1;
    END IF;

    CASE is_sign1 IS
      WHEN IN_judge =>
        IF buffer_rsvd(31 DOWNTO 16) /= X"0000" THEN 
          data := X"FFFF";
        ELSE 
          data := buffer_rsvd(15 DOWNTO 0);
        END IF;
        bit1 := hdlcoder_to_unsigned(data(0) /= '0', 16);
        bit2 := hdlcoder_to_unsigned(data(1) /= '0', 16);
        bit3 := hdlcoder_to_unsigned(data(2) /= '0', 16);
        bit4 := hdlcoder_to_unsigned(data(3) /= '0', 16);
        cast := bit1(0);
        cast_0 := bit2(0);
        cast_1 := bit3(0);
        cast_2 := bit4(0);
        IF (((cast = '1') AND (cast_0 = '1')) AND (cast_1 = '0')) AND (cast_2 = '0') THEN 
          r := '1';
        ELSE 
          r := '0';
        END IF;
        IF r = '1' THEN 
          sign1_temp := '0';
          is_sign1_next <= IN_none;
          count_next <= to_unsigned(16#00000002#, 32);
          buffer_temp := to_unsigned(16#00000001#, 32);
        ELSE 
          buffer_temp := to_unsigned(16#00000000#, 32);
          count_next <= to_unsigned(16#00000000#, 32);
          is_sign1_next <= IN_trans;
        END IF;
      WHEN IN_none =>
        IF In1_unsigned = 1 THEN 
          sign1_temp := '1';
          is_sign1_next <= IN_trans;
        END IF;
      WHEN OTHERS => 
        IF count = 32 THEN 
          buffer_temp := to_unsigned(16#00000000#, 32);

          FOR b_i IN 0 TO 15 LOOP
            add_cast(b_i) := resize(to_signed(b_i, 32) & '0', 35);
            add_cast_0(b_i) := unsigned(add_cast(b_i)(5 DOWNTO 0));
            add_temp_0(b_i) := add_cast_0(b_i) + 2;
            i := signed(resize(add_temp_0(b_i), 32));
            sub_cast(b_i) := unsigned(i(5 DOWNTO 0));
            bitkm1 := resize(sub_cast(b_i) - 2, 8);
            x0 := hdlcoder_to_signed(buffer_rsvd(to_integer(bitkm1)) /= '0', 32);
            sub_cast_0(b_i) := unsigned(i(5 DOWNTO 0));
            bitkm1_0 := resize(sub_cast_0(b_i) - 1, 8);
            x1 := hdlcoder_to_signed(buffer_rsvd(to_integer(bitkm1_0)) /= '0', 32);
            IF (x0 = 0) AND (x1 = 1) THEN 
              sll_temp_0(b_i) := to_unsigned(16#0001#, 16) sll to_integer(hdlcoder_to_unsigned(real(to_integer(i)) srl 1, 5) - 1);
              mask_0 := signed(resize(sll_temp_0(b_i), 32));
              cast_8(b_i) := unsigned(mask_0(15 DOWNTO 0));
              buffer_temp := buffer_temp OR resize(cast_8(b_i), 32);
            ELSE 
              sll_temp(b_i) := to_unsigned(16#0001#, 16) sll to_integer(hdlcoder_to_unsigned(real(to_integer(i)) srl 1, 5) - 1);
              mask := signed(resize(sll_temp(b_i), 32));
              cast_7(b_i) := unsigned(mask(15 DOWNTO 0));
              buffer_temp := buffer_temp AND ( NOT resize(cast_7(b_i), 32));
            END IF;
          END LOOP;

          is_sign1_next <= IN_judge;
        ELSE 
          --for i=1:cnt
          --   r = bitset(r, i, 0);
          --end
          add_temp := resize(buffer_rsvd sll 1, 33) + resize(In1_unsigned, 33);
          IF add_temp(32) /= '0' THEN 
            buffer_temp := X"FFFFFFFF";
          ELSE 
            buffer_temp := add_temp(31 DOWNTO 0);
          END IF;
          count_next <= count + 1;
        END IF;
    END CASE;


    CASE is_sign2 IS
      WHEN IN_judge =>
        IF b_buffer(31 DOWNTO 16) /= X"0000" THEN 
          data_0 := X"FFFF";
        ELSE 
          data_0 := b_buffer(15 DOWNTO 0);
        END IF;
        bit1_0 := hdlcoder_to_unsigned(data_0(0) /= '0', 16);
        bit2_0 := hdlcoder_to_unsigned(data_0(1) /= '0', 16);
        bit3_0 := hdlcoder_to_unsigned(data_0(2) /= '0', 16);
        bit4_0 := hdlcoder_to_unsigned(data_0(3) /= '0', 16);
        cast_3 := bit1_0(0);
        cast_4 := bit2_0(0);
        cast_5 := bit3_0(0);
        cast_6 := bit4_0(0);
        IF (((cast_3 = '1') AND (cast_4 = '1')) AND (cast_5 = '0')) AND (cast_6 = '0') THEN 
          r_0 := '1';
        ELSE 
          r_0 := '0';
        END IF;
        IF r_0 = '1' THEN 
          sign2_temp := '0';
          is_sign2_next <= IN_none;
          b_count_next <= to_unsigned(16#00000002#, 32);
          b_buffer_temp := to_unsigned(16#00000001#, 32);
        ELSE 
          b_buffer_temp := to_unsigned(16#00000000#, 32);
          b_count_next <= to_unsigned(16#00000000#, 32);
          is_sign2_next <= IN_trans;
        END IF;
      WHEN IN_none =>
        IF In2_unsigned = 1 THEN 
          sign2_temp := '1';
          is_sign2_next <= IN_trans;
        END IF;
      WHEN OTHERS => 
        IF b_count = 32 THEN 
          b_buffer_temp := to_unsigned(16#00000000#, 32);

          FOR b_i_0 IN 0 TO 15 LOOP
            add_cast_1(b_i_0) := resize(to_signed(b_i_0, 32) & '0', 35);
            add_cast_2(b_i_0) := unsigned(add_cast_1(b_i_0)(5 DOWNTO 0));
            add_temp_2(b_i_0) := add_cast_2(b_i_0) + 2;
            i_0 := signed(resize(add_temp_2(b_i_0), 32));
            sub_cast_1(b_i_0) := unsigned(i_0(5 DOWNTO 0));
            bitkm1_1 := resize(sub_cast_1(b_i_0) - 2, 8);
            x0_0 := hdlcoder_to_signed(b_buffer(to_integer(bitkm1_1)) /= '0', 32);
            sub_cast_2(b_i_0) := unsigned(i_0(5 DOWNTO 0));
            bitkm1_2 := resize(sub_cast_2(b_i_0) - 1, 8);
            x1_0 := hdlcoder_to_signed(b_buffer(to_integer(bitkm1_2)) /= '0', 32);
            IF (x0_0 = 0) AND (x1_0 = 1) THEN 
              sll_temp_2(b_i_0) := to_unsigned(16#0001#, 16) sll to_integer(hdlcoder_to_unsigned(real(to_integer(i_0)) srl 1, 5) - 1);
              mask_2 := signed(resize(sll_temp_2(b_i_0), 32));
              cast_10(b_i_0) := unsigned(mask_2(15 DOWNTO 0));
              b_buffer_temp := b_buffer_temp OR resize(cast_10(b_i_0), 32);
            ELSE 
              sll_temp_1(b_i_0) := to_unsigned(16#0001#, 16) sll to_integer(hdlcoder_to_unsigned(real(to_integer(i_0)) srl 1, 5) - 1);
              mask_1 := signed(resize(sll_temp_1(b_i_0), 32));
              cast_9(b_i_0) := unsigned(mask_1(15 DOWNTO 0));
              b_buffer_temp := b_buffer_temp AND ( NOT resize(cast_9(b_i_0), 32));
            END IF;
          END LOOP;

          is_sign2_next <= IN_judge;
        ELSE 
          --for i=1:cnt
          --   r = bitset(r, i, 0);
          --end
          add_temp_1 := resize(b_buffer sll 1, 33) + resize(In2_unsigned, 33);
          IF add_temp_1(32) /= '0' THEN 
            b_buffer_temp := X"FFFFFFFF";
          ELSE 
            b_buffer_temp := add_temp_1(31 DOWNTO 0);
          END IF;
          b_count_next <= b_count + 1;
        END IF;
    END CASE;


    CASE is_Timer1 IS
      WHEN IN_TimeOut =>
        is_Timer1_next <= IN_start;
      WHEN IN_Timer =>
        r_2 := '1';
        IF trust = '1' THEN 
          IF sign1_temp = '0' THEN 
            r_2 := '0';
          END IF;
        ELSIF sign2_temp = '0' THEN 
          r_2 := '0';
        END IF;
        IF r_2 = '1' THEN 
          is_Timer1_next <= IN_start;
        ELSE 
          r_3 := '1';
          IF trust = '1' THEN 
            IF sign1_temp = '0' THEN 
              r_3 := '0';
            END IF;
          ELSIF sign2_temp = '0' THEN 
            r_3 := '0';
          END IF;
          IF (temporalCounter_i1_temp >= 140) AND (r_3 = '0') THEN 
            is_Timer1_next <= IN_TimeOut;
            trust_temp := '0';
          END IF;
        END IF;
      WHEN OTHERS => 
        r_1 := '1';
        IF trust = '1' THEN 
          IF sign1_temp = '0' THEN 
            r_1 := '0';
          END IF;
        ELSIF sign2_temp = '0' THEN 
          r_1 := '0';
        END IF;
        IF r_1 = '0' THEN 
          is_Timer1_next <= IN_Timer;
          temporalCounter_i1_temp := to_unsigned(2#00000000#, 8);
        END IF;
    END CASE;


    CASE is_observer IS
      WHEN IN_A =>
        r_5 := '1';
        -- ���������1û���յ����ݶ�������2�յ���
        IF trust_temp = '1' THEN 
          IF (sign1_temp = '0') AND (sign2_temp = '1') THEN 
            r_5 := '0';
          END IF;
        ELSIF (sign2_temp = '0') AND (sign1_temp = '1') THEN 
          r_5 := '0';
        END IF;
        IF r_5 = '0' THEN 
          is_observer_next <= IN_B;
          trust_temp := '0';
        END IF;
      WHEN OTHERS => 
        r_4 := '1';
        -- ���������1û���յ����ݶ�������2�յ���
        IF trust_temp = '1' THEN 
          IF (sign1_temp = '0') AND (sign2_temp = '1') THEN 
            r_4 := '0';
          END IF;
        ELSIF (sign2_temp = '0') AND (sign1_temp = '1') THEN 
          r_4 := '0';
        END IF;
        IF r_4 = '0' THEN 
          is_observer_next <= IN_A;
          trust_temp := '1';
        END IF;
    END CASE;


    CASE is_trans IS
      WHEN IN_A =>
        IF trust_temp = '0' THEN 
          out_rsvd_1 <= In2_unsigned;
          is_trans_next <= IN_B;
        ELSE 
          out_rsvd_1 <= In1_unsigned;
        END IF;
      WHEN OTHERS => 
        IF trust_temp = '1' THEN 
          out_rsvd_1 <= In1_unsigned;
          is_trans_next <= IN_A;
        ELSE 
          out_rsvd_1 <= In2_unsigned;
        END IF;
    END CASE;

    trust_next <= trust_temp;
    sign1_next <= sign1_temp;
    sign2_next <= sign2_temp;
    buffer_next <= buffer_temp;
    b_buffer_next <= b_buffer_temp;
    temporalCounter_i1_next <= temporalCounter_i1_temp;
  END PROCESS redundancy_output;


  out_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      out_last_value <= to_unsigned(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_gated = '1' THEN
        out_last_value <= out_rsvd_1;
      END IF;
    END IF;
  END PROCESS out_bypass_process;


  
  out_bypass_1 <= out_last_value WHEN CLK_emulated = '0' ELSE
      out_rsvd_1;

  out_rsvd <= std_logic_vector(out_bypass_1);

END rtl;
