module Dice (start, Rb, Reset, seg1, seg2, seg3, seg4, wl, clk);
	
	input start, Rb, Reset, clk;
	output reg [6:0] seg1, seg2, seg3, seg4;
	output reg [1:0] wl;
	reg [2:0] die1, die2 = 1;
	reg [3:0] total, point;
	reg[22:0] clk1, clk2;
	reg start4real, Resetreal, Rbtoggle, toggleroll;
	reg[1:0] roll;
	
always @(posedge start) begin
	start4real = ~start4real;
	if(roll >= 2)begin
		case (total)
			7: roll = 0;
			point: roll = 0;
			default: roll = roll;
		endcase 
	end
	roll = roll + 1;
end

always @(posedge Reset) begin
	Resetreal = ~Resetreal;	
end
 
always @(posedge clk) begin
	if(start4real == 0 && Rbtoggle == 0)begin
		toggleroll = 0;
	end
	if(start4real == 1 && Rbtoggle == 0)begin
		toggleroll = 1;
	end
	if(start4real == 0 && Rbtoggle == 1)begin
		toggleroll = 1;
	end
	if(start4real == 1 && Rbtoggle == 1)begin
		toggleroll = 0;
	end	
	if(toggleroll == 1)begin
		clk1 = clk1 + 1;
		clk2 = clk2 + 1;
		if(clk1 == 6250000)begin
			clk1 = 0;
			if(die1 == 6) begin
				die1 = 1;
			end
			else begin
				die1 = die1 + 1;
			end	
		end
		if(clk2 == 2500000) begin
			clk2 = 0;
			if(die2 == 6) begin
				die2 = 1;
			end
			else begin
				die2 = die2 + 1;
			end
		end
		
		case (die1)
			1:seg1=7'b1111001;
			2:seg1=7'b0100100; 
			3:seg1=7'b0110000;
			4:seg1=7'b0011001;
			5:seg1=7'b0010010;
			6:seg1=7'b0000010;
			7:seg1=7'b1111000;
			8:seg1=7'b0000000;
			9:seg1=7'b0010000;
			default:seg1=7'b1111111;
		endcase		
		case (die2)
			1:seg2=7'b1111001;
			2:seg2=7'b0100100; 
			3:seg2=7'b0110000;
			4:seg2=7'b0011001;
			5:seg2=7'b0010010;
			6:seg2=7'b0000010;
			7:seg2=7'b1111000;
			8:seg2=7'b0000000;
			9:seg2=7'b0010000;
			default:seg2=7'b1111111;
		endcase
		
	end
	if (Resetreal == 1) begin
		die1 = 0;
		die2 = 0;
	end 
end

always @(posedge Rb) begin
	Rbtoggle = ~Rbtoggle; 
	total = die1 + die2;
	if (Resetreal == 1) begin
		total = 0;
		point = 0;
		wl = 2'b00;
	end
	if(roll == 1) begin
		case(total)
			7, 11:wl = 2'b10;
			2, 3, 12:wl = 2'b01;
			default:wl = 2'b00;
		endcase
		point = total;
	end
	if(roll == 2) begin
		total = die1 + die2;
		case (total)
			7: wl = 2'b01;
			point: wl = 2'b10;
			default: wl = 2'b00;
		endcase
	point = total;	
	end	
end

always @(total) begin
	case (total)
		2:seg4=7'b1000000; 
		3:seg4=7'b1000000;
		4:seg4=7'b1000000;
		5:seg4=7'b1000000;
		6:seg4=7'b1000000;
		7:seg4=7'b1000000;
		8:seg4=7'b1000000;
		9:seg4=7'b1000000;
		10:seg4=7'b1111001; 
		11:seg4=7'b1111001;
		12:seg4=7'b1111001;
		default: seg4=7'b1111111;
	endcase	
	case (total)
		2:seg3=7'b0100100; 
		3:seg3=7'b0110000;
		4:seg3=7'b0011001;
		5:seg3=7'b0010010;
		6:seg3=7'b0000010;
		7:seg3=7'b1111000;
		8:seg3=7'b0000000;
		9:seg3=7'b0010000;
		10:seg3=7'b1000000;
		11:seg3=7'b1111001;
		12:seg3=7'b0100100;
		default: seg3=7'b1111111;
	endcase	
end

endmodule


