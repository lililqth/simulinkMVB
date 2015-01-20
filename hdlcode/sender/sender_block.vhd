-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\MVB3sender\sender_block.vhd
-- Created: 2015-01-20 16:27:43
-- 
-- Generated by MATLAB 8.2 and HDL Coder 3.3
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: sender_block
-- Source Path: MVB3sender/sender/sender
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.sender_pkg.ALL;

ENTITY sender_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_const_rate                    :   IN    std_logic;
        BA                                :   IN    std_logic;
        sendSFSignal                      :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        CLK_1                             :   IN    std_logic;
        DataOut                           :   OUT   std_logic_vector(31 DOWNTO 0);  -- uint32
        acceptSignal                      :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
        );
END sender_block;


ARCHITECTURE rtl OF sender_block IS

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
  FUNCTION hdlcoder_to_unsigned(arg: boolean; width: integer) RETURN unsigned IS
  BEGIN
    IF arg THEN
      RETURN to_unsigned(1, width);
    ELSE
      RETURN to_unsigned(0, width);
    END IF;
  END FUNCTION;


  -- Signals
  SIGNAL enb_const_rate_gated             : std_logic;
  SIGNAL CLK_delayed                      : std_logic;
  SIGNAL CLK_emulated                     : std_logic;
  SIGNAL sendSFSignal_unsigned            : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL is_sender                        : T_state_type_is_sender;  -- uint8
  SIGNAL is_sendHolder                    : T_state_type_is_sendHolder;  -- uint8
  SIGNAL b_is_sender                      : T_state_type_b_is_sender;  -- uint8
  SIGNAL b_is_sendHolder                  : T_state_type_b_is_sendHolder;  -- uint8
  SIGNAL is_BAHolder                      : T_state_type_is_BAHolder;  -- uint8
  SIGNAL MFT                              : vector_of_unsigned16(0 TO 99);  -- uint16 [100]
  SIGNAL SFT                              : vector_of_unsigned16(0 TO 99);  -- uint16 [100]
  SIGNAL DataOut_1                        : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL acceptSignal_1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL MFIndex                          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL SFTransDone                      : std_logic;
  SIGNAL SFIndex                          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL enterTrans                       : std_logic;
  SIGNAL SFCurrentIndex                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL count                            : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL input                            : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL MFTransDone                      : std_logic;
  SIGNAL b_enterTrans                     : std_logic;
  SIGNAL MFCurrentIndex                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL b_count                          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL b_input                          : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL temporalCounter_i1               : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL is_sender_next                   : T_state_type_is_sender;  -- enumerated type (5 enums)
  SIGNAL is_sendHolder_next               : T_state_type_is_sendHolder;  -- enumerated type (3 enums)
  SIGNAL b_is_sender_next                 : T_state_type_b_is_sender;  -- enumerated type (3 enums)
  SIGNAL b_is_sendHolder_next             : T_state_type_b_is_sendHolder;  -- enumerated type (3 enums)
  SIGNAL is_BAHolder_next                 : T_state_type_is_BAHolder;  -- enumerated type (2 enums)
  SIGNAL MFT_next                         : vector_of_unsigned16(0 TO 99);  -- uint16 [100]
  SIGNAL SFT_next                         : vector_of_unsigned16(0 TO 99);  -- uint16 [100]
  SIGNAL MFIndex_next                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL SFTransDone_next                 : std_logic;
  SIGNAL SFIndex_next                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL enterTrans_next                  : std_logic;
  SIGNAL SFCurrentIndex_next              : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL count_next                       : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL input_next                       : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL MFTransDone_next                 : std_logic;
  SIGNAL b_enterTrans_next                : std_logic;
  SIGNAL MFCurrentIndex_next              : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL b_count_next                     : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL b_input_next                     : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL temporalCounter_i1_next          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL DataOut_last_value               : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL DataOut_bypass_1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL acceptSignal_last_value          : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL acceptSignal_bypass_1            : unsigned(7 DOWNTO 0);  -- uint8

BEGIN
  CLK_delay_process: PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      CLK_delayed <= '1';
    ELSIF clk'event AND clk = '1' THEN
      IF enb_const_rate = '1' THEN
        CLK_delayed <= CLK_1;
      END IF;
    END IF;
  END PROCESS CLK_delay_process;

  CLK_emulated <= NOT CLK_delayed AND CLK_1;

  sendSFSignal_unsigned <= unsigned(sendSFSignal);

  enb_const_rate_gated <= CLK_emulated AND enb_const_rate;

  sender_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      MFT <= (OTHERS => to_unsigned(16#0000#, 16));
      SFT <= (OTHERS => to_unsigned(16#0000#, 16));
      SFIndex <= to_unsigned(2#00000000#, 8);
      enterTrans <= '0';
      is_sender <= IN_wait;
      count <= to_unsigned(2#00000000#, 8);
      input <= to_unsigned(16#00000000#, 32);
      SFCurrentIndex <= to_unsigned(2#00000010#, 8);
      SFTransDone <= '0';
      is_sendHolder <= IN_empty;
      b_enterTrans <= '0';
      is_BAHolder <= IN_true;
      MFIndex <= to_unsigned(2#00000000#, 8);
      MFT(1) <= to_unsigned(16#0005#, 16);
      MFT(2) <= to_unsigned(16#2C71#, 16);
      MFT(3) <= to_unsigned(16#5000#, 16);
      MFT(4) <= to_unsigned(16#2A8E#, 16);
      MFT(5) <= to_unsigned(16#0033#, 16);
      MFT(17) <= to_unsigned(16#0005#, 16);
      MFT(18) <= to_unsigned(16#2C71#, 16);
      MFT(19) <= to_unsigned(16#5000#, 16);
      MFT(20) <= to_unsigned(16#3A8E#, 16);
      MFT(21) <= to_unsigned(16#0033#, 16);
      MFT(33) <= to_unsigned(16#0005#, 16);
      MFT(34) <= to_unsigned(16#2C71#, 16);
      MFT(35) <= to_unsigned(16#5800#, 16);
      MFT(36) <= to_unsigned(16#2A8E#, 16);
      MFT(37) <= to_unsigned(16#0033#, 16);
      MFT(49) <= to_unsigned(16#0005#, 16);
      MFT(50) <= to_unsigned(16#2C71#, 16);
      MFT(51) <= to_unsigned(16#5F00#, 16);
      MFT(52) <= to_unsigned(16#2A8E#, 16);
      MFT(53) <= to_unsigned(16#0033#, 16);
      SFT(1) <= to_unsigned(16#0004#, 16);
      SFT(2) <= to_unsigned(16#2A8E#, 16);
      SFT(3) <= to_unsigned(16#308C#, 16);
      SFT(4) <= to_unsigned(16#0013#, 16);
      SFT(17) <= to_unsigned(16#0004#, 16);
      SFT(18) <= to_unsigned(16#2A8E#, 16);
      SFT(19) <= to_unsigned(16#3220#, 16);
      SFT(20) <= to_unsigned(16#0003#, 16);
      SFT(33) <= to_unsigned(16#0004#, 16);
      SFT(34) <= to_unsigned(16#2A8E#, 16);
      SFT(35) <= to_unsigned(16#3880#, 16);
      SFT(36) <= to_unsigned(16#0003#, 16);
      b_is_sender <= IN_sleep;
      temporalCounter_i1 <= to_unsigned(2#00000000#, 8);
      b_count <= to_unsigned(2#00000000#, 8);
      b_input <= to_unsigned(16#00000000#, 32);
      MFCurrentIndex <= to_unsigned(2#00000010#, 8);
      MFTransDone <= '0';
      b_is_sendHolder <= IN_empty;
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_const_rate_gated = '1' THEN
        is_sender <= is_sender_next;
        is_sendHolder <= is_sendHolder_next;
        b_is_sender <= b_is_sender_next;
        b_is_sendHolder <= b_is_sendHolder_next;
        is_BAHolder <= is_BAHolder_next;
        MFT <= MFT_next;
        SFT <= SFT_next;
        MFIndex <= MFIndex_next;
        SFTransDone <= SFTransDone_next;
        SFIndex <= SFIndex_next;
        enterTrans <= enterTrans_next;
        SFCurrentIndex <= SFCurrentIndex_next;
        count <= count_next;
        input <= input_next;
        MFTransDone <= MFTransDone_next;
        b_enterTrans <= b_enterTrans_next;
        MFCurrentIndex <= MFCurrentIndex_next;
        b_count <= b_count_next;
        b_input <= b_input_next;
        temporalCounter_i1 <= temporalCounter_i1_next;
      END IF;
    END IF;
  END PROCESS sender_process;

  sender_output : PROCESS (is_sender, is_sendHolder, b_is_sender, b_is_sendHolder, is_BAHolder, BA,
       sendSFSignal_unsigned, MFT, SFT, MFIndex, SFTransDone, SFIndex,
       enterTrans, SFCurrentIndex, count, input, MFTransDone, b_enterTrans,
       MFCurrentIndex, b_count, b_input, temporalCounter_i1)
    VARIABLE x : signed(31 DOWNTO 0);
    VARIABLE bitkm1 : unsigned(7 DOWNTO 0);
    VARIABLE mask : unsigned(31 DOWNTO 0);
    VARIABLE mask_0 : unsigned(31 DOWNTO 0);
    VARIABLE mask_1 : unsigned(31 DOWNTO 0);
    VARIABLE mask_2 : unsigned(31 DOWNTO 0);
    VARIABLE x_0 : signed(31 DOWNTO 0);
    VARIABLE bitkm1_0 : unsigned(7 DOWNTO 0);
    VARIABLE mask_3 : unsigned(31 DOWNTO 0);
    VARIABLE mask_4 : unsigned(31 DOWNTO 0);
    VARIABLE mask_5 : unsigned(31 DOWNTO 0);
    VARIABLE mask_6 : unsigned(31 DOWNTO 0);
    VARIABLE bit1 : unsigned(15 DOWNTO 0);
    VARIABLE bit2 : unsigned(15 DOWNTO 0);
    VARIABLE bit3 : unsigned(15 DOWNTO 0);
    VARIABLE bit0 : unsigned(15 DOWNTO 0);
    VARIABLE fcode : unsigned(15 DOWNTO 0);
    VARIABLE x_1 : signed(31 DOWNTO 0);
    VARIABLE bitkm1_1 : unsigned(7 DOWNTO 0);
    VARIABLE mask_7 : unsigned(31 DOWNTO 0);
    VARIABLE mask_8 : unsigned(31 DOWNTO 0);
    VARIABLE mask_9 : unsigned(31 DOWNTO 0);
    VARIABLE mask_10 : unsigned(31 DOWNTO 0);
    VARIABLE x_2 : signed(31 DOWNTO 0);
    VARIABLE bitkm1_2 : unsigned(7 DOWNTO 0);
    VARIABLE mask_11 : unsigned(31 DOWNTO 0);
    VARIABLE mask_12 : unsigned(31 DOWNTO 0);
    VARIABLE mask_13 : unsigned(31 DOWNTO 0);
    VARIABLE mask_14 : unsigned(31 DOWNTO 0);
    VARIABLE master : std_logic;
    VARIABLE MFT_temp : vector_of_unsigned16(0 TO 99);
    VARIABLE SFT_temp : vector_of_unsigned16(0 TO 99);
    VARIABLE MFIndex_temp : unsigned(7 DOWNTO 0);
    VARIABLE SFIndex_temp : unsigned(7 DOWNTO 0);
    VARIABLE enterTrans_temp : std_logic;
    VARIABLE input_temp : unsigned(31 DOWNTO 0);
    VARIABLE b_enterTrans_temp : std_logic;
    VARIABLE b_input_temp : unsigned(31 DOWNTO 0);
    VARIABLE temporalCounter_i1_temp : unsigned(7 DOWNTO 0);
    VARIABLE add_cast : unsigned(12 DOWNTO 0);
    VARIABLE add_cast_0 : unsigned(12 DOWNTO 0);
    VARIABLE add_cast_1 : unsigned(12 DOWNTO 0);
    VARIABLE add_temp : unsigned(8 DOWNTO 0);
    VARIABLE add_cast_2 : vector_of_unsigned13(0 TO 15);
    VARIABLE add_cast_3 : vector_of_unsigned13(0 TO 15);
    VARIABLE add_temp_0 : unsigned(8 DOWNTO 0);
    VARIABLE add_cast_4 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_5 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_6 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_7 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_8 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_9 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_10 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_11 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_12 : unsigned(12 DOWNTO 0);
    VARIABLE add_temp_1 : unsigned(8 DOWNTO 0);
    VARIABLE add_cast_13 : unsigned(12 DOWNTO 0);
    VARIABLE add_cast_14 : unsigned(12 DOWNTO 0);
    VARIABLE add_cast_15 : unsigned(12 DOWNTO 0);
    VARIABLE add_cast_16 : unsigned(12 DOWNTO 0);
    VARIABLE add_cast_17 : unsigned(12 DOWNTO 0);
    VARIABLE add_cast_18 : unsigned(12 DOWNTO 0);
    VARIABLE add_temp_2 : unsigned(8 DOWNTO 0);
    VARIABLE add_cast_19 : std_logic;
    VARIABLE add_cast_20 : unsigned(1 DOWNTO 0);
    VARIABLE cast : std_logic;
    VARIABLE cast_0 : std_logic;
    VARIABLE add_cast_21 : unsigned(1 DOWNTO 0);
    VARIABLE cast_1 : std_logic;
    VARIABLE cast_2 : std_logic;
    VARIABLE add_cast_22 : unsigned(2 DOWNTO 0);
    VARIABLE cast_3 : std_logic;
    VARIABLE cast_4 : std_logic;
    VARIABLE add_cast_23 : unsigned(3 DOWNTO 0);
    VARIABLE add_cast_24 : vector_of_unsigned13(0 TO 15);
    VARIABLE add_cast_25 : vector_of_unsigned13(0 TO 15);
    VARIABLE add_temp_3 : unsigned(8 DOWNTO 0);
    VARIABLE add_cast_26 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_27 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_28 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_29 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_30 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_31 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_32 : vector_of_unsigned5(0 TO 15);
    VARIABLE add_cast_33 : vector_of_unsigned5(0 TO 15);
  BEGIN
    MFT_temp := MFT;
    SFT_temp := SFT;
    MFIndex_temp := MFIndex;
    SFIndex_temp := SFIndex;
    enterTrans_temp := enterTrans;
    input_temp := input;
    b_enterTrans_temp := b_enterTrans;
    b_input_temp := b_input;
    temporalCounter_i1_temp := temporalCounter_i1;
    is_sender_next <= is_sender;
    is_sendHolder_next <= is_sendHolder;
    b_is_sender_next <= b_is_sender;
    b_is_sendHolder_next <= b_is_sendHolder;
    is_BAHolder_next <= is_BAHolder;
    SFTransDone_next <= SFTransDone;
    SFCurrentIndex_next <= SFCurrentIndex;
    count_next <= count;
    MFTransDone_next <= MFTransDone;
    MFCurrentIndex_next <= MFCurrentIndex;
    b_count_next <= b_count;
    DataOut_1 <= to_unsigned(16#00000000#, 32);
    acceptSignal_1 <= to_unsigned(2#00000000#, 8);
    IF temporalCounter_i1 < 150 THEN 
      temporalCounter_i1_temp := temporalCounter_i1 + 1;
    END IF;

    CASE is_sender IS
      WHEN IN_sendInfo =>
        SFIndex_temp := to_unsigned(2#00000001#, 8);
        is_sender_next <= IN_transmission;
        enterTrans_temp := '1';
      WHEN IN_sendOK =>
        SFIndex_temp := to_unsigned(2#00000010#, 8);
        MFIndex_temp := to_unsigned(2#00000000#, 8);
        acceptSignal_1 <= to_unsigned(2#00000000#, 8);
        MFT_temp(1) := to_unsigned(16#0005#, 16);
        MFT_temp(2) := to_unsigned(16#2C71#, 16);
        MFT_temp(3) := to_unsigned(16#5000#, 16);
        MFT_temp(4) := to_unsigned(16#2A8E#, 16);
        MFT_temp(5) := to_unsigned(16#0033#, 16);
        MFT_temp(17) := to_unsigned(16#0005#, 16);
        MFT_temp(18) := to_unsigned(16#2C71#, 16);
        MFT_temp(19) := to_unsigned(16#5000#, 16);
        MFT_temp(20) := to_unsigned(16#3A8E#, 16);
        MFT_temp(21) := to_unsigned(16#0033#, 16);
        MFT_temp(33) := to_unsigned(16#0005#, 16);
        MFT_temp(34) := to_unsigned(16#2C71#, 16);
        MFT_temp(35) := to_unsigned(16#5800#, 16);
        MFT_temp(36) := to_unsigned(16#2A8E#, 16);
        MFT_temp(37) := to_unsigned(16#0033#, 16);
        MFT_temp(49) := to_unsigned(16#0005#, 16);
        MFT_temp(50) := to_unsigned(16#2C71#, 16);
        MFT_temp(51) := to_unsigned(16#5F00#, 16);
        MFT_temp(52) := to_unsigned(16#2A8E#, 16);
        MFT_temp(53) := to_unsigned(16#0033#, 16);
        SFT_temp(1) := to_unsigned(16#0004#, 16);
        SFT_temp(2) := to_unsigned(16#2A8E#, 16);
        SFT_temp(3) := to_unsigned(16#308C#, 16);
        SFT_temp(4) := to_unsigned(16#0013#, 16);
        SFT_temp(17) := to_unsigned(16#0004#, 16);
        SFT_temp(18) := to_unsigned(16#2A8E#, 16);
        SFT_temp(19) := to_unsigned(16#3220#, 16);
        SFT_temp(20) := to_unsigned(16#0003#, 16);
        SFT_temp(33) := to_unsigned(16#0004#, 16);
        SFT_temp(34) := to_unsigned(16#2A8E#, 16);
        SFT_temp(35) := to_unsigned(16#3880#, 16);
        SFT_temp(36) := to_unsigned(16#0003#, 16);
        is_sender_next <= IN_transmission;
        enterTrans_temp := '1';
      WHEN IN_sendRandomSF =>
        SFIndex_temp := to_unsigned(2#00000000#, 8);
        is_sender_next <= IN_transmission;
        enterTrans_temp := '1';
      WHEN IN_transmission =>
        IF SFTransDone = '1' THEN 
          DataOut_1 <= to_unsigned(16#00000000#, 32);
          enterTrans_temp := '0';
          SFTransDone_next <= '0';
          is_sender_next <= IN_wait;
        END IF;
      WHEN OTHERS => 
        IF sendSFSignal_unsigned = 1 THEN 
          is_sender_next <= IN_sendRandomSF;
        ELSIF sendSFSignal_unsigned = 3 THEN 
          is_sender_next <= IN_sendOK;
        ELSIF sendSFSignal_unsigned = 2 THEN 
          is_sender_next <= IN_sendInfo;
        END IF;
    END CASE;


    CASE is_sendHolder IS
      WHEN IN_empty =>
        IF enterTrans_temp = '1' THEN 
          add_cast_1 := resize(SFIndex_temp & '0' & '0' & '0' & '0', 13);
          input_temp := resize(SFT_temp(to_integer(add_cast_1 + resize(SFCurrentIndex, 13))), 32);

          FOR b_i_0 IN 0 TO 15 LOOP
            bitkm1_0 := unsigned(to_signed(b_i_0, 32)(7 DOWNTO 0));
            add_cast_3(b_i_0) := resize(SFIndex_temp & '0' & '0' & '0' & '0', 13);
            x_0 := hdlcoder_to_signed(SFT_temp(to_integer(add_cast_3(b_i_0) + resize(SFCurrentIndex, 13)))(to_integer(bitkm1_0)) /= '0', 32);
            IF x_0 = 0 THEN 
              add_cast_7(b_i_0) := unsigned(to_signed(b_i_0, 32)(4 DOWNTO 0));
              mask_5 := resize(to_unsigned(2#0000000000000000000000000000001#, 31) sll to_integer(resize((1 + add_cast_7(b_i_0)) * to_unsigned(2#10#, 2), 6) - 2), 32);
              add_cast_11(b_i_0) := unsigned(to_signed(b_i_0, 32)(4 DOWNTO 0));
              mask_6 := to_unsigned(1, 32) sll to_integer(resize((1 + add_cast_11(b_i_0)) * to_unsigned(2#10#, 2), 6) - 1);
              input_temp := (input_temp OR mask_5) AND ( NOT mask_6);
            ELSE 
              add_cast_6(b_i_0) := unsigned(to_signed(b_i_0, 32)(4 DOWNTO 0));
              mask_3 := resize(to_unsigned(2#0000000000000000000000000000001#, 31) sll to_integer(resize((1 + add_cast_6(b_i_0)) * to_unsigned(2#10#, 2), 6) - 2), 32);
              add_cast_10(b_i_0) := unsigned(to_signed(b_i_0, 32)(4 DOWNTO 0));
              mask_4 := to_unsigned(1, 32) sll to_integer(resize((1 + add_cast_10(b_i_0)) * to_unsigned(2#10#, 2), 6) - 1);
              input_temp := (input_temp AND ( NOT mask_3)) OR mask_4;
            END IF;
          END LOOP;

          DataOut_1 <= to_unsigned(16#00000000#, 32);
          count_next <= to_unsigned(2#00000000#, 8);
          is_sendHolder_next <= IN_full;
        END IF;
      WHEN IN_full =>
        IF count = 32 THEN 
          add_temp := resize(SFCurrentIndex, 9) + 1;
          IF add_temp(8) /= '0' THEN 
            SFCurrentIndex_next <= "11111111";
          ELSE 
            SFCurrentIndex_next <= add_temp(7 DOWNTO 0);
          END IF;
          is_sendHolder_next <= IN_judge;
        ELSE 
          DataOut_1 <= hdlcoder_to_unsigned(input(31) /= '0', 32);
          input_temp := input sll 1;
          --for i=1:cnt
          --   r = bitset(r, i, 0);
          --end
          add_temp_0 := resize(count, 9) + 1;
          IF add_temp_0(8) /= '0' THEN 
            count_next <= "11111111";
          ELSE 
            count_next <= add_temp_0(7 DOWNTO 0);
          END IF;
        END IF;
      WHEN OTHERS => 
        add_cast := resize(SFIndex_temp & '0' & '0' & '0' & '0', 13);
        IF resize(SFCurrentIndex, 16) <= SFT_temp(to_integer(resize(add_cast, 12) + 1)) THEN 
          add_cast_0 := resize(SFIndex_temp & '0' & '0' & '0' & '0', 13);
          input_temp := resize(SFT_temp(to_integer(add_cast_0 + resize(SFCurrentIndex, 13))), 32);

          FOR b_i IN 0 TO 15 LOOP
            bitkm1 := unsigned(to_signed(b_i, 32)(7 DOWNTO 0));
            add_cast_2(b_i) := resize(SFIndex_temp & '0' & '0' & '0' & '0', 13);
            x := hdlcoder_to_signed(SFT_temp(to_integer(add_cast_2(b_i) + resize(SFCurrentIndex, 13)))(to_integer(bitkm1)) /= '0', 32);
            IF x = 0 THEN 
              add_cast_5(b_i) := unsigned(to_signed(b_i, 32)(4 DOWNTO 0));
              mask_1 := resize(to_unsigned(2#0000000000000000000000000000001#, 31) sll to_integer(resize((1 + add_cast_5(b_i)) * to_unsigned(2#10#, 2), 6) - 2), 32);
              add_cast_9(b_i) := unsigned(to_signed(b_i, 32)(4 DOWNTO 0));
              mask_2 := to_unsigned(1, 32) sll to_integer(resize((1 + add_cast_9(b_i)) * to_unsigned(2#10#, 2), 6) - 1);
              input_temp := (input_temp OR mask_1) AND ( NOT mask_2);
            ELSE 
              add_cast_4(b_i) := unsigned(to_signed(b_i, 32)(4 DOWNTO 0));
              mask := resize(to_unsigned(2#0000000000000000000000000000001#, 31) sll to_integer(resize((1 + add_cast_4(b_i)) * to_unsigned(2#10#, 2), 6) - 2), 32);
              add_cast_8(b_i) := unsigned(to_signed(b_i, 32)(4 DOWNTO 0));
              mask_0 := to_unsigned(1, 32) sll to_integer(resize((1 + add_cast_8(b_i)) * to_unsigned(2#10#, 2), 6) - 1);
              input_temp := (input_temp AND ( NOT mask)) OR mask_0;
            END IF;
          END LOOP;

          count_next <= to_unsigned(2#00000000#, 8);
          is_sendHolder_next <= IN_full;
        ELSE 
          SFCurrentIndex_next <= to_unsigned(2#00000010#, 8);
          SFTransDone_next <= '1';
          is_sendHolder_next <= IN_empty;
        END IF;
    END CASE;


    CASE is_BAHolder IS
      WHEN IN_false =>
        IF BA = '1' THEN 
          master := '1';
          is_BAHolder_next <= IN_true;
        ELSE 
          master := '0';
        END IF;
      WHEN OTHERS => 
        IF BA = '1' THEN 
          master := '0';
          is_BAHolder_next <= IN_false;
        ELSE 
          master := '1';
        END IF;
    END CASE;


    CASE b_is_sender IS
      WHEN IN_sleep =>
        IF (temporalCounter_i1_temp = 150) AND (master = '1') THEN 
          b_is_sender_next <= b_IN_wait;
        END IF;
      WHEN b_IN_transmission =>
        IF MFTransDone = '1' THEN 
          DataOut_1 <= to_unsigned(16#00000000#, 32);
          add_temp_1 := resize(MFIndex_temp, 9) + 1;
          IF add_temp_1(8) /= '0' THEN 
            MFIndex_temp := "11111111";
          ELSE 
            MFIndex_temp := add_temp_1(7 DOWNTO 0);
          END IF;
          MFTransDone_next <= '0';
          b_enterTrans_temp := '0';
          b_is_sender_next <= IN_sleep;
          temporalCounter_i1_temp := to_unsigned(2#00000000#, 8);
        END IF;
      WHEN OTHERS => 
        b_is_sender_next <= b_IN_transmission;
        b_enterTrans_temp := '1';
        add_cast_12 := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
        bit0 := hdlcoder_to_unsigned(MFT_temp(to_integer(resize(add_cast_12, 12) + 3))(8) /= '0', 16);
        add_cast_13 := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
        bit1 := hdlcoder_to_unsigned(MFT_temp(to_integer(resize(add_cast_13, 12) + 3))(9) /= '0', 16);
        add_cast_14 := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
        bit2 := hdlcoder_to_unsigned(MFT_temp(to_integer(resize(add_cast_14, 12) + 3))(10) /= '0', 16);
        add_cast_16 := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
        bit3 := hdlcoder_to_unsigned(MFT_temp(to_integer(resize(add_cast_16, 12) + 3))(11) /= '0', 16);
        add_cast_19 := bit0(0);
        add_cast_20 := '0' & add_cast_19;
        cast := bit1(0);
        IF cast = '1' THEN 
          cast_0 := '1';
        ELSE 
          cast_0 := '0';
        END IF;
        add_cast_21 := unsigned'(cast_0 & '0');
        cast_1 := bit2(0);
        IF cast_1 = '1' THEN 
          cast_2 := '1';
        ELSE 
          cast_2 := '0';
        END IF;
        add_cast_22 := unsigned'(cast_2 & '0' & '0');
        cast_3 := bit3(0);
        IF cast_3 = '1' THEN 
          cast_4 := '1';
        ELSE 
          cast_4 := '0';
        END IF;
        add_cast_23 := unsigned'(cast_4 & '0' & '0' & '0');
        fcode := resize(resize(resize(add_cast_20 + add_cast_21, 3) + add_cast_22, 4) + add_cast_23, 16);
        acceptSignal_1 <= to_unsigned(2#00000000#, 8);
        IF resize(fcode, 4) = 0 THEN 
          acceptSignal_1 <= to_unsigned(2#00000001#, 8);
        ELSIF resize(fcode, 4) = 8 THEN 
          acceptSignal_1 <= to_unsigned(2#00000010#, 8);
        ELSIF resize(fcode, 4) = 15 THEN 
          acceptSignal_1 <= to_unsigned(2#00000011#, 8);
        END IF;
    END CASE;


    CASE b_is_sendHolder IS
      WHEN IN_empty =>
        IF b_enterTrans_temp = '1' THEN 
          add_cast_18 := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
          b_input_temp := resize(MFT_temp(to_integer(add_cast_18 + resize(MFCurrentIndex, 13))), 32);

          FOR b_i_2 IN 0 TO 15 LOOP
            bitkm1_2 := unsigned(to_signed(b_i_2, 32)(7 DOWNTO 0));
            add_cast_25(b_i_2) := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
            x_2 := hdlcoder_to_signed(MFT_temp(to_integer(add_cast_25(b_i_2) + resize(MFCurrentIndex, 13)))(to_integer(bitkm1_2)) /= '0', 32);
            IF x_2 = 0 THEN 
              add_cast_29(b_i_2) := unsigned(to_signed(b_i_2, 32)(4 DOWNTO 0));
              mask_13 := resize(to_unsigned(2#0000000000000000000000000000001#, 31) sll to_integer(resize((1 + add_cast_29(b_i_2)) * to_unsigned(2#10#, 2), 6) - 2), 32);
              add_cast_33(b_i_2) := unsigned(to_signed(b_i_2, 32)(4 DOWNTO 0));
              mask_14 := to_unsigned(1, 32) sll to_integer(resize((1 + add_cast_33(b_i_2)) * to_unsigned(2#10#, 2), 6) - 1);
              b_input_temp := (b_input_temp OR mask_13) AND ( NOT mask_14);
            ELSE 
              add_cast_28(b_i_2) := unsigned(to_signed(b_i_2, 32)(4 DOWNTO 0));
              mask_11 := resize(to_unsigned(2#0000000000000000000000000000001#, 31) sll to_integer(resize((1 + add_cast_28(b_i_2)) * to_unsigned(2#10#, 2), 6) - 2), 32);
              add_cast_32(b_i_2) := unsigned(to_signed(b_i_2, 32)(4 DOWNTO 0));
              mask_12 := to_unsigned(1, 32) sll to_integer(resize((1 + add_cast_32(b_i_2)) * to_unsigned(2#10#, 2), 6) - 1);
              b_input_temp := (b_input_temp AND ( NOT mask_11)) OR mask_12;
            END IF;
          END LOOP;

          DataOut_1 <= to_unsigned(16#00000000#, 32);
          b_count_next <= to_unsigned(2#00000000#, 8);
          b_is_sendHolder_next <= IN_full;
        END IF;
      WHEN IN_full =>
        IF b_count = 32 THEN 
          add_temp_2 := resize(MFCurrentIndex, 9) + 1;
          IF add_temp_2(8) /= '0' THEN 
            MFCurrentIndex_next <= "11111111";
          ELSE 
            MFCurrentIndex_next <= add_temp_2(7 DOWNTO 0);
          END IF;
          b_is_sendHolder_next <= IN_judge;
        ELSE 
          DataOut_1 <= hdlcoder_to_unsigned(b_input(31) /= '0', 32);
          b_input_temp := b_input sll 1;
          --for i=1:cnt
          --   r = bitset(r, i, 0);
          --end
          add_temp_3 := resize(b_count, 9) + 1;
          IF add_temp_3(8) /= '0' THEN 
            b_count_next <= "11111111";
          ELSE 
            b_count_next <= add_temp_3(7 DOWNTO 0);
          END IF;
        END IF;
      WHEN OTHERS => 
        add_cast_15 := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
        IF resize(MFCurrentIndex, 16) <= MFT_temp(to_integer(resize(add_cast_15, 12) + 1)) THEN 
          add_cast_17 := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
          b_input_temp := resize(MFT_temp(to_integer(add_cast_17 + resize(MFCurrentIndex, 13))), 32);

          FOR b_i_1 IN 0 TO 15 LOOP
            bitkm1_1 := unsigned(to_signed(b_i_1, 32)(7 DOWNTO 0));
            add_cast_24(b_i_1) := resize(MFIndex_temp & '0' & '0' & '0' & '0', 13);
            x_1 := hdlcoder_to_signed(MFT_temp(to_integer(add_cast_24(b_i_1) + resize(MFCurrentIndex, 13)))(to_integer(bitkm1_1)) /= '0', 32);
            IF x_1 = 0 THEN 
              add_cast_27(b_i_1) := unsigned(to_signed(b_i_1, 32)(4 DOWNTO 0));
              mask_9 := resize(to_unsigned(2#0000000000000000000000000000001#, 31) sll to_integer(resize((1 + add_cast_27(b_i_1)) * to_unsigned(2#10#, 2), 6) - 2), 32);
              add_cast_31(b_i_1) := unsigned(to_signed(b_i_1, 32)(4 DOWNTO 0));
              mask_10 := to_unsigned(1, 32) sll to_integer(resize((1 + add_cast_31(b_i_1)) * to_unsigned(2#10#, 2), 6) - 1);
              b_input_temp := (b_input_temp OR mask_9) AND ( NOT mask_10);
            ELSE 
              add_cast_26(b_i_1) := unsigned(to_signed(b_i_1, 32)(4 DOWNTO 0));
              mask_7 := resize(to_unsigned(2#0000000000000000000000000000001#, 31) sll to_integer(resize((1 + add_cast_26(b_i_1)) * to_unsigned(2#10#, 2), 6) - 2), 32);
              add_cast_30(b_i_1) := unsigned(to_signed(b_i_1, 32)(4 DOWNTO 0));
              mask_8 := to_unsigned(1, 32) sll to_integer(resize((1 + add_cast_30(b_i_1)) * to_unsigned(2#10#, 2), 6) - 1);
              b_input_temp := (b_input_temp AND ( NOT mask_7)) OR mask_8;
            END IF;
          END LOOP;

          b_count_next <= to_unsigned(2#00000000#, 8);
          b_is_sendHolder_next <= IN_full;
        ELSE 
          MFCurrentIndex_next <= to_unsigned(2#00000010#, 8);
          MFTransDone_next <= '1';
          b_is_sendHolder_next <= IN_empty;
        END IF;
    END CASE;

    IF temporalCounter_i1_temp = 150 THEN 
      temporalCounter_i1_temp := to_unsigned(2#00000000#, 8);
    END IF;
    MFT_next <= MFT_temp;
    SFT_next <= SFT_temp;
    MFIndex_next <= MFIndex_temp;
    SFIndex_next <= SFIndex_temp;
    enterTrans_next <= enterTrans_temp;
    input_next <= input_temp;
    b_enterTrans_next <= b_enterTrans_temp;
    b_input_next <= b_input_temp;
    temporalCounter_i1_next <= temporalCounter_i1_temp;
  END PROCESS sender_output;


  DataOut_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      DataOut_last_value <= to_unsigned(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_const_rate_gated = '1' THEN
        DataOut_last_value <= DataOut_1;
      END IF;
    END IF;
  END PROCESS DataOut_bypass_process;


  
  DataOut_bypass_1 <= DataOut_last_value WHEN CLK_emulated = '0' ELSE
      DataOut_1;

  DataOut <= std_logic_vector(DataOut_bypass_1);

  acceptSignal_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      acceptSignal_last_value <= to_unsigned(2#00000000#, 8);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb_const_rate_gated = '1' THEN
        acceptSignal_last_value <= acceptSignal_1;
      END IF;
    END IF;
  END PROCESS acceptSignal_bypass_process;


  
  acceptSignal_bypass_1 <= acceptSignal_last_value WHEN CLK_emulated = '0' ELSE
      acceptSignal_1;

  acceptSignal <= std_logic_vector(acceptSignal_bypass_1);

END rtl;

