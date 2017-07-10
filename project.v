// Part 2 skeleton

module project(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
		  LEDR,
		  SW,
		  HEX0,
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
	output [7:0] HEX0;

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
		.hex_digit(counter),
		.segments(HEX0)
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
	 
	 reg [5:0] state;
	 reg border_initing, paddle_initing, ball_initing, block_initing;
	 reg [7:0] x, y;
	 reg [7:0] p_x, p_y, b_x, b_y, bl_1_x, bl_1_y, bl_2_x, bl_2_y, bl_3_x, bl_3_y, bl_4_x, bl_4_y, bl_5_x, bl_5_y, bl_6_x, bl_6_y, bl_7_x, bl_7_y, bl_8_x, bl_8_y, bl_9_x, bl_9_y, bl_10_x, bl_10_y;
	 reg [2:0] colour;
	 reg b_x_direction, b_y_direction;
	 reg [17:0] draw_counter;
	 reg [2:0] block_1_colour, block_2_colour, block_3_colour, block_4_colour, block_5_colour, block_6_colour, block_7_colour, block_8_colour, block_9_colour, block_10_colour;
	 reg [2:0] prev_dir;
	 reg [3:0] counter;
	 wire frame;
	 
	 assign LEDR[5:0] = state;
	 
	 localparam  RESET_BLACK       = 6'b000000,
                INIT_PADDLE       = 6'b000001,
                INIT_BALL         = 6'b000010,
                INIT_BLOCK_1      = 6'b000011,
					 INIT_BLOCK_2      = 6'b000100,
					 INIT_BLOCK_3      = 6'b000101,
					 INIT_BLOCK_4      = 6'b000110,
					 INIT_BLOCK_5      = 6'b000111,
                IDLE              = 6'b001000,
					 ERASE_PADDLE	    = 6'b001001,
                UPDATE_PADDLE     = 6'b001010,
					 DRAW_PADDLE	    = 6'b001011,
                ERASE_BALL        = 6'b001100,
					 UPDATE_BALL       = 6'b001101,
					 DRAW_BALL         = 6'b001110,
					 UPDATE_BLOCK_1    = 6'b001111,
					 DRAW_BLOCK_1      = 6'b010000,
					 UPDATE_BLOCK_2    = 6'b010001,
					 DRAW_BLOCK_2      = 6'b010010,
					 UPDATE_BLOCK_3    = 6'b010011,
					 DRAW_BLOCK_3      = 6'b010100,
					 UPDATE_BLOCK_4    = 6'b010101,
					 DRAW_BLOCK_4      = 6'b010110,
					 UPDATE_BLOCK_5    = 6'b010111,
					 DRAW_BLOCK_5      = 6'b011000,
					 DEAD    		    = 6'b011001;

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
        case (state)
		  RESET_BLACK: begin
			if (draw_counter < 17'b10000000000000000) begin
						x = draw_counter[7:0];
						y = draw_counter[16:8];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_PADDLE;
					end
					counter = 4'd0;
		  end 
    			 INIT_PADDLE: begin
						// 00 up, 01 right, 02 left,03 down
					 prev_dir = 2'b01;
					 if (draw_counter < 6'b10000) begin
					 p_x = 8'd76;
					 p_y = 8'd110;
						x = p_x + draw_counter[0];
						y = p_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = INIT_BALL;
					end
				 end
				 INIT_BALL: begin
					 b_x = 8'd80;
					 b_y = 8'd108;
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
					 bl_2_x = 8'd45;
					 bl_2_y = 8'd30;
					 block_2_colour = 3'b010;
						state = INIT_BLOCK_3;
				 end
				 INIT_BLOCK_3: begin
					 bl_3_x = 8'd75;
					 bl_3_y = 8'd30;
					 block_3_colour = 3'b010;
						state = INIT_BLOCK_4;
				 end
				 INIT_BLOCK_4: begin
					 bl_4_x = 8'd105;
					 bl_4_y = 8'd30;
					 block_4_colour = 3'b010;
						state = INIT_BLOCK_5;
				 end
				 INIT_BLOCK_5: begin
					 bl_5_x = 8'd135;
					 bl_5_y = 8'd30;
					 block_5_colour = 3'b010;
						state = IDLE;
				 end
				 IDLE: begin
				 if (frame)
					state = ERASE_PADDLE;
				 end
				 ERASE_PADDLE: begin
						if (draw_counter < 6'b100000) begin
						x = p_x + draw_counter[0];
						y = p_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_PADDLE;
					end
				 end
				 UPDATE_PADDLE: begin
						if (~KEY[0] && p_x < 8'd159 && prev_dir != 2'b10) begin
							//p_x = p_x + 1'b1;
							prev_dir = 2'b01;
						end

						if (~KEY[3] && p_x > 8'd0 && prev_dir != 2'b01) begin
							//p_x = p_x - 1'b1;
							prev_dir = 2'b10;
						end

						if (~KEY[1] && p_y < 8'd119 && prev_dir != 2'b00) begin
							//p_y = p_y + 1'b1;
							prev_dir = 2'b11;
						end

						if (~KEY[2] && p_y > 8'd0 && prev_dir != 2'b11) begin
							//p_y = p_y - 1'b1;
							prev_dir = 2'b00;
						end

						//if (KEY[0] && KEY[1] && KEY[2] && KEY[3]) begin
							if (prev_dir == 2'b00 && p_y > 8'd0) p_y = p_y - 1'b1;
							if (prev_dir == 2'b01 && p_x < 8'd159) p_x = p_x + 1'b1;
							if (prev_dir == 2'b10 && p_x > 8'd0) p_x = p_x - 1'b1;
							if (prev_dir == 2'b11 && p_y < 8'd119) p_y = p_y + 1'b1;
						//end
						state = DRAW_PADDLE;
						// Enable for boundary
						//if (p_x == 8'd0 || p_y ==8'd0 || p_x == 'd159 || p_y == 8'd119) state = DEAD; 
				 end
				 DRAW_PADDLE: begin
					if (draw_counter < 6'b100000) begin
						x = p_x + draw_counter[0];
						y = p_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b111;
						end
					else begin
						draw_counter= 8'b00000000;
						state = ERASE_BALL;
					end
				 end
				 ERASE_BALL: begin
					if (draw_counter < 4'b1000) begin
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
					 if (~b_x_direction) b_x = b_x + 1'b1;
					 else b_x = b_x - 1'b1;
					if (b_y_direction) b_y = b_y + 1'b1;
					 else b_y = b_y - 1'b1;
					 if ((b_x == 8'd0) || (b_x == 8'd160)) 
					b_x_direction = ~b_x_direction;
			
				if ((b_y == 8'd0) || ((b_y_direction) && (b_y > p_y - 8'd1) && (b_y < p_y + 8'd2) && (b_x >= p_x) && (b_x <= p_x + 8'd15)))
					b_y_direction = ~b_y_direction;
					
					if (b_y >= 8'd120) 
						b_y_direction = ~b_y_direction;
					state = DRAW_BALL;
				 end
				 DRAW_BALL: begin
					if (draw_counter < 4'b1000) begin
						x = b_x + draw_counter[0];
						y = b_y + draw_counter[1];
						draw_counter = draw_counter + 1'b1;
						colour = 3'b110;
						end
					else begin
						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_1;
					end
				 end
				 UPDATE_BLOCK_1: begin
					if (p_y < (bl_1_y+2) && p_y > (bl_1_y -1) && p_x > (bl_1_x-1) && p_x < (bl_1_x+2)) begin
						bl_1_x = b_x;
						bl_1_y = b_y;
						counter = counter + 4'd1;
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
						state = UPDATE_BLOCK_2;
					end
				 end
				 UPDATE_BLOCK_2: begin
					if ((block_2_colour != 3'b000) && (b_y > bl_2_y - 8'd1) && (b_y < bl_2_y + 8'd2) && (b_x >= bl_2_x) && (b_x <= bl_2_x + 8'd7)) begin
						b_y_direction = ~b_y_direction;
						block_2_colour = 3'b000;
					end
					state = DRAW_BLOCK_2;
				 end
				 DRAW_BLOCK_2: begin
//					if (draw_counter < 5'b10000) begin
//						x = bl_2_x + draw_counter[2:0];
//						y = bl_2_y + draw_counter[3];
//						draw_counter = draw_counter + 1'b1;
//						colour = block_2_colour;
//						end
//					else begin
//						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_3;
//					end
				 end
				 UPDATE_BLOCK_3: begin
					if ((block_3_colour != 3'b000) && (b_y > bl_3_y - 8'd1) && (b_y < bl_3_y + 8'd2) && (b_x >= bl_3_x) && (b_x <= bl_3_x + 8'd7)) begin
						b_y_direction = ~b_y_direction;
						block_3_colour = 3'b000;
					end
					state = DRAW_BLOCK_3;
				 end
				 DRAW_BLOCK_3: begin
//					if (draw_counter < 5'b10000) begin
//						x = bl_3_x + draw_counter[2:0];
//						y = bl_3_y + draw_counter[3];
//						draw_counter = draw_counter + 1'b1;
//						colour = block_3_colour;
//						end
//					else begin
//						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_4;
//					end
				 end
				 UPDATE_BLOCK_4: begin
					if ((block_4_colour != 3'b000) && (b_y > bl_4_y - 8'd1) && (b_y < bl_4_y + 8'd2) && (b_x >= bl_4_x) && (b_x <= bl_4_x + 8'd7)) begin
						b_y_direction = ~b_y_direction;
						block_4_colour = 3'b000;
					end
					state = DRAW_BLOCK_4;
				 end
				 DRAW_BLOCK_4: begin
//					if (draw_counter < 5'b10000) begin
//						x = bl_4_x + draw_counter[2:0];
//						y = bl_4_y + draw_counter[3];
//						draw_counter = draw_counter + 1'b1;
//						colour = block_4_colour;
//						end
//					else begin
//						draw_counter= 8'b00000000;
						state = UPDATE_BLOCK_5;
//					end
				 end
				 UPDATE_BLOCK_5: begin
					if ((block_5_colour != 3'b000) && (b_y > bl_5_y - 8'd1) && (b_y < bl_5_y + 8'd2) && (b_x >= bl_5_x) && (b_x <= bl_5_x + 8'd7)) begin
						b_y_direction = ~b_y_direction;
						block_5_colour = 3'b000;
					end
					state = DRAW_BLOCK_5;
				 end
				 DRAW_BLOCK_5: begin
//					if (draw_counter < 5'b10000) begin
//						x = bl_5_x + draw_counter[2:0];
//						y = bl_5_y + draw_counter[3];
//						draw_counter = draw_counter + 1'b1;
//						colour = block_5_colour;
//						end
//					else begin
//						draw_counter= 8'b00000000;
						state = IDLE;
//					end
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
