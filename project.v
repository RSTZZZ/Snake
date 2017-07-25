// Part 2 skeleton

module project(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
		  LEDR,
		  SW,
		  HEX0,
		  HEX1,
		  HEX2,
		  HEX7,
		  HEX6,
		  HEX5,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [3:0]   KEY;
	input [17:0] SW;
	output [17:0] LEDR;
	output [7:0] HEX0, HEX1, HEX2, HEX7, HEX6, HEX5;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
   
	
	//scoreboard
	hex_decoder hex0(
		.hex_digit(counter1),
		.segments(HEX0)
	);
	
		hex_decoder hex1(
		.hex_digit(counter10),
		.segments(HEX1)
	);
	
		hex_decoder hex2(
		.hex_digit(counter100),
		.segments(HEX2)
	);
	
		hex_decoder hex7(
		.hex_digit(hscounter100),
		.segments(HEX7)
	);
	
		hex_decoder hex6(
		.hex_digit(hscounter10),
		.segments(HEX6)
	);
	
		hex_decoder hex5(
		.hex_digit(hscounter1),
		.segments(HEX5)
	);
	
	

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(1'b1),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
	 
	 reg [7:0] state;
	 reg border_initing, paddle_initing, ball_initing, block_initing;
	 reg [7:0] x, y;
	 reg [7:0] p_x, p_y, b_x, b_y, bl_1_x, bl_1_y, bl_2_x, bl_2_y, bl_3_x, bl_3_y, bl_4_x, bl_4_y, bl_5_x, bl_5_y, bl_6_x, bl_6_y, bl_7_x, bl_7_y, bl_8_x, bl_8_y, bl_9_x, bl_9_y, bl_10_x, bl_10_y;
	 reg [7:0] p1_x, p2_x, p3_x, p4_x;
	 reg [7:0] p1_y, p2_y, p3_y, p4_y;
	 reg [7:0] p5_x, p6_x, p7_x, p8_x;
	 reg [7:0] p5_y, p6_y, p7_y, p8_y;
	 reg [7:0] p9_x, p10_x, p11_x, p12_x;
	 reg [7:0] p9_y, p10_y, p11_y, p12_y;
	 reg [2:0] colour;
	 reg b_x_direction, b_y_direction;
	 reg bl2_x_direction, bl2_y_direction;
	 reg bl3_x_direction, bl3_y_direction;
	 reg bl4_x_direction, bl4_y_direction;
	 reg bl5_x_direction, bl5_y_direction;
	 reg [17:0] draw_counter;
	 
	 reg [2:0] snake_colour;
	 reg [2:0] block_1_colour, block_2_colour, block_3_colour, block_4_colour, block_5_colour, block_6_colour, block_7_colour, block_8_colour, block_9_colour, block_10_colour;
	 reg [2:0] prev_dir;
	 reg [3:0] counter1, counter10, counter100;
	 reg [3:0] hscounter1, hscounter10, hscounter100;
	 
	 reg [4:0] snake_length;
	 reg [2:0] speed;
	 
	 reg [7:0] block2_counter;
	 reg [7:0] block3_counter;
	 reg [7:0] block4_counter;
	 reg [7:0] block5_counter;
	 
	 wire frame;
	 
	 assign LEDR[5:0] = state;
	 
	 localparam  RESET_BLACK       = 7'd0,
                INIT_PADDLE       = 7'd1,
					 INIT_PADDLE1		 = 7'd2,
					 INIT_PADDLE2		 = 7'd3,
					 INIT_PADDLE3	    = 7'd4,
					 INIT_PADDLE4	    = 7'd5,
					 INIT_PADDLE5      = 7'd6,
					 INIT_PADDLE6		 = 7'd7,
					 INIT_PADDLE7		 = 7'd8,
					 INIT_PADDLE8	    = 7'd9,
					 INIT_PADDLE9	    = 7'd10,
					 INIT_PADDLE10     = 7'd11,
					 INIT_PADDLE11		 = 7'd12,
					 INIT_PADDLE12		 = 7'd13,
                INIT_BALL         = 7'd14,
                INIT_BLOCK_1      = 7'd15,
					 INIT_BLOCK_2      = 7'd16,
					 INIT_BLOCK_3      = 7'd17,
					 INIT_BLOCK_4      = 7'd18,
					 INIT_BLOCK_5      = 7'd19,
                IDLE              = 7'd20,
					 ERASE_PADDLE	    = 7'd21,
					 ERASE_PADDLE1		 = 7'd22,
					 ERASE_PADDLE2		 = 7'd23,
					 ERASE_PADDLE3	    = 7'd24,
					 ERASE_PADDLE4     = 7'd25,
					 ERASE_PADDLE5	    = 7'd26,
					 ERASE_PADDLE6		 = 7'd27,
					 ERASE_PADDLE7		 = 7'd28,
					 ERASE_PADDLE8	    = 7'd30,
					 ERASE_PADDLE9     = 7'd31,
					 ERASE_PADDLE10	 = 7'd32,
					 ERASE_PADDLE11    = 7'd33,
					 ERASE_PADDLE12    = 7'd34,
                UPDATE_PADDLE     = 7'd35,
					 UPDATE_PADDLE1	 = 7'd36,
					 UPDATE_PADDLE2	 = 7'd37,
					 UPDATE_PADDLE3	 = 7'd38,
					 UPDATE_PADDLE4	 = 7'd39,
					 UPDATE_PADDLE5	 = 7'd40,					
					 UPDATE_PADDLE6	 = 7'd41,
					 UPDATE_PADDLE7	 = 7'd42,
					 UPDATE_PADDLE8	 = 7'd43,
					 UPDATE_PADDLE9	 = 7'd44,
					 UPDATE_PADDLE10	 = 7'd45,
					 UPDATE_PADDLE11	 = 7'd46,
					 UPDATE_PADDLE12	 = 7'd47,
					 DRAW_PADDLE	    = 7'd48,
					 DRAW_PADDLE1		 = 7'd49,
					 DRAW_PADDLE2		 = 7'd50,
					 DRAW_PADDLE3		 = 7'd51,
					 DRAW_PADDLE4		 = 7'd52,
					 DRAW_PADDLE5	    = 7'd53,
					 DRAW_PADDLE6		 = 7'd54,
					 DRAW_PADDLE7		 = 7'd55,
					 DRAW_PADDLE8		 = 7'd56,
					 DRAW_PADDLE9		 = 7'd57,
					 DRAW_PADDLE10	    = 7'd58,
					 DRAW_PADDLE11		 = 7'd59,
					 DRAW_PADDLE12		 = 7'd60,
                ERASE_BALL        = 7'd61,
					 UPDATE_BALL       = 7'd62,
					 DRAW_BALL         = 7'd63,
					 ERASE_BLOCK_1     = 7'd64,
					 UPDATE_BLOCK_1    = 7'd65,
					 DRAW_BLOCK_1      = 7'd66,
					 ERASE_BLOCK_2     = 7'd67,
					 UPDATE_BLOCK_2    = 7'd68,
					 DRAW_BLOCK_2      = 7'd69,
					 ERASE_BLOCK_3     = 7'd70,
					 UPDATE_BLOCK_3    = 7'd71,
					 DRAW_BLOCK_3      = 7'd72,
					 ERASE_BLOCK_4     = 7'd73,
					 UPDATE_BLOCK_4    = 7'd74,
					 DRAW_BLOCK_4      = 7'd75,
					 ERASE_BLOCK_5     = 7'd76,
					 UPDATE_BLOCK_5    = 7'd77,
					 DRAW_BLOCK_5      = 7'd78,
					 DEAD    		    = 7'd79;

	 clock(.clock(CLOCK_50), .clk(frame));
	 assign LEDR[7] = ((b_y_direction) && (b_y > p_y - 8'd1) && (b_y < p_y + 8'd2) && (b_x >= p_x) && (b_x <= p_x + 8'd8));
	 always@(posedge CLOCK_50)
    begin
			border_initing = 1'b0;
			paddle_initing = 1'b0;
			ball_initing = 1'b0;
			block_initing = 1'b0;
			colour = 3'b000;
			x = 8'b00000000;
			y = 8'b00000000;
			if (~SW[17]) state = RESET_BLACK;
			if (~SW[0] && state!= DEAD) state = IDLE;
			if (counter100 > hscounter100) begin
				hscounter100 = counter100;
				hscounter10 = counter10;
				hscounter1 = counter1;
			end
			if (counter100 == hscounter100 && counter10 > hscounter10) begin
				hscounter10 = counter10;
				hscounter1 = counter1;
			end
			if (counter100 == hscounter100 && counter10 == hscounter10 && counter1 > hscounter1) begin
				hscounter1 = counter1;
			end
        case (state)
				  RESET_BLACK: begin
						if (draw_counter < 17'b10000000000000000) begin
								x = draw_counter[7:0];
								y = draw_counter[16:8];
								draw_counter = draw_counter + 1'b1;
								if (x == 8'd1 || x == 8'd159 ) colour= 3'd111;
						end
						else begin
							draw_counter= 8'b00000000;
							state = INIT_PADDLE;						if (snake_length >= 4'd2) begin
							if (p_x == p1_x || p_x == p2_x) state = DEAD;
						end
						end
							counter1 = 4'd0;
							counter10 = 4'd0;
							counter100 = 4'd0;
							snake_length = 4'd1;
							speed = 2'd1;
							snake_colour = 3'b111;
				end 
    			 INIT_PADDLE: begin
						// 00 up, 01 right, 02 left,03 down
					 prev_dir = 3'b100;
					 p_x = 8'd76;
					 p_y = 8'd100;
					 if (draw_counter < 3'b100) begin
						x = p_x + draw_counter[0];
						y = p_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE1;
					end
				 end
				INIT_PADDLE1: begin
					 p1_x = 8'd76;
					 p1_y = 8'd101;
					 if (draw_counter < 3'b100) begin
						x = p1_x + draw_counter[0];
						y = p1_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE2;
					end
				 end
				 INIT_PADDLE2: begin
					 p2_x = 8'd76;
					 p2_y = 8'd102;
					 if (draw_counter < 3'b100) begin
						x = p2_x + draw_counter[0];
						y = p2_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
//						colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE3;
					end
				 end
				 INIT_PADDLE3: begin
					 p3_x = 8'd76;
					 p3_y = 8'd103;
					 if (draw_counter < 3'b100) begin
						x = p3_x + draw_counter[0];
						y = p3_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
//						colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE4;
					end
				 end
				 INIT_PADDLE4: begin
					 p4_x = 8'd76;
					 p4_y = 8'd104;
					 if (draw_counter < 3'b100) begin
						x = p4_x + draw_counter[0];
						y = p4_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE5;
					end
				 end
				  INIT_PADDLE5: begin
					 p5_x = 8'd76;
					 p5_y = 8'd105;
					 if (draw_counter < 3'b100) begin
						x = p5_x + draw_counter[0];
						y = p5_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE6;
					end
				 end
				  INIT_PADDLE6: begin
					 p6_x = 8'd76;
					 p6_y = 8'd106;
					 if (draw_counter < 3'b100) begin
						x = p6_x + draw_counter[0];
						y = p6_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE7;
					end
				 end
				  INIT_PADDLE7: begin
					 p7_x = 8'd76;
					 p7_y = 8'd107;
					 if (draw_counter < 3'b100) begin
						x = p7_x + draw_counter[0];
						y = p7_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE8;
					end
				 end
				  INIT_PADDLE8: begin
					 p8_x = 8'd76;
					 p8_y = 8'd108;
					 if (draw_counter < 3'b100) begin
						x = p8_x + draw_counter[0];
						y = p8_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE9;
					end
				 end
				  INIT_PADDLE9: begin
					 p9_x = 8'd76;
					 p9_y = 8'd109;
					 if (draw_counter < 3'b100) begin
						x = p9_x + draw_counter[0];
						y = p9_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE10;
					end
				 end
				  INIT_PADDLE10: begin
					 p10_x = 8'd76;
					 p10_y = 8'd110;
					 if (draw_counter < 3'b100) begin
						x = p10_x + draw_counter[0];
						y = p10_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE11;
					end
				 end
				 INIT_PADDLE11: begin
					 p11_x = 8'd76;
					 p11_y = 8'd111;
					 if (draw_counter < 3'b100) begin
						x = p12_x + draw_counter[0];
						y = p12_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE12;
					end
				 end
				 INIT_PADDLE12: begin
					 p12_x = 8'd76;
					 p12_y = 8'd112;
					 if (draw_counter < 3'b100) begin
						x = p12_x + draw_counter[0];
						y = p12_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						//colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_BALL;
					end
				 end
				 INIT_BALL: begin
					 b_x = 8'd80;
					 b_y = 8'd50;
						x = b_x;
						y = b_y;
						colour = 3'b110;
						state = INIT_BLOCK_1;
				 end
				 INIT_BLOCK_1: begin
					 bl_1_x = 8'd90;
					 bl_1_y = 8'd90;
					 block_1_colour = 3'b111;
						state = INIT_BLOCK_2;
				 end
				 INIT_BLOCK_2: begin
					 bl_2_x = 8'd20;
					 bl_2_y = 8'd30;
					 block_2_colour = 3'b100;
					 block2_counter = 8'd0;
						state = INIT_BLOCK_3;
				 end
				 INIT_BLOCK_3: begin
					 bl_3_x = 8'd60;
					 bl_3_y = 8'd35;
					 block_3_colour = 3'b010;
					 block3_counter = 8'd0;
						state = INIT_BLOCK_4;
				 end
				 INIT_BLOCK_4: begin
					 bl_4_x = 8'd100;
					 bl_4_y = 8'd40;
					 block_4_colour = 3'b001;
					 block4_counter = 8'd0;
						state = INIT_BLOCK_5;
				 end
				 INIT_BLOCK_5: begin
					 bl_5_x = 8'd140;
					 bl_5_y = 8'd45;
					 block_5_colour = 3'b011;
					 block5_counter = 8'd0;
					state = IDLE;
				 end
				 IDLE: begin
					 if (frame)
						state = ERASE_PADDLE12;
				end
				 ERASE_PADDLE12: begin
						if (draw_counter < 4'b1000) begin
						x = p12_x + draw_counter[0];
						y = p12_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE11;
					end
				 end
				 ERASE_PADDLE11: begin
						if (draw_counter < 4'b1000) begin
						x = p11_x + draw_counter[0];
						y = p11_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE10;
					end
				 end
				 ERASE_PADDLE10: begin
						if (draw_counter < 4'b1000) begin
						x = p10_x + draw_counter[0];
						y = p10_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE9;
					end
				 end
				 ERASE_PADDLE9: begin
						if (draw_counter < 4'b1000) begin
						x = p9_x + draw_counter[0];
						y = p9_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE8;
					end
				 end
				 ERASE_PADDLE8: begin
						if (draw_counter < 4'b1000) begin
						x = p8_x + draw_counter[0];
						y = p8_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE7;
					end
				 end
				 ERASE_PADDLE7: begin
						if (draw_counter < 4'b1000) begin
						x = p7_x + draw_counter[0];
						y = p7_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE6;
					end
				 end
				 ERASE_PADDLE6: begin
						if (draw_counter < 4'b1000) begin
						x = p6_x + draw_counter[0];
						y = p6_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE5;
					end
				 end
				 ERASE_PADDLE5: begin
						if (draw_counter < 4'b1000) begin
						x = p5_x + draw_counter[0];
						y = p5_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE4;
					end
				 end
				 ERASE_PADDLE4: begin
						if (draw_counter < 4'b1000) begin
						x = p4_x + draw_counter[0];
						y = p4_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE3;
					end
				 end
				 ERASE_PADDLE3: begin
						if (draw_counter < 4'b1000) begin
						x = p3_x + draw_counter[0];
						y = p3_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE2;
					end
				 end
				 ERASE_PADDLE2: begin
						if (draw_counter < 4'b1000) begin
						x = p2_x + draw_counter[0];
						y = p2_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE1;
					end
				 end
				 ERASE_PADDLE1: begin
						if (draw_counter < 4'b1000) begin
						x = p1_x + draw_counter[0];
						y = p1_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_PADDLE;
					end
				 end
				 ERASE_PADDLE: begin
						if (draw_counter < 4'b1000) begin
						x = p_x + draw_counter[0];
						y = p_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_PADDLE12;
					end
				 end
				 UPDATE_PADDLE: begin
						if (~KEY[0] && p_x < 8'd157 && prev_dir != 2'b10) prev_dir = 2'b01;
						if (~KEY[3] && p_x > 8'd2 && prev_dir != 2'b01)	prev_dir = 2'b10;
						if (~KEY[1] && p_y < 8'd118 && prev_dir != 2'b00) prev_dir = 2'b11;
						if (~KEY[2] && p_y > 8'd1 && prev_dir != 2'b11) prev_dir = 2'b00;

						if (prev_dir == 2'b00 ) p_y = p_y - speed;
						if (prev_dir == 2'b01) p_x = p_x + speed;
						if (prev_dir == 2'b10 ) p_x = p_x - speed;
						if (prev_dir == 2'b11 ) p_y = p_y + speed;
						
						state = DRAW_PADDLE;
						// Enable for boundary
						if (p_x == 8'd0 || p_y ==8'd0 || p_x == 8'd159 || p_y == 8'd119) state = DEAD;
						// Collision

				 end
				  UPDATE_PADDLE1: begin
						if (prev_dir != 3'd4) begin
							p1_x = p_x;
							p1_y = p_y;
						end
						state = UPDATE_PADDLE;
				 end
				 UPDATE_PADDLE2: begin
						if (prev_dir != 3'd4) begin
							p2_x = p1_x;
							p2_y = p1_y;
						end
						state = UPDATE_PADDLE1;
				 end
				 UPDATE_PADDLE3: begin
						if (prev_dir != 3'd4) begin
							p3_x = p2_x;
							p3_y = p2_y;
						end
						state = UPDATE_PADDLE2;
				 end
				 UPDATE_PADDLE4: begin
						if (prev_dir != 3'd4) begin
							p4_x = p3_x;
							p4_y = p3_y;
						end
						state = UPDATE_PADDLE3;
				 end
				 UPDATE_PADDLE5: begin
						if (prev_dir != 3'd4) begin
							p5_x = p4_x;
							p5_y = p4_y;
						end
						state = UPDATE_PADDLE4;
				 end
				 UPDATE_PADDLE6: begin
						if (prev_dir != 3'd4) begin
							p6_x = p5_x;
							p6_y = p5_y;
						end
						state = UPDATE_PADDLE5;
				 end
				 UPDATE_PADDLE7: begin
						if (prev_dir != 3'd4) begin
							p7_x = p6_x;
							p7_y = p6_y;
						end
						state = UPDATE_PADDLE6;
				 end
				 UPDATE_PADDLE8: begin
						if (prev_dir != 3'd4) begin
							p8_x = p7_x;
							p8_y = p7_y;
						end
						state = UPDATE_PADDLE7;
				 end
				 UPDATE_PADDLE9: begin
						if (prev_dir != 3'd4) begin
							p9_x = p8_x;
							p9_y = p8_y;
						end
						state = UPDATE_PADDLE8;
				 end
				 UPDATE_PADDLE10: begin
						if (prev_dir != 3'd4) begin
							p10_x = p9_x;
							p10_y = p9_y;
						end
						state = UPDATE_PADDLE9;
				 end
				 UPDATE_PADDLE11: begin
						if (prev_dir != 3'd4) begin
							p11_x = p10_x;
							p11_y = p10_y;
						end
						state = UPDATE_PADDLE10;
				 end
				 UPDATE_PADDLE12: begin
						if (prev_dir != 3'd4) begin
							p12_x = p11_x;
							p12_y = p11_y;
						end
						state = UPDATE_PADDLE11;
				 end
				 DRAW_PADDLE: begin
					if (draw_counter < 3'b100) begin
						x = p_x + draw_counter[0];
						y = p_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE1;
					end
				 end
				 DRAW_PADDLE1: begin
					if (snake_length >= 4'd2 && draw_counter < 3'b100) begin
						x = p1_x + draw_counter[0];
						y = p1_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE2;
					end
				 end
				 DRAW_PADDLE2: begin
					if (snake_length >= 4'd2 && draw_counter < 3'b100) begin
						x = p2_x + draw_counter[0];
						y = p2_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE3;
					end
				 end
				 DRAW_PADDLE3: begin
					if (snake_length >= 4'd3 && draw_counter < 3'b100) begin
						x = p3_x + draw_counter[0];
						y = p3_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE4;
					end
				 end
				 DRAW_PADDLE4: begin
					if (snake_length >= 4'd3 && draw_counter < 3'b100) begin
						x = p4_x + draw_counter[0];
						y = p4_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE5;
					end
				 end
				 DRAW_PADDLE5: begin
					if (snake_length >= 4'd4 && draw_counter < 3'b100) begin
						x = p5_x + draw_counter[0];
						y = p5_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE6;
					end
				 end
				 DRAW_PADDLE6: begin
					if (snake_length >= 4'd4 && draw_counter < 3'b100) begin
						x = p6_x + draw_counter[0];
						y = p6_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE7;
					end
				 end
				 DRAW_PADDLE7: begin
					if (snake_length >= 4'd5 && draw_counter < 3'b100) begin
						x = p7_x + draw_counter[0];
						y = p7_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE8;
					end
				 end
				 DRAW_PADDLE8: begin
					if (snake_length >= 4'd5 && draw_counter < 3'b100) begin
						x = p8_x + draw_counter[0];
						y = p8_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE9;
					end
				 end
				 DRAW_PADDLE9: begin
					if (snake_length >= 4'd6 && draw_counter < 3'b100) begin
						x = p9_x + draw_counter[0];
						y = p9_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE10;
					end
				 end
				 DRAW_PADDLE10: begin
					if (snake_length >= 4'd6 && draw_counter < 3'b100) begin
						x = p10_x + draw_counter[0];
						y = p10_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin//
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE11;
					end
				 end
				 DRAW_PADDLE11: begin
					if (snake_length >= 4'd7 && draw_counter < 3'b100) begin
						x = p11_x + draw_counter[0];
						y = p11_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = DRAW_PADDLE12;
					end
				 end
				 DRAW_PADDLE12: begin
					if (snake_length >= 4'd7 && draw_counter < 3'b100) begin
						x = p12_x + draw_counter[0];
						y = p12_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = snake_colour;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_BALL;
					end
				 end
				 ERASE_BALL: begin
					if (draw_counter < 3'b100) begin
						x = b_x + draw_counter[0];
						y = b_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_BALL;
					end
				 end
				UPDATE_BALL: begin
					 if (~b_x_direction) b_x = b_x + 8'd1;
					 else b_x = b_x - 8'd1;
					if (b_y_direction) b_y = b_y + 8'd1;
					 else b_y = b_y - 8'd1;
					 if ((b_x <= 8'd20) || (b_x >= 8'd145)) 
						b_x_direction = ~b_x_direction;
			
				if ((b_y == 8'd2) || ((b_y_direction) && (b_y > p_y - 8'd1) && (b_y < p_y + 8'd2) && (b_x >= p_x) && (b_x <= p_x + 8'd15)))
					b_y_direction = ~b_y_direction;
					
					if (b_y >= 8'd118) 
						b_y_direction = ~b_y_direction;
					state = DRAW_BALL;
				 end
				 DRAW_BALL: begin
					if (draw_counter < 3'b100) begin
						x = b_x + draw_counter[0];
						y = b_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b000;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_BLOCK_1;
					end
				 end
				 ERASE_BLOCK_1: begin
					if (draw_counter < 3'b100) begin
						x = bl_1_x + draw_counter[0];
						y = bl_1_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b000;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_1;
					end
				 end
				 UPDATE_BLOCK_1: begin
					if ((p_y < (bl_1_y+2) && p_y > (bl_1_y -1) && p_x > (bl_1_x-1) && p_x < (bl_1_x+2)) || ((p_y+1) < (bl_1_y+2) && (p_y+1) > (bl_1_y -1) && (p_x+1) > (bl_1_x-1) && (p_x+1) < (bl_1_x+2)) || ((p_y+1) < (bl_1_y+2) && (p_y+1) > (bl_1_y -1) && p_x > (bl_1_x-1) && p_x < (bl_1_x+2)) || (p_y < (bl_1_y+2) && p_y > (bl_1_y -1) && (p_x+1) > (bl_1_x-1) && (p_x+1) < (bl_1_x+2))) begin
						bl_1_x = b_x;
						bl_1_y = b_y;
						
						counter1 = counter1 + 4'd5;
						if (counter1 == 4'd10) begin
							counter1 = 4'd0;
							counter10 = counter10 + 4'd1;
						end
						if (counter10 == 4'd10) begin
							counter10 = 4'd0;
							counter100 = counter100 + 4'd1;
						end
						
						if (snake_length < 4'd7) snake_length = snake_length + 1'b1;
						if (snake_length == 4'd7 && speed < 2'd2) speed = speed + 1'b1;
						
					end
					state = DRAW_BLOCK_1;
				 end
				 DRAW_BLOCK_1: begin
					if (draw_counter < 4'b1000) begin
						x = bl_1_x + draw_counter[0];
						y = bl_1_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_BLOCK_2;
					end
				 end
				 ERASE_BLOCK_2: begin
					if (draw_counter < 3'b100) begin
						x = bl_2_x + draw_counter[1];
						y = bl_2_y + draw_counter[0];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b000;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_2;
					end
				 end
				 UPDATE_BLOCK_2: begin
					if (block2_counter == 8'd0) begin
				 
						if ((p_y < (bl_2_y+2) && p_y > (bl_2_y -1) && p_x > (bl_2_x-1) && p_x < (bl_2_x+2)) || ((p_y+1) < (bl_2_y+2) && (p_y+1) > (bl_2_y -1) && (p_x+1) > (bl_2_x-1) && (p_x+1) < (bl_2_x+2)) || ((p_y+1) < (bl_2_y+2) && (p_y+1) > (bl_2_y -1) && p_x > (bl_2_x-1) && p_x < (bl_2_x+2)) || (p_y < (bl_2_y+2) && p_y > (bl_2_y -1) && (p_x+1) > (bl_2_x-1) && (p_x+1) < (bl_2_x+2))) begin
							snake_colour=block_2_colour;
							counter1 = 4'd0;
							counter10 = 4'd0;
							block2_counter = 8'd255;
							
						end
					 
						if ((block_2_colour != 3'b000) && (b_y > bl_2_y - 8'd1) && (b_y < bl_2_y + 8'd2) && (b_x >= bl_2_x) && (b_x <= bl_2_x + 8'd7)) begin
							b_y_direction = ~b_y_direction;
						end

						if (bl2_y_direction) bl_2_y = bl_2_y + 8'd1;
						 else bl_2_y = bl_2_y - 8'd1;
						
						if (bl_2_y == 8'd2)
						bl2_y_direction = ~bl2_y_direction;
						
						if (bl_2_y >= 8'd118) 
							bl2_y_direction = ~bl2_y_direction;
						end
					else begin
						block2_counter = block2_counter - 1'b1;
					end
					
					state = DRAW_BLOCK_2;
				 end
				 DRAW_BLOCK_2: begin
					if (block2_counter==8'd0) begin
						if (draw_counter < 3'b100) begin
							x = bl_2_x + draw_counter[1];
							y = bl_2_y + draw_counter[0];
							draw_counter = draw_counter + 1'b1;
							colour = block_2_colour;
							end
						else begin
							draw_counter= 8'b00000000;
							state = ERASE_BLOCK_3;
						end
					end
					else begin
					 state = ERASE_BLOCK_3;
					end
				 end
				 ERASE_BLOCK_3: begin
					if (draw_counter < 3'b100) begin
						x = bl_3_x + draw_counter[1];
						y = bl_3_y + draw_counter[0];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b000;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_3;
					end
				 end
				 UPDATE_BLOCK_3: begin
					if (block3_counter == 8'd0) begin
						if ((p_y < (bl_3_y+2) && p_y > (bl_3_y -1) && p_x > (bl_3_x-1) && p_x < (bl_3_x+2)) || ((p_y+1) < (bl_3_y+2) && (p_y+1) > (bl_3_y -1) && (p_x+1) > (bl_3_x-1) && (p_x+1) < (bl_3_x+2)) || ((p_y+1) < (bl_3_y+2) && (p_y+1) > (bl_3_y -1) && p_x > (bl_3_x-1) && p_x < (bl_3_x+2)) || (p_y < (bl_3_y+2) && p_y > (bl_3_y -1) && (p_x+1) > (bl_3_x-1) && (p_x+1) < (bl_3_x+2))) begin
							snake_colour=block_3_colour;
							snake_length=4'd1;
							block3_counter=8'd255;
						end
						if ((block_3_colour != 3'b000) && (b_y > bl_3_y - 8'd1) && (b_y < bl_3_y + 8'd2) && (b_x >= bl_3_x) && (b_x <= bl_3_x + 8'd7)) begin
							b_y_direction = ~b_y_direction;
						end
						
						
						if (bl3_y_direction) bl_3_y = bl_3_y + 8'd1;
						 else bl_3_y = bl_3_y - 8'd1;
						
						if (bl_3_y == 8'd2)
						bl3_y_direction = ~bl3_y_direction;
						
						if (bl_3_y >= 8'd118) 
							bl3_y_direction = ~bl3_y_direction;
					end
					else begin
						block3_counter = block3_counter - 1'b1;
					end
					state = DRAW_BLOCK_3;
				 end
				 DRAW_BLOCK_3: begin
					if (block3_counter == 8'd0) begin
						if (draw_counter < 3'b100) begin
							x = bl_3_x + draw_counter[1];
							y = bl_3_y + draw_counter[0];
							draw_counter = draw_counter + 1'b1;
							colour = block_3_colour;
							end
						else begin
							draw_counter= 8'b00000000;
							state = ERASE_BLOCK_4;
						end
					end
					else begin
						state = ERASE_BLOCK_4;
					end
				 end
				 ERASE_BLOCK_4: begin
					if (draw_counter < 3'b100) begin
						x = bl_4_x + draw_counter[1];
						y = bl_4_y + draw_counter[0];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b000;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_4;
					end
				 end
				 UPDATE_BLOCK_4: begin
					if (block4_counter== 8'd0) begin
						if ((p_y < (bl_4_y+2) && p_y > (bl_4_y -1) && p_x > (bl_4_x-1) && p_x < (bl_4_x+2)) || ((p_y+1) < (bl_4_y+2) && (p_y+1) > (bl_4_y -1) && (p_x+1) > (bl_4_x-1) && (p_x+1) < (bl_4_x+2)) || ((p_y+1) < (bl_4_y+2) && (p_y+1) > (bl_4_y -1) && p_x > (bl_4_x-1) && p_x < (bl_4_x+2)) || (p_y < (bl_4_y+2) && p_y > (bl_4_y -1) && (p_x+1) > (bl_4_x-1) && (p_x+1) < (bl_4_x+2))) begin
							snake_colour=block_4_colour;
							 speed = 2'd2;
							 block4_counter = 8'd255;
						end
						if ((block_4_colour != 3'b000) && (b_y > bl_4_y - 8'd1) && (b_y < bl_4_y + 8'd2) && (b_x >= bl_4_x) && (b_x <= bl_4_x + 8'd7)) begin
							b_y_direction = ~b_y_direction;
						end
						
						if (bl4_y_direction) bl_4_y = bl_4_y + 8'd1;
						 else bl_4_y = bl_4_y - 8'd1;
						
						if (bl_4_y == 8'd2)
						bl4_y_direction = ~bl4_y_direction;
						
						if (bl_4_y >= 8'd118) 
							bl4_y_direction = ~bl4_y_direction;
					end
					else begin
						block4_counter = block4_counter - 1'b1;
					end
					state = DRAW_BLOCK_4;
				 end
				 DRAW_BLOCK_4: begin
					if (block4_counter==8'd0) begin
						if (draw_counter < 3'b100) begin
							x = bl_4_x + draw_counter[1];
							y = bl_4_y + draw_counter[0];
							draw_counter = draw_counter + 1'b1;
							colour = block_4_colour;
							end
						else begin
							draw_counter= 8'b00000000;
							state = ERASE_BLOCK_5;
						end
					end
					else begin
						state = ERASE_BLOCK_5;
					end
				 end
				 ERASE_BLOCK_5: begin
					if (draw_counter < 3'b100) begin
						x = bl_5_x + draw_counter[1];
						y = bl_5_y + draw_counter[0];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b000;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_5;
					end
				 end
				 UPDATE_BLOCK_5: begin
					if (block5_counter == 8'd0) begin
					  if ((p_y < (bl_5_y+2) && p_y > (bl_5_y -1) && p_x > (bl_5_x-1) && p_x < (bl_5_x+2)) || ((p_y+1) < (bl_5_y+2) && (p_y+1) > (bl_5_y -1) && (p_x+1) > (bl_5_x-1) && (p_x+1) < (bl_5_x+2)) || ((p_y+1) < (bl_5_y+2) && (p_y+1) > (bl_5_y -1) && p_x > (bl_5_x-1) && p_x < (bl_5_x+2)) || (p_y < (bl_5_y+2) && p_y > (bl_5_y -1) && (p_x+1) > (bl_5_x-1) && (p_x+1) < (bl_5_x+2))) begin
							snake_colour=block_5_colour;
							speed = 2'd1;
							block5_counter = 8'd255;
						end
						if ((block_5_colour != 3'b000) && (b_y > bl_5_y - 8'd1) && (b_y < bl_5_y + 8'd2) && (b_x >= bl_5_x) && (b_x <= bl_5_x + 8'd7)) begin
							b_y_direction = ~b_y_direction;
						end
						
						if (bl5_y_direction) bl_5_y = bl_5_y + 8'd1;
						 else bl_5_y = bl_5_y - 8'd1;
						
						if (bl_5_y == 8'd2)
						bl5_y_direction = ~bl5_y_direction;
						
						if (bl_5_y >= 8'd118) 
							bl5_y_direction = ~bl5_y_direction;
					end
					else begin
						block5_counter = block5_counter-1'b1;
					end
					
					state = DRAW_BLOCK_5;
				 end
				 DRAW_BLOCK_5: begin
					if (block5_counter == 8'd0) begin
						if (draw_counter < 3'b100) begin
							x = bl_5_x + draw_counter[0];
							y = bl_5_y + draw_counter[1];
							draw_counter = draw_counter + 1'b1;
							colour = block_5_colour;
							end
						else begin
							draw_counter= 8'b00000000;
							state = IDLE;
						end
					end
					else begin
						state = IDLE;
					end
				 end
				 DEAD: begin

					if (draw_counter < 17'b10000000000000000) begin
						x = draw_counter[7:0];
						y = draw_counter[16:8];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b100;
						end
				end


         endcase
    end
endmodule

module clock(input clock, output clk);
reg [19:0] frame_counter;
reg frame;
	always@(posedge clock)
    begin
        if (frame_counter == 20'b00000000000000000000) begin
			  frame_counter = 20'b11001011011100110100;
			  frame = 1'b1;
			  end
        else begin
			frame_counter = frame_counter - 1'b1;
			frame = 1'b0;
		  end
    end
	 assign clk = frame;
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
