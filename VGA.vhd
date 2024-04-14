

		library IEEE;
		use IEEE.STD_LOGIC_1164.ALL;
--		--use IEEE.STD_LOGIC_ARITH.ALL;
		use IEEE.STD_LOGIC_UNSIGNED.ALL;
		use IEEE.NUMERIC_STD.ALL;

		entity VGA is
		  port (
			 clock : in  std_logic;              -- System clock at 50MHz
			 led1: out std_logic;
			 led2: out std_logic;
          led3: out std_logic;
          led4: out std_logic;
			 
			 LED_out : out STD_LOGIC_VECTOR (6 downto 0) ; -- Cathode patterns of 7-segment display
			 Anode_Activate : out STD_LOGIC_VECTOR (3 downto 0);  -- 4 Anode signals
           
			-- com_3V3: out std_logic:='1';
			 --switch1,switch2 : in  std_logic_vector(1 downto 0);
			 --switch1,switch2 : in  std_logic;
			 disp_RGB : out  std_logic_vector(2 downto 0);
			 hsync : out  std_logic;
			 vsync : out  std_logic;
			 button1,button2,button3,button4,button5,button6,
			 button7,button8,button9: in std_logic;
			 reset:in std_logic
			-- position1,position2,position3,position4,position5,position6,position7,position8,
			-- position9 : in std_logic:='1'
			 
			 
			 );
		end VGA;

		architecture Behavioral of VGA is
		signal clk_div: std_logic;
      signal count: std_logic_vector(27 downto 0);
		signal button1_count: std_logic_vector(27 downto 0);
		signal button2_count: std_logic_vector(27 downto 0);
		signal button3_count: std_logic_vector(27 downto 0);
		signal button4_count: std_logic_vector(27 downto 0);
		signal button5_count: std_logic_vector(27 downto 0);
		signal button6_count: std_logic_vector(27 downto 0);
		signal button7_count: std_logic_vector(27 downto 0);
		signal button8_count: std_logic_vector(27 downto 0);
		signal button9_count: std_logic_vector(27 downto 0);
		  signal hcount : std_logic_vector(9 downto 0);
		  signal vcount : std_logic_vector(9 downto 0);
		  signal data : std_logic_vector(2 downto 0);
		  signal h_dat : std_logic_vector(2 downto 0);
		  signal v_dat : std_logic_vector(2 downto 0);
		  signal flag : std_logic;
		  signal hcount_ov : std_logic;
		  signal vcount_ov : std_logic;
		  signal dat_act : std_logic;
		  signal vga_clk : std_logic;
        signal clk_game: std_logic;

		  constant hsync_end : integer := 95;
		  constant hdat_begin : integer := 143;
		  constant hdat_end : integer := 783;
		  constant hpixel_end : integer := 799;
		  constant vsync_end : integer := 1;
		  constant vdat_begin : integer := 34;
		  constant vdat_end : integer := 514;
		  constant vline_end : integer := 524;
		  
		  -----------------------------------------
		signal button1_hold: std_logic:='1';  
		signal button2_hold: std_logic:='1'; 
	   signal button3_hold: std_logic:='1';  
		signal button4_hold: std_logic:='1'; 
	   signal button5_hold: std_logic:='1';  
		signal button6_hold: std_logic:='1'; 
	   signal button7_hold: std_logic:='1';  
		signal button8_hold: std_logic:='1';
	   signal button9_hold: std_logic:='1';  
		
		signal button1_holding: std_logic:='1';  
		signal button2_holding: std_logic:='1'; 
	   signal button3_holding: std_logic:='1';  
		signal button4_holding: std_logic:='1'; 
	   signal button5_holding: std_logic:='1';  
		signal button6_holding: std_logic:='1'; 
	   signal button7_holding: std_logic:='1';  
		signal button8_holding: std_logic:='1';
	   signal button9_holding: std_logic:='1'; 
		
	 signal count1          : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal counter1_pressed : STD_LOGIC_VECTOR(24 downto 0) := "0000000000000000000000000";
    signal counter1_not_pressed : STD_LOGIC_VECTOR(24 downto 0) := "0000000000000000000000000";
    
	 signal button1_state    : STD_LOGIC := '0';
	 signal button2_state    : STD_LOGIC := '0';
	 signal button3_state    : STD_LOGIC := '0';
	 signal button4_state    : STD_LOGIC := '0';
	 signal button5_state    : STD_LOGIC := '0';
	 signal button6_state    : STD_LOGIC := '0';
	 signal button7_state    : STD_LOGIC := '0';
	 signal button8_state    : STD_LOGIC := '0';
	 signal button9_state    : STD_LOGIC := '0';
	 shared variable player_state: std_logic:='0'; 

			
		
		--signal count: std_logic_vector(3 downto 0):="0000";
				
		signal player1_r1c1_enable: std_logic :='1'; 
	   signal player2_r1c1_enable: std_logic :='1'; 
	   signal player1_r2c1_enable: std_logic :='1'; 
	   signal player2_r2c1_enable: std_logic :='1'; 
	   signal player1_r3c1_enable: std_logic :='1'; 
	   signal player2_r3c1_enable: std_logic :='1'; 
		
	   signal player1_r1c2_enable: std_logic :='1'; 
	   signal player2_r1c2_enable: std_logic :='1'; 	
		signal player1_r2c2_enable: std_logic :='1'; 
	   signal player2_r2c2_enable: std_logic :='1'; 
		
	   signal player1_r3c2_enable: std_logic :='1'; 
	   signal player2_r3c2_enable: std_logic :='1'; 
	   	
		signal player1_r1c3_enable: std_logic :='1'; 
	   signal player2_r1c3_enable: std_logic :='1'; 	
		signal player1_r2c3_enable: std_logic :='1'; 
	   signal player2_r2c3_enable: std_logic :='1'; 
	   signal player1_r3c3_enable: std_logic :='1'; 
	   signal player2_r3c3_enable: std_logic :='1'; 
		
		
		signal p1_pos1: std_logic := '0';
		signal p2_pos1: std_logic := '0';
		signal p1_pos2: std_logic := '0';
		signal p2_pos2: std_logic := '0';
		signal p1_pos3: std_logic := '0';
		signal p2_pos3: std_logic := '0';
		signal p1_pos4: std_logic := '0';
		signal p2_pos4: std_logic := '0';
		signal p1_pos5: std_logic := '0';
		signal p2_pos5: std_logic := '0';
		signal p1_pos6: std_logic := '0';
		signal p2_pos6: std_logic := '0';
		signal p1_pos7: std_logic := '0';
		signal p2_pos7: std_logic := '0';
		signal p1_pos8: std_logic := '0';
		signal p2_pos8: std_logic := '0';
		signal p1_pos9: std_logic := '0';
		signal p2_pos9: std_logic := '0';
		
		signal winner_p1: std_logic := '0';
		signal winner_p2: std_logic := '0';
		signal draw: std_logic := '0';
		signal game_finish: std_logic := '0';
		
		
		---signal seven segment ---
		signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
		signal LED_activating_counter: std_logic_vector(1 downto 0);
		signal displayed_number1: STD_LOGIC_VECTOR (3 downto 0);
		signal displayed_number2: STD_LOGIC_VECTOR (3 downto 0);
		signal displayed_number3: STD_LOGIC_VECTOR (3 downto 0);
		signal displayed_number4: STD_LOGIC_VECTOR (3 downto 0);
		signal LED_BCD: STD_LOGIC_VECTOR (3 downto 0);
		
		signal r1c1_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		signal r2c1_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		signal r3c1_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		signal r1c2_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		signal r2c2_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		signal r3c2_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		signal r1c3_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		signal r2c3_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		signal r3c3_colur: STD_LOGIC_VECTOR (2 downto 0):="111";
		
		signal play: std_logic := '0';






		
		begin
		
		
		--seven segment part
		 process (clock,reset)
		 begin
			  if reset = '0' then
					refresh_counter <= (others => '0');
			  elsif rising_edge(clock) then
					refresh_counter <= refresh_counter + 1;
			  end if;
		 end process;

		 LED_activating_counter <= refresh_counter(19 downto 18);

		 -- 4-to-1 MUX to generate anode activating signals for 4 LEDs
		 process (LED_activating_counter)
		 begin
			  case LED_activating_counter is
					when "00" =>
						 Anode_Activate <= "0111"; -- activate LED1 and deactivate LED2, LED3, LED4
						 LED_BCD <= displayed_number1(3 downto 0); -- the first hex digit
					    
					when "01" =>
						 Anode_Activate <= "1011"; -- activate LED2 and deactivate LED1, LED3, LED4
						 LED_BCD <= displayed_number2(3 downto 0);  -- the second hex digit
					    
					when "10" =>
						 Anode_Activate <= "1101"; -- activate LED3 and deactivate LED2, LED1, LED4
						 LED_BCD <= displayed_number3(3 downto 0);   -- the third hex digit
					   
					when "11" =>
						 Anode_Activate <= "1110"; -- activate LED4 and deactivate LED2, LED3, LED1
						 LED_BCD <= displayed_number4(3 downto 0);   -- the fourth hex digit
					   
					when others =>
						 Anode_Activate <= "1111"; -- Default: All anodes off
			  end case;
		 end process;
		 
		 
		  process (LED_BCD)
		  begin
			  case LED_BCD is
					when "0000" => LED_out <= "0000001"; -- "0"
					when "0001" => LED_out <= "1001111"; -- "1"
					when "0010" => LED_out <= "0010010"; -- "2"
					when "0011" => LED_out <= "0000110"; -- "3"
					when "0100" => LED_out <= "1001100"; -- "4"
					when "0101" => LED_out <= "0100100"; -- "5"
					when "0110" => LED_out <= "0100000"; -- "6"
					when "0111" => LED_out <= "0001111"; -- "7"
					when "1000" => LED_out <= "0000000"; -- "8"
					when "1001" => LED_out <= "0000100"; -- "9"
					when "1010" => LED_out <= "0000010"; -- a
					when "1011" => LED_out <= "1100000"; -- b
					when "1100" => LED_out <= "0110001"; -- C
					when "1101" => LED_out <= "1000010"; -- d
					when "1110" => LED_out <= "0110000"; -- E
					when "1111" => LED_out <= "0011000"; -- F
					when others => LED_out <= "1111111"; -- Default: All segments off
			  end case;
		 end process;
		 
		display_player_state:Process(clock) 
		 

		 begin
		 case player_state is 
		 when '0' =>
		 displayed_number1 <= "0001";
		 
		 when '1' =>
		displayed_number1 <= "0010";
		
		when others =>
		null;
		end case;
		displayed_number2 <= "1111";
		displayed_number3<= count1;
		--displayed_number4 <= "0000";
		end process display_player_state;
		
		 --------end seven segment part
		
		
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	--	com_3V3<='1';
	--	process(clock)
 -- begin
       -- if (clock'event and clock='1') then 
		  --  count <= count + '1';
			--end if;
			--clk_div <= count(2);
 --end process;   

 
 process(clock)
  begin
        if rising_edge(clock) then 
		    if count=x"4C4B40" then
			 
			 count <= (others=>'0');
			 play<='1';
			else
			    count<= count + 1;
			 end if;
		 end if;	 
 end process;   


       process (vga_clk)
		  begin
			 if rising_edge(vga_clk) then
				clk_game <= not clk_game;
			 end if;
		  end process; 
		
		
		
		  process (clock)
		  begin
			 if rising_edge(clock) then
				vga_clk <= not vga_clk;
			 end if;
		  end process;

		  hcount_proc: process (vga_clk)
		  begin
			 if rising_edge(vga_clk) then
				if (hcount_ov = '1') then
				  hcount <= (others => '0');
				else
				  hcount <= std_logic_vector(unsigned(hcount) + 1);
				end if;
			 end if;
		  end process hcount_proc;

		  hcount_ov <= '1' when (hcount = hpixel_end) else '0';

		  vcount_proc: process (vga_clk)
		  begin
			 if rising_edge(vga_clk) then
				if (hcount_ov = '1') then
				  if (vcount_ov = '1') then
					 vcount <= (others => '0');
				  else
					 vcount <= std_logic_vector(unsigned(vcount) + 1);
				  end if;
				end if;
			 end if;
		  end process vcount_proc;

		  vcount_ov <= '1' when (vcount = vline_end) else '0';

		  dat_act <= '1' when ((unsigned(hcount) >= hdat_begin) and (unsigned(hcount) < hdat_end)) and 
									((unsigned(vcount) >= vdat_begin) and (unsigned(vcount) < vdat_end)) else '0';

		  hsync <= '1' when (unsigned(hcount) > hsync_end) else '0';
		  vsync <= '1' when (unsigned(vcount) > vsync_end) else '0';

		  disp_RGB <= data when (dat_act = '1') else "000";

			--switch_proc: process (vga_clk)
		 --begin
			-- if rising_edge(vga_clk) then
			--	case switch2 is
				--  when '0' =>
					 data <= h_dat;
				  --when "1" =>
					-- data <= v_dat;
				  --when "10" =>
					 --data <= v_dat xor h_dat;
				 -- when others =>
					 --data <= not (v_dat xor h_dat);
					-- data <= h_dat;
				--end case;
			-- end if;
		 -- end process switch_proc;
		  
		  
		  ---------------holding process------
		  button_hold: process(clock,vga_clk,button1,button2,button3,button4,button5,button6,
		  button7,button8,button9)
		   

		  begin
		   

		  if rising_edge(clock) then
			 if reset='0' then
				 
				  button1_hold<='1';
				  button2_hold<='1';
				  button3_hold<='1';
				  button4_hold<='1';
				  button5_hold<='1';
				  button6_hold<='1';
				  button7_hold<='1';
				  button8_hold<='1';
				  button9_hold<='1';
				  
				  
				  
				  button1_holding<='1';
				  button2_holding<='1';
				  button3_holding<='1';
				  button4_holding<='1';
				  button5_holding<='1';
				  button6_holding<='1';
				  button7_holding<='1';
				  button8_holding<='1';
				  button9_holding<='1';
				  
				  
				  
				  
				  button1_state <= '0';
				  button2_state <= '0';
				  button3_state <= '0';
				  button4_state <= '0';
				  button5_state <= '0';
				  button6_state <= '0';
				  button7_state <= '0';
				  button8_state <= '0';
				  button9_state <= '0';
				  
				  
				  
				  player_state:='0';
				  count1<="0000";
				  
				  game_finish <='1';
				  
				      
				  
				  
				  
				  
				 -- player1_enable<='1';
		end if ;	
		    
		       	 
			 
			  
			
	     	if button1 = '1' and button1_state = '0' then   
				    
					 player_state := not player_state;
					
					 button1_hold <='0';
					 button1_holding <='0';
					 button1_state <= '1';
					 
					
           end if;

           
		      
            
	        if button2 = '1' and button2_state = '0' then
                player_state := not player_state;
				    button2_hold <='0';
					 button2_holding <='0';
					 button2_state <= '1';
            end if;

           
			
				  
				
		 if button3 = '1' and button3_state = '0' then
                
					 player_state := not player_state;
				    button3_hold <='0';
					 button3_holding <='0';
					 button3_state <= '1';
            end if;

            
				   		  
			
	      if button4 = '1' and button4_state = '0' then
                
					 player_state := not player_state;
				    button4_hold <='0';
					 button4_holding <='0';
					 button4_state <= '1';
            end if;

        if button5 = '1' and button5_state = '0' then
                
					 player_state := not player_state;
				    button5_hold <='0';
					 button5_holding <='0';
					 button5_state <= '1';
            end if;
		  
		  if button6 = '1' and button6_state = '0' then
                
					 player_state := not player_state;
				    button6_hold <='0';
					 button6_holding <='0';
					 button6_state <= '1';
            end if;
		 
		 
		 if button7 = '1' and button7_state = '0' then
                
					 player_state := not player_state;
				    button7_hold <='0';
					 button7_holding <='0';
					 button7_state <= '1';
            end if;
				
				
		  if button8 = '1' and button8_state = '0' then
                
					 player_state := not player_state;
				    button8_hold <='0';
					 button8_holding <='0';
					 button8_state <= '1';
            end if;
		  
		  if button9 = '1' and button9_state = '0' then
                
					 player_state := not player_state;
				    button9_hold <='0';
					 button9_holding <='0';
					 button9_state <= '1';
            end if;
	
end if;	
		
	
	
    if rising_edge(clock) then
   	
		if button1_holding ='0' or	 button2_holding ='0' or button3_holding ='0' or 
		   button4_holding ='0' or	 button5_holding ='0' or button6_holding ='0' or 
			button7_holding ='0' or	 button8_holding ='0' or button9_holding ='0'  then
			    
				 count1<= count1 + "0001"; 
				-- player_state := not player_state;
				 button1_holding<='1';
				 button2_holding<='1';
				 button3_holding<='1';
             button4_holding<='1';
				 button5_holding<='1';
				 button6_holding<='1';
				 button7_holding<='1';
				 button8_holding<='1';
				 button9_holding<='1';
				
				 
	   end if;	  
	          	  	  
end if;
		
           
 end process button_hold;
 
	
	
		  
		  

		  h_dat_proc: process (clock,vga_clk)
		  variable pos1_s0: std_logic:='0'; 
		  variable pos1_s1: std_logic:='0'; 
		  variable pos2_s0: std_logic:='0'; 
		  variable pos2_s1: std_logic:='0'; 
		  variable pos3_s0: std_logic:='0'; 
		  variable pos3_s1: std_logic:='0'; 
		  begin
			 if rising_edge(clock) then
				  
				  
				  
				  --------1st column
				  ------R1C1------
		 if unsigned(hcount) < 303 and unsigned(vcount) < 194 then
		 h_dat <= r1c1_colur;
				   case button1_hold is
						 when '0' => 	 
						 
		       if rising_edge(clock) and button1='1' then 
		                      if button1_count=x"225510" then
			 
			                 button1_count  <= (others=>'0');
			                    
			                  else
			                  button1_count <= button1_count + 1;
			                  end if;
		            end if;	
						
						           
							if button1_count=x"225510" then	  
									  case player_state is
															  when '0' => 
												if  pos1_s0='0' then			  
												pos1_s0:='1';	
												pos1_s1:='1';
												
															  if player1_r1c1_enable='0' then
															  r1c1_colur <= "100";
															  p1_pos1 <='1';
															 else
															  r1c1_colur <= "001";
															  player2_r1c1_enable<='0';
															  player1_r1c1_enable<='1';
															  p2_pos1 <='1';
															 end if;
												end if;
				                                  when others =>
															 
												   if  pos1_s1='0' then	
													      pos1_s0:='1';	
												         pos1_s1:='1';
															 if player2_r1c1_enable='0' then 
																 
																 r1c1_colur <= "001";
																 p2_pos1 <='1';
															 else	 
															 
															  r1c1_colur <= "100";
															 player1_r1c1_enable<='0';
															 player2_r1c1_enable<='1';
															 p1_pos1 <='1'; 
															 end if;
													end if;		 
															end case; 
															
					end if;				 
															  
			when others =>
					   pos1_s0:='0';	
						pos1_s1:='0';	
						r1c1_colur <= "111";
						player1_r1c1_enable<='1';
						player2_r1c1_enable<='1';
						p1_pos1 <='0';
						p2_pos1 <='0';
						button1_count  <= (others=>'0');    	
			end case; 		
						
						
						
					------R2C1	
					elsif unsigned(hcount) < 303 and unsigned(vcount) > 194 and unsigned(vcount) < 354 then
						h_dat <= r2c1_colur;
						case button2_hold is
						 when '0' => 
						   if rising_edge(clock) and button2='1' then 
		                      if button2_count=x"225510" then
			 
			                 button2_count  <= (others=>'0');
			                    
			                  else
			                  button2_count <= button2_count + 1;
			                  end if;
		            end if;	
						 
						   if button2_count=x"225510"  then  
									 case player_state is
															  when '0' => 
															  
														if  pos2_s0='0' then			  
												      pos2_s0:='1';	
												      pos2_s1:='1';	  
											              if player1_r2c1_enable='0' then
											 
															  r2c1_colur <= "100";
															  p1_pos2 <='1';
															 else
															  
															  r2c1_colur <= "001";
															  player2_r2c1_enable<='0';
															  player1_r2c1_enable<='1';

															  p2_pos2 <='1';
															 end if;
								              end if;
					                               when others =>
									                   if  pos2_s1='0' then	
													         pos2_s0:='1';	
												            pos2_s1:='1';
															 if player2_r2c1_enable='0' then 
															  
																 r2c1_colur <= "001";
																 p2_pos2 <='1';
															 else	 
															 
															  r2c1_colur <= "100";
															 player1_r2c1_enable<='0';
															 player2_r2c1_enable<='1';

															 p1_pos2 <='1'; 
															 end if;
													end if;		 
									                  end case;
					    
                   end if;						 
					   when others =>
				      pos2_s0:='0';	
						pos2_s1:='0';
						r2c1_colur <= "111";
						player1_r2c1_enable<='1';
						player2_r2c1_enable<='1';
						p1_pos2 <='0';
						p2_pos2 <='0';
						button2_count  <= (others=>'0');
					end case;
					
				----R3C1------	 
				elsif unsigned(hcount) < 303 and unsigned(vcount) > 354 and unsigned(vcount) < 514 then
				 h_dat <= r3c1_colur;
				 
				 case button3_hold is
						 when '0' => 
						    
							 if rising_edge(clock) and button3='1' then 
		                      if button3_count=x"225510" then
			 
			                 button3_count  <= (others=>'0');
			                    
			                  else
			                  button3_count <= button3_count + 1;
			                  end if;
		            end if;	
						    
					       if button3_count=x"225510"  then 
									 case player_state is
															  when '0' =>
														if  pos3_s0='0' then			  
												        pos3_s0:='1';	
												        pos3_s1:='1';	 	  
															  if player1_r3c1_enable='0' then
															 
															  r3c1_colur <= "100";
															  p1_pos3 <='1';
															 else
															 
															  r3c1_colur <= "001";
															  player2_r3c1_enable<='0';
															  player1_r3c1_enable<='1';

															  p2_pos3 <='1';
															 end if;
						                      end if;
				                                  when others =>
									                   if  pos3_s1='0' then	
													         pos3_s0:='1';	
												            pos3_s1:='1';
															 if player2_r3c1_enable='0' then 
																
																 r3c1_colur <= "001";
																 p2_pos3 <='1';
															 else	 
															  
															  r3c1_colur <= "100";
															 player1_r3c1_enable<='0';
															 player2_r3c1_enable<='1';

															 p1_pos3 <='1'; 
															 end if;
													end if;		 
															 end case;
									   
				end if;
			     when others =>						  
		            pos3_s0:='0';	
						pos3_s1:='0';
					
						r3c1_colur <= "111";
						player1_r3c1_enable<='1';
						player2_r3c1_enable<='1';
						p1_pos3 <='0';
						p2_pos3 <='0';
						button3_count  <= (others=>'0');
					end case;		
					
			  	   --	elsif unsigned(hcount) < 223 and unsigned(vcount) > 214 and unsigned(vcount) < 274 then
					--   v_dat <= "000";
					--	h_dat <= "011"; 
					 
					 --elsif unsigned(hcount) < 223 and unsigned(vcount) > 274 and unsigned(vcount) < 334 then
					  -- v_dat <= "000";
					 --h_dat <= "011";
					 
					--elsif unsigned(hcount) < 223 and unsigned(vcount) > 334 and unsigned(vcount) < 394 then
					  -- v_dat <= "000";
						--h_dat <= "011"; 
					--elsif unsigned(hcount) < 223 and unsigned(vcount) > 394 and unsigned(vcount) < 454 then
						--v_dat <= "000";
						--h_dat <= "011"; 
				  -- elsif unsigned(hcount) < 223 and unsigned(vcount) > 454 and unsigned(vcount) < 514 then
				  -- v_dat <= "000";
						--h_dat <= "011";	
						
				
						
					---- 2nd column 
					----R1C2
					elsif unsigned(hcount) > 303 and unsigned(hcount) < 463 and unsigned(vcount) < 194 then
					  h_dat <= r1c2_colur;
					  case button4_hold is
						 when '0' => 
						      if rising_edge(clock) then 
		                      if button4_count=x"25510" then
			 
			                 button4_count  <= (others=>'0');
			                    
			                  else
			                  button4_count <= button4_count + 1;
			                  end if;      
						     end if;
							  
					       if button4_count=x"25510"  then 
									               case player_state is
															  when '0' =>       
															  if player1_r1c2_enable='0' then
															 
															  r1c2_colur <= "100";
															  p1_pos4 <='1';
															 else
															  v_dat <= "001";
															  r1c2_colur <= "001";
															  player2_r1c2_enable<='0';
															  player1_r1c2_enable<='1';
															  p2_pos4 <='1';
															 end if;
						
					                               when others =>
									  
															 if player2_r1c2_enable='0' then 
															 
																 r1c2_colur <= "001";
																 p2_pos4 <='1';
															 else	 
															  v_dat <= "100";
															  r1c2_colur <= "100";
															 player1_r1c2_enable<='0';
															 player2_r1c2_enable<='1';
															p1_pos4 <='1'; 
															 end if;
																
					                            end case; 
														 
			    end if;
			when others =>	
						r1c2_colur <= "111";
						player1_r1c2_enable<='1';
						player2_r1c2_enable<='1';
						p1_pos4 <='0';
						p2_pos4 <='0';
						button4_count  <= (others=>'0');
					   end case;		
				----R2C2		
						
					 elsif unsigned(hcount) > 303 and unsigned(hcount) < 463 and unsigned(vcount) > 194 and unsigned(vcount) < 354 then
						h_dat <= r2c2_colur;
						case button5_hold is
						    when '0' => 
						        if rising_edge(clock) then 
		                      if button5_count=x"225510" then
			 
			                 button5_count  <= (others=>'0');
			                    
			                  else
			                  button5_count <= button5_count + 1;
			                  end if;      
						     end if;
							  
					       if button5_count=x"225510"  then 
									               case player_state is
															  when '0' =>  
						           
															  if player1_r2c2_enable='0' then
															  
															  r2c2_colur <= "100";
															  p1_pos5 <='1';
															 else
															 
															  r2c2_colur <= "001";
															  player2_r2c2_enable<='0';
															  player1_r2c2_enable<='1';
															  p2_pos5 <='1';
															 end if;
												
					                              when others =>	 
									  
															 if player2_r2c2_enable='0' then 
															  
																 r2c2_colur <= "001";
																 p2_pos5 <='1';
															 else	 
															 
															  r2c2_colur <= "100";
															 player1_r2c2_enable<='0';
															 player2_r2c2_enable<='1';
															 p1_pos5 <='1'; 
															 end if;
																
					                            end case; 
						end if;								 
				    when others =>	 
					
						r2c2_colur <= "111";
						player1_r2c2_enable<='1';
						player2_r2c2_enable<='1';
						p1_pos5 <='0';
						p2_pos5 <='0';
						button5_count  <= (others=>'0');
					end case;		
				---R3C2	 
					elsif unsigned(hcount) > 303 and unsigned(hcount) < 463 and unsigned(vcount) > 354 and unsigned(vcount) < 514 then
					  h_dat <= r3c2_colur;
					  case button6_hold is
						 when '0' => 
						      if rising_edge(clock) then 
		                      if button6_count=x"225510" then
			 
			                 button6_count  <= (others=>'0');
			                    
			                  else
			                  button6_count <= button6_count + 1;
			                  end if;      
						     end if;
							  
					       if button6_count=x"225510"  then 
									               case player_state is
															  when '0' =>    
						  
															  if player1_r3c2_enable='0' then
															 
															  r3c2_colur <= "100";
															  p1_pos6 <='1';
															 else
															 
															  r3c2_colur <= "001";
															  player2_r3c2_enable<='0';
															  player1_r3c2_enable<='1';

															  p2_pos6 <='1';
															 end if;
						
					                                when others =>	
									  
															 if player2_r3c2_enable='0' then 
															  
																 r3c2_colur <= "001";
																 p2_pos6 <='1';
															 else	 
															 
															  r3c2_colur <= "100";
															 player1_r3c2_enable<='0';
															 player2_r3c2_enable<='1';

															 p1_pos6 <='1'; 
															 end if;
																
					                               end case; 
				end if;											 
				 when others =>	
					
						r3c2_colur <= "111";
						player1_r3c2_enable<='1';
						player2_r3c2_enable<='1';
						p1_pos6 <='0';
						p2_pos6 <='0';
						button6_count  <= (others=>'0');
					end case;		  
					
					--elsif unsigned(hcount) > 223 and unsigned(hcount) < 303 and unsigned(vcount) > 214 and unsigned(vcount) < 274 then
						--v_dat <= "000";
						--h_dat <= "011"; 
					 
					-- elsif unsigned(hcount) > 223 and unsigned(hcount) < 303 and unsigned(vcount) > 274 and unsigned(vcount) < 334 then
					  -- v_dat <= "000";
						--h_dat <= "011";
					 
					--elsif unsigned(hcount) > 223 and unsigned(hcount) < 303 and unsigned(vcount) > 334 and unsigned(vcount) < 394 then
					  -- v_dat <= "000";
						--h_dat <= "000"; 
					--elsif unsigned(hcount) > 223 and unsigned(hcount) < 303 and unsigned(vcount) > 394 and unsigned(vcount) < 454 then
					  -- v_dat <= "000";
						--h_dat <= "000"; 
					--elsif unsigned(hcount) > 223 and unsigned(hcount) < 303 and unsigned(vcount) > 454 and unsigned(vcount) < 514 then
					  -- v_dat <= "000";
						--h_dat <= "011";	
				
			

			------ 3rd column   
				----R1C3	 
					elsif unsigned(hcount) > 463 and unsigned(hcount) < 623 and unsigned(vcount) < 194 then
					 h_dat <= r1c3_colur;
					    case button7_hold is
						 when '0' => 
						      if rising_edge(clock) then 
		                      if button7_count=x"225510" then
			 
			                 button7_count  <= (others=>'0');
			                    
			                  else
			                  button7_count <= button7_count + 1;
			                  end if;      
						     end if;
							  
					       if button7_count=x"225510"  then 
									               case player_state is
															  when '0' =>    
									
															  if player1_r1c3_enable='0' then
															  
															  r1c3_colur <= "100";
															  p1_pos7 <='1';
															 else
															  
															  r1c3_colur <= "001";
															  player2_r1c3_enable<='0';
															  player1_r1c3_enable<='1';
															  p2_pos7 <='1';
															 end if;
												
													       when others =>	
															  
															 if player2_r1c3_enable='0' then 
																 
																 r1c3_colur <= "001";
																 p2_pos7 <='1';
															 else	 
															  
															 r1c3_colur <= "100";
															 player1_r1c3_enable<='0';
															 player2_r1c3_enable<='1'; 
															 p1_pos7 <='1';
															 end if;
															 end case;
																
					  end if;  
				when others =>	
						
						r1c3_colur <= "111";
						player1_r1c3_enable<='1';
						player2_r1c3_enable<='1';
						p1_pos7 <='0';
						p2_pos7 <='0';
						button7_count  <= (others=>'0');
					end case;		
					----R2C3	
					 elsif unsigned(hcount) > 463 and unsigned(hcount) < 623 and unsigned(vcount) > 194 and unsigned(vcount) < 354 then
						h_dat <= r2c3_colur;
						    case button8_hold is
						       when '0' => 
						         if rising_edge(clock) then 
		                      if button8_count=x"225510" then
			 
			                 button8_count  <= (others=>'0');
			                    
			                  else
			                  button8_count <= button8_count + 1;
			                  end if;      
						     end if;
							  
					       if button8_count=x"225510"  then 
									               case player_state is
															        when '0' =>    
																	 if player1_r2c3_enable='0' then
																	  
																	  r2c3_colur <= "100";
																	  p1_pos8 <='1';
																	 else
																	  
																	  r2c3_colur <= "001";
																	  player2_r2c3_enable<='0';
																	  player1_r2c3_enable<='1';
																	  p2_pos8 <='1';
																	 end if;
														
														     when others =>	
																	  
																	 if player2_r2c3_enable='0' then 
																		 
																		 r2c3_colur <= "001";
																		 p2_pos8 <='1';
																	 else	 
																	  
																	  r2c3_colur <= "100";
																	 player1_r2c3_enable<='0';
																	 player2_r2c3_enable<='1';
																	 p1_pos8 <='1'; 
																	 end if;
																	 end case;
									   
					    end if; 
			         when others =>	
						
						r2c3_colur <= "111";
						player1_r2c3_enable<='1';
						player2_r2c3_enable<='1';
						p1_pos8 <='0';
						p2_pos8 <='0';
						button8_count  <= (others=>'0');
					end case;		
				------R3C3	 
					elsif unsigned(hcount) > 463 and unsigned(hcount) < 623 and unsigned(vcount) > 354 and unsigned(vcount) < 514 then
					 h_dat <= r3c3_colur;
					    case button9_hold is
						       when '0' => 
						         if rising_edge(clock) then 
		                      if button9_count=x"225510" then
			 
			                 button9_count  <= (others=>'0');
			                    
			                  else
			                  button9_count <= button9_count + 1;
			                  end if;      
						     end if;
							  
					       if button9_count=x"225510"  then 
									               case player_state is
															        when '0' => 
						  
																	  if player1_r3c3_enable='0' then
																	  
																	  r3c3_colur <= "100";
																	  p1_pos9 <='1';
																	 else
																	  
																	  r3c3_colur <= "001";
																	  player2_r3c3_enable<='0';
																	  player1_r3c3_enable<='1';
																	  p2_pos9 <='1';
																	 end if;
														
														    when others =>	
																	  
																	 if player2_r3c3_enable='0' then 
																		 
																		 r3c3_colur <= "001";
																		 p2_pos9 <='1';
																	 else	 
																	  
																	 r3c3_colur<= "100";
																	 player1_r3c3_enable<='0'; 
																	 player2_r3c3_enable<='1';
																	 p1_pos9 <='1';
																	 end if;
																	 end case;
																		
					    end if;  
			         when others =>	
						
						r3c3_colur <= "111";
						player1_r3c3_enable<='1';
						player2_r3c3_enable<='1';
						p1_pos9 <='0';
						p2_pos9 <='0';
						button9_count  <= (others=>'0');
					end case;		
					
					--elsif unsigned(hcount) > 303 and unsigned(hcount) < 383 and unsigned(vcount) > 214 and unsigned(vcount) < 274 then
						--v_dat <= "000";
						--h_dat <= "011"; 
					 
					 --elsif unsigned(hcount) > 303 and unsigned(hcount) < 383 and unsigned(vcount) > 274 and unsigned(vcount) < 334 then
						--v_dat <= "000";
						--h_dat <= "011";
					 
					--elsif unsigned(hcount) > 303 and unsigned(hcount) < 383 and unsigned(vcount) > 334 and unsigned(vcount) < 394 then
						--v_dat <= "000";
						--h_dat <= "000"; 
					--elsif unsigned(hcount) > 303 and unsigned(hcount) < 383 and unsigned(vcount) > 394 and unsigned(vcount) < 454 then
					  -- v_dat <= "000";
						--h_dat <= "000"; 
				  -- elsif unsigned(hcount) > 303 and unsigned(hcount) < 383 and unsigned(vcount) > 454 and unsigned(vcount) < 514 then
					  -- v_dat <= "000";
						--h_dat <= "011";	
				 
		----- 4th column		
					
					--elsif unsigned(hcount) > 383 and unsigned(hcount) < 463 and unsigned(vcount) < 94 then
					  -- v_dat <= "000";
						--h_dat <= "011";
						
					-- elsif unsigned(hcount) > 383 and unsigned(hcount) < 463 and unsigned(vcount) > 94 and unsigned(vcount) < 154 then
					 --  v_dat <= "000";
						--h_dat <= "011"; 
					 
				  -- elsif unsigned(hcount) > 383 and unsigned(hcount) < 463 and unsigned(vcount) > 154 and unsigned(vcount) < 214 then
					 --  v_dat <= "000";
						--h_dat <= "011";  
					
					--elsif unsigned(hcount) > 383 and unsigned(hcount) < 463 and unsigned(vcount) > 214 and unsigned(vcount) < 274 then
					  -- v_dat <= "000";
						--h_dat <= "011"; 
					 
					-- elsif unsigned(hcount) > 383 and unsigned(hcount) < 463 and unsigned(vcount) > 274 and unsigned(vcount) < 334 then
					  -- v_dat <= "000";
						--h_dat <= "011";
					 
					--elsif unsigned(hcount) > 383 and unsigned(hcount) <  463 and unsigned(vcount) > 334 and unsigned(vcount) < 394 then
					  -- v_dat <= "000";
						--h_dat <= "011"; 
					--elsif unsigned(hcount) > 383 and unsigned(hcount) < 463 and unsigned(vcount) > 394 and unsigned(vcount) < 454 then
					  -- v_dat <= "000";
						--h_dat <= "011"; 
				  -- elsif unsigned(hcount) > 383 and unsigned(hcount) < 463 and unsigned(vcount) > 454 and unsigned(vcount) < 514 then
					--   v_dat <= "000";
					--	h_dat <= "011";	

		--------5th column 
				  
				  
				-- elsif unsigned(hcount) > 463 and unsigned(hcount) < 543 and unsigned(vcount) < 94 then
					  -- v_dat <= "000";
						--h_dat <= "011";
						
					-- elsif unsigned(hcount) > 463 and unsigned(hcount) < 543 and unsigned(vcount) > 94 and unsigned(vcount) < 154 then
					 --  v_dat <= "000";
						--h_dat <= "000"; 
					 
				--   elsif unsigned(hcount) > 463 and unsigned(hcount) < 543 and unsigned(vcount) > 154 and unsigned(vcount) < 214 then
					--   v_dat <= "000";
					--	h_dat <= "000";  
					
					--elsif unsigned(hcount) > 463 and unsigned(hcount) < 543 and unsigned(vcount) > 214 and unsigned(vcount) < 274 then
					  -- v_dat <= "000";
						--h_dat <= "011"; 
					 
					 --elsif unsigned(hcount) > 463 and unsigned(hcount) < 543 and unsigned(vcount) > 274 and unsigned(vcount) < 334 then
					 --  v_dat <= "000";
						--h_dat <= "011";
					 
					--elsif unsigned(hcount) > 463 and unsigned(hcount) < 543 and unsigned(vcount) > 334 and unsigned(vcount) < 394 then
					  -- v_dat <= "000";
						--h_dat <= "000"; 
					--elsif unsigned(hcount) > 463 and unsigned(hcount) < 543 and unsigned(vcount) > 394 and unsigned(vcount) < 454 then
					  -- v_dat <= "000";
						--h_dat <= "000"; 
				  -- elsif unsigned(hcount) > 463 and unsigned(hcount) < 543 and unsigned(vcount) > 454 and unsigned(vcount) < 514 then
					  -- v_dat <= "000";
						--h_dat <= "011";	
				
		-------6th column 


				--  elsif unsigned(hcount) > 543 and unsigned(hcount) < 623 and unsigned(vcount) < 94 then
					 --  v_dat <= "000";
					--	h_dat <= "011";
						
					-- elsif unsigned(hcount) > 543 and unsigned(hcount) < 623 and unsigned(vcount) > 94 and unsigned(vcount) < 154 then
					 --  v_dat <= "000";
					--	h_dat <= "000"; 
					 
				 --  elsif unsigned(hcount) > 543 and unsigned(hcount) < 623 and unsigned(vcount) > 154 and unsigned(vcount) < 214 then
					--   v_dat <= "000";
					--	h_dat <= "000";  
					
					--elsif unsigned(hcount) > 543 and unsigned(hcount) < 623 and unsigned(vcount) > 214 and unsigned(vcount) < 274 then
					  -- v_dat <= "000";
						--h_dat <= "011"; 
					 
					-- elsif unsigned(hcount) > 543 and unsigned(hcount) < 623 and unsigned(vcount) > 274 and unsigned(vcount) < 334 then
					  -- v_dat <= "000";
						--h_dat <= "011";
					 
				--	elsif unsigned(hcount) > 543 and unsigned(hcount) < 623 and unsigned(vcount) > 334 and unsigned(vcount) < 394 then
					 --  v_dat <= "000";
					--	h_dat <= "000"; 
				--	elsif unsigned(hcount) > 543 and unsigned(hcount) < 623 and unsigned(vcount) > 394 and unsigned(vcount) < 454 then
					 --  v_dat <= "000";
						--h_dat <= "000"; 
				  -- elsif unsigned(hcount) > 543 and unsigned(hcount) < 623 and unsigned(vcount) > 454 and unsigned(vcount) < 514 then
					 --  v_dat <= "000";
					--	h_dat <= "011";			
						
						
			-----7th column 


				--  elsif unsigned(hcount) > 623 and unsigned(hcount) < 703 and unsigned(vcount) < 94 then
				  --    v_dat <= "000";
					--	h_dat <= "011";
						
				--	 elsif unsigned(hcount) > 623 and unsigned(hcount) < 703 and unsigned(vcount) > 94 and unsigned(vcount) < 154 then
				  --    v_dat <= "000";
					--	h_dat <= "011"; 
					 
				 --  elsif unsigned(hcount) > 623 and unsigned(hcount) < 703 and unsigned(vcount) > 154 and unsigned(vcount) < 214 then
					--   v_dat <= "000";
					--	h_dat <= "011";  
					
					--elsif unsigned(hcount) > 623 and unsigned(hcount) < 703 and unsigned(vcount) > 214 and unsigned(vcount) < 274 then
					 --  v_dat <= "000";
						--h_dat <= "011"; 
					 
					-- elsif unsigned(hcount) > 623 and unsigned(hcount) < 703 and unsigned(vcount) > 274 and unsigned(vcount) < 334 then
					  -- v_dat <= "000";
						--h_dat <= "011";
					 
					--elsif unsigned(hcount) > 623 and unsigned(hcount) < 703 and unsigned(vcount) > 334 and unsigned(vcount) < 394 then
					  -- v_dat <= "000";
						--h_dat <= "011"; 
					--elsif unsigned(hcount) > 623 and unsigned(hcount) < 703 and unsigned(vcount) > 394 and unsigned(vcount) < 454 then
					 --  v_dat <= "000";
					--	h_dat <= "011"; 
				  -- elsif unsigned(hcount) > 623 and unsigned(hcount) < 703 and unsigned(vcount) > 454 and unsigned(vcount) < 514 then
					 --  v_dat <= "000";
						--h_dat <= "011";		
						

					
				------8th column 
			
				 
				
				  -- elsif unsigned(hcount) > 703 and unsigned(hcount) < 783 and unsigned(vcount) < 94 then
					 --  v_dat <= "000";
					--	h_dat <= "011";
						
					-- elsif unsigned(hcount) > 703 and unsigned(hcount) < 783 and unsigned(vcount) > 94 and unsigned(vcount) < 154 then
					 --  v_dat <= "000";
					--	h_dat <= "000"; 
					 
				 --  elsif unsigned(hcount) > 703 and unsigned(hcount) < 783 and unsigned(vcount) > 154 and unsigned(vcount) < 214 then
					 --  v_dat <= "000";
					--	h_dat <= "000";  
					
					--elsif unsigned(hcount) > 703 and unsigned(hcount) < 783 and unsigned(vcount) > 214 and unsigned(vcount) < 274 then
					  -- v_dat <= "000";
						--h_dat <= "011"; 
					 
					-- elsif unsigned(hcount) > 703 and unsigned(hcount) < 783 and unsigned(vcount) > 274 and unsigned(vcount) < 334 then
					  -- v_dat <= "000";
						--h_dat <= "011";
					 
				--	elsif unsigned(hcount) > 703 and unsigned(hcount) < 783 and unsigned(vcount) > 334 and unsigned(vcount) < 394 then
					  -- v_dat <= "000";
						--h_dat <= "000"; 
					--elsif unsigned(hcount) > 703 and unsigned(hcount) < 783 and unsigned(vcount) > 394 and unsigned(vcount) < 454 then
					 --  v_dat <= "000";
					--	h_dat <= "000"; 
				  -- elsif unsigned(hcount) > 703 and unsigned(hcount) < 783 and unsigned(vcount) > 454 and unsigned(vcount) < 514 then
					 --  v_dat <= "000";
					--	h_dat <= "011";		

						
						
						
						
					-------row bora aro 5 ta
				
				
					
					 
					 -------------column borabor 

						
					 else
						v_dat <= "000";
						h_dat <= "000";
						
					 end if;
				  
			 end if;
		  end process h_dat_proc;
		  
	winer_declaretion_process: process (p1_pos1,p1_pos2,p1_pos3,p1_pos4,
                                       p1_pos5,p1_pos6,p1_pos7,p1_pos8,
													p1_pos9,p2_pos1,p2_pos2,p2_pos3,
													p2_pos4,p2_pos5,p2_pos6,p2_pos7,
													p2_pos8,p2_pos9)	
  begin
  
  if rising_edge (vga_clk) then 
  
  if (p1_pos1='1' and p1_pos2='1' and p1_pos3='1') OR 
     (p1_pos4='1' and p1_pos5='1' and p1_pos6='1') OR
	  (p1_pos7='1' and p1_pos8='1' and p1_pos9='1') OR
	  (p1_pos1='1' and p1_pos4='1' and p1_pos7='1') OR
	  (p1_pos2='1' and p1_pos5='1' and p1_pos8='1') OR
	  (p1_pos3='1' and p1_pos6='1' and p1_pos9='1') OR
	  (p1_pos1='1' and p1_pos5='1' and p1_pos9='1') OR
	  (p1_pos7='1' and p1_pos5='1' and p1_pos3='1')    then
	  
	  
	  case reset is
      when '0' =>
		        winner_p1<='0';
				  displayed_number4 <= "0000";
		       	
		
     when others =>
	          winner_p1<='1';
				 displayed_number4 <= "0001";
	 
    end case;
	  
	
   elsif (p2_pos1='1' and p2_pos2='1' and p2_pos3='1') OR 
     (p2_pos4='1' and p2_pos5='1' and p2_pos6='1') OR
	  (p2_pos7='1' and p2_pos8='1' and p2_pos9='1') OR
	  (p2_pos1='1' and p2_pos4='1' and p2_pos7='1') OR
	  (p2_pos2='1' and p2_pos5='1' and p2_pos8='1') OR
	  (p2_pos3='1' and p2_pos6='1' and p2_pos9='1') OR
	  (p2_pos1='1' and p2_pos5='1' and p2_pos9='1') OR
	  (p2_pos7='1' and p2_pos5='1' and p2_pos3='1')    then
	  
	  case reset is
      when '0' =>
		        winner_p2<='0';
				  displayed_number4 <= "0000";
		       	
		
     when others =>
	          winner_p2<='1';
				 displayed_number4 <= "0010";
	          
    end case;
	  
	  
  else 
      case reset is
      when '0' =>
		        draw<='0';
		       	
		
     when others =>
	          draw<='1';
	 
    end case;
		
   end if;

end if;


   

end process winer_declaretion_process;	
  
  
  
  
  
  led1<=player_state;
  
  led2<=winner_p1;
  led3<=winner_p2;
	led4<='1';	  

		end Behavioral;
