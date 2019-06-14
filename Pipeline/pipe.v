`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2017 08:29:12 PM
// Design Name: 
// Module Name: pipe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module test_pipe_cpu();
    reg clk;
    reg[15:0] pci,spi;
    
    initial
        begin
            clk = 1'b0;
            // ALU instruction (a+b-c) or (a+b|c)
            pci = 16'd90;
            
            // Branch instruction if(cc==1)Mem[2] = c|(a+b); else Mem[1] = (a+b)
            //pci = 16'd55;
            
            // Call instruction (a+b-c)
            //pci = 16'd91;
            
            spi = 16'd10;
        end
        
    always
        begin
            #100 clk = !clk;
        end
        
    top TOP(clk,pci,spi);
endmodule

module top(
    input clk,
    input[15:0] pci,spi
    );
    
    wire[11:0] state;
    wire ldpcsel,ldpc,spsel,ldsp,addsp,memwrite,memread,regwrite,regread,regwsel,meminsel,fclk;
    wire cf,sta,stc;
    wire[1:0] stb;
    
    Controller CONTROL(clk,state,ldpcsel,ldpc,spsel,ldsp,addsp,memwrite,memread,regwrite,regread,regwsel,meminsel,fclk);
    delay D(clk,cf,sta,stc,stb,state);
    datapath DATAPATH(clk,ldpcsel,ldpc,spsel,ldsp,addsp,memwrite,memread,regwrite,regread,regwsel,meminsel,fclk,pci,spi,cf,sta,stc,stb);
endmodule

module Controller(
    input clk,
    input[11:0] state,
    output ldpcsel,ldpc,spsel,ldsp,addsp,memwrite,memread,regwrite,regread,regwsel,meminsel,fclk
    );
    
    assign ldpcsel = state[4];
    assign ldpc = state[0] | state[2] | state[4] | state[6] | state[8] | state[10];
    assign spsel = state[0] | state[8];
    assign ldsp = state[0] | state[2] | state[4] | state[6] | state[8];
    assign addsp = state[2] | state[4] | state[6];
    assign memwrite = state[0] | state[8];
    assign memread = state[2] | state[4] | state[6];
    assign regwrite = state[2] | state[6];
    assign regread = state[0] | state[6];
    assign regwsel = state[2] | state[4];
    assign meminsel = state[0]; 
    assign fclk = state[6];
            
  
endmodule

module delay(
    input clk,
    input cf,sta,stc,
    input[1:0] stb,
    output reg[11:0] state
    );
    
    wire st1,st2,st3,st4,st5,st6;
    wire tar;
    reg used;
    wire insc2,insc3;
    
    assign tar = state[1] | state[3] | state[5] | state[7] | state[9] | state[11]; 
    
    initial
        begin
            state = 12'b000000100000;
            used = 1'b0;
            //tar = 1'b1;
        end
    
    always @(posedge clk or negedge clk)
        begin
            if(used==1'b0)
                begin
                    used <= 1'b1;
                end
            else
                begin
                    state[0] <= st1;
                    state[1] <= state[0];
                    state[2] <= st2;
                    state[3] <= state[2];
                    state[4] <= st3;
                    state[5] <= state[4];
                    state[6] <= st4;
                    state[7] <= state[6];
                    state[8] <= st6;
                    state[9] <= state[8];
                    state[10] <= st5;
                    state[11] <= state[10]; 
                end
        end
        
        demux1to2 sc1(tar,sta,insc2,insc3);
        demux1to4 sc2(insc2,stb,st4,st3,st2,st1);
        demux1to2 sc3(insc3,stc,st6,st5);
endmodule

module demux1to2(
    input in,sel,
    output out1,out2
    );
    
    assign out1 = in&sel;
    assign out2 = in&(~sel);
    
endmodule

module demux1to4(
    input in,
    input[1:0] sel,
    output out1,out2,out3,out4
    );

    assign out1 = in&(sel[1])&(sel[0]);
    assign out2 = in&(sel[1])&(~sel[0]);
    assign out3 = in&(~sel[1])&(sel[0]);
    assign out4 = in&(~sel[1])&(~sel[0]);    

endmodule

module datapath(
    input clk,ldpcsel,ldpc,spsel,ldsp,addsp,memwrite,memread,regwrite,regread,regwsel,meminsel,fclk,
    input[15:0] pci,spi,
    output cf,sta,stc, 
    output[1:0] stb
    );
    
    wire[15:0] imemin,m3in0,m3in1,m3out,m2in0,m2in1,m2out,m1in0,m1out,m4in0,m4in1,m4out,m5in0,m5in1,m5out,m6in0,m6in1,m6out,instr;
    wire[15:0] inc1out,idregrdata;
    
    wire idspsel,idldsp,idaddsp,idmemwrite,idmemread,idregwrite,idregread,idregwsel,idmeminsel,idfclk;
    wire[15:0] idinstr,idinc1out;
    
    wire mspsel,mldsp,maddsp,mmemwrite,mmemread,mregwrite,mregwsel,mmeminsel,mfclk;
    wire[15:0] mir,mpc4,mregrdata,mmemrdata;
    
    wire exregwrite,exregwsel,exfclk;
    wire[15:0] exir,exregrdata,exmemrdata,exaluout;
    
    wire wbregwrite,wbregwsel;
    wire[15:0] wbir;
    
    reg ifstall,wbstall,idstall,mstall,exstall;
    
    initial
        begin
            ifstall = 1'b0;
            idstall = 1'b0;
            mstall = 1'b0;
            exstall = 1'b0;
            wbstall = 1'b0;
        end
        
    always @(posedge clk)
        begin
            if((idinstr[15:12]===4'b0000 && mir[15:12]===4'b0000 && mir[10]===1'b1 && (idinstr[11:10]===2'b11 || idinstr[11:10]===2'b00) && idinstr[7:5] === mir[7:5]) | (idinstr[15:12]===4'b0000 && mir[15:12]===4'b0000 && exir[10]===1'b1 && (idinstr[11:10]===2'b11 || idinstr[11:10]===2'b00) && idinstr[7:5] === exir[7:5]) | (idinstr[15:12]===4'b0000 && wbir[15:12]===4'b0000 && wbir[10]===1'b1 && (idinstr[11:10]===2'b11 || idinstr[11:10]===2'b00) && idinstr[7:5] === wbir[7:5]))
                begin
                    idstall = 1'b1;
                    ifstall = 1'b1;
                end
            else 
                begin
                    idstall = 1'b0;
                    ifstall = 1'b0;
                end
        end
    
    wire c,z,v,s,m2sel;
    
    stat STATUS(instr,sta,stc,stb);
    
    assign m5in0 = 16'b1111111111111111;
    assign m5in1 = 16'b0000000000000001;
    
    sprpc PC(clk,ldpc,ifstall,m1out,imemin,pci);
    imemory IMEM(clk,imemin,instr);
    inc1 INC1(imemin,inc1out);
    incl INCL1(inc1out,m2out,m1in0);
    mux2to1 MUX1(m1in0,m6out,ldpcsel,m1out);
    
    //----------
    ifid station1(clk,ifstall,spsel,ldsp,addsp,memwrite,memread,regwrite,regread,regwsel,meminsel,fclk,instr,inc1out,idspsel,idldsp,idaddsp,idmemwrite,idmemread,idregwrite,idregread,idregwsel,idmeminsel,idfclk,idinstr,idinc1out);
    //----------
    
    regbank RB(clk,idregread,wbregwrite,idinstr,wbir,m6out,idregrdata);
    
    //----------
    idm station2(clk,idstall,idspsel,idldsp,idaddsp,idmemwrite,idmemread,idregwrite,idregwsel,idmeminsel,idfclk,idinstr,idinc1out,idregrdata,mspsel,mldsp,maddsp,mmemwrite,mmemread,mregwrite,mregwsel,mmeminsel,mfclk,mir,m3in0,m3in1);
    //----------
    
    dmemory DMEM(clk,mmemread,mmemwrite,mstall,m4out,m3out,mmemrdata);
    sprsp SP(clk,mldsp,mstall,m4in1,m4in0,spi);
    incl INCL2(m4in0,m5out,m4in1);
    mux2to1 MUX3(m3in0,m3in1,mmeminsel,m3out);
    mux2to1 MUX4(m4in0,m4in1,mspsel,m4out);
    mux2to1 MUX5(m5in0,m5in1,maddsp,m5out);
    
    //----------
    mex station3(clk,mstall,mregwrite,mregwsel,mfclk,mir,m3in1,mmemrdata,exregwrite,exregwsel,exfclk,exir,exregrdata,exmemrdata);
    //----------
    
    alu ALU(clk,exregrdata,exmemrdata,exir,c,z,v,s,exaluout);
    condflag CF(clk,c,z,v,s,exir,((~exstall) & exfclk),cf);
    assign m2sel = ((cf&(~(sta|stc))) | stc);
    assign m2in0 = 16'd0;
    assign m2in1[15] = exir[11];
    assign m2in1[14] = exir[11];
    assign m2in1[13] = exir[11];
    assign m2in1[12] = exir[11];
    assign m2in1[11:0] = exir[11:0];
    mux2to1 MUX2(m2in0,m2in1,m2sel,m2out);
    
    //----------
    exwb station4(clk,exstall,exregwrite,exregwsel,exir,exaluout,exmemrdata,wbregwrite,wbregwsel,wbir,m6in0,m6in1);
    //----------
    
    mux2to1 MUX6(m6in0,m6in1,wbregwsel,m6out);
endmodule

module ifid(
    input clk,stall,ispsel,ildsp,iaddsp,imemwrite,imemread,iregwrite,iregread,iregwsel,imeminsel,ifclk,
    input[15:0] instr,ipc4,
    output reg spsel,ldsp,addsp,memwrite,memread,regwrite,regread,regwsel,meminsel,fclk,
    output reg[15:0] ir,pc4
    );
    
    always @(negedge clk)
        begin
            if(stall==1'b0)
                begin
                    spsel <= ispsel;
                    ldsp <= ildsp;
                    addsp <= iaddsp;
                    memwrite <= imemwrite;
                    memread <= imemread;
                    regwrite <= iregwrite;
                    regread <= iregread;
                    regwsel <= iregwsel;
                    meminsel <= imeminsel;
                    fclk <= ifclk;
                    ir <= instr;
                    pc4 <= ipc4;
                end
        end
endmodule

module idm(
    input clk,stall,ispsel,ildsp,iaddsp,imemwrite,imemread,iregwrite,iregwsel,imeminsel,ifclk,
    input[15:0] instr,ipc4,iregrdata,
    output reg spsel,ldsp,addsp,memwrite,memread,regwrite,regwsel,meminsel,fclk,
    output reg[15:0] ir,pc4,regrdata
    );
    
    always @(negedge clk)
        begin
            if(stall==1'b0)
                begin
                    spsel <= ispsel;
                    ldsp <= ildsp;
                    addsp <= iaddsp;
                    memwrite <= imemwrite;
                    memread <= imemread;
                    regwrite <= iregwrite;
                    regwsel <= iregwsel;
                    meminsel <= imeminsel;
                    fclk <= ifclk;
                    ir <= instr;
                    pc4 <= ipc4; 
                    regrdata <= iregrdata;
                end
            else
                begin
                    spsel <= 1'bx;
                    ldsp <= 1'bx;
                    addsp <= 1'bx;
                    memwrite <= 1'bx;
                    memread <= 1'bx;
                    regwrite <= 1'bx;
                    regwsel <= 1'bx;
                    meminsel <= 1'bx;
                    fclk <= 1'bx;
                    ir <= 'bx;
                    pc4 <= 'bx; 
                    regrdata <= 'bx;
                end
        end
    
endmodule

module mex(
    input clk,stall,iregwrite,iregwsel,ifclk,
    input[15:0] instr,iregrdata,imemrdata,
    output reg regwrite,regwsel,fclk,
    output reg[15:0] ir,regrdata,memrdata
    );
    
    always @(negedge clk)
        begin
            if(stall==1'b0)
                begin
                    regwrite <= iregwrite; 
                    regwsel <= iregwsel;
                    fclk <= ifclk;
                    ir <= instr;
                    regrdata <= iregrdata;  
                    memrdata <= imemrdata; 
                end
        end
    
endmodule

module exwb(
    input clk,stall,iregwrite,iregwsel,
    input[15:0] instr,ialuout,imemrdata,
    output reg regwrite,regwsel,
    output reg[15:0] ir,aluout,memrdata
    );
    
    always @(negedge clk)
        begin
            if(stall==1'b0)
                begin
                    regwrite <= iregwrite; 
                    regwsel <= iregwsel;
                    ir <= instr;
                    aluout <= ialuout;
                    memrdata <= imemrdata; 
                end
        end
    
endmodule

module imemory(
		input clk,
		input[15:0] abus,
		output[15:0] dbus
	);
	
	reg[15:0] Mem[0:127];
	reg useless;
	
	initial
	   begin
            // ALU instruction (a+b-c)
            Mem[90] = 16'h0400;
            Mem[91] = 16'h0C00;
            Mem[92] = 16'h0D20;
            Mem[93] = 16'h0020;
            Mem[94] = 16'h0C00;
            Mem[95] = 16'h0000;
	       
           // ALU instruction (a+b|c)
//           Mem[90] = 16'h0400;
//           Mem[91] = 16'h0420;
//           Mem[92] = 16'h0E20;
//           Mem[93] = 16'h0020;
//           Mem[94] = 16'h0C00;
//           Mem[95] = 16'h0000;
	           
           // Branch on zero instruction if(cc==1)Mem[12] = c|(a+b); else Mem[11] = (a+b)
//           Mem[55] = 16'b0000010000000000;
//           Mem[56] = 16'b0000110000000000;
//           Mem[57] = 16'b0100000000100000;
//           Mem[58] = 16'b0001000000101110;
//           Mem[90] = 16'b0000010000100000;
//           Mem[91] = 16'b0000000000000000;
//           Mem[92] = 16'b0000111000100000;
//           Mem[93] = 16'b0000000000100000;
//           Mem[94] = 16'b0001000000001011;
//           Mem[105] = 16'b0000000000000000;
           
          // Branch on overflow instruction if(cc==1)Mem[12] = c|(a+b); else Mem[11] = (a+b)
//          Mem[55] = 16'b0000010000000000;
//          Mem[56] = 16'b0000110000000000;
//          Mem[57] = 16'b0110000000100000;
//          Mem[58] = 16'b0001000000101110;
//          Mem[90] = 16'b0000010000100000;
//          Mem[91] = 16'b0000000000000000;
//          Mem[92] = 16'b0000111000100000;
//          Mem[93] = 16'b0000000000100000;
//          Mem[94] = 16'b0001000000001011;
//          Mem[105] = 16'b0000000000000000;
          
            // Branch on carry instruction if(cc==1)Mem[12] = c|(a+b); else Mem[11] = (a+b)
//            Mem[55] = 16'b0000010000000000;
//            Mem[56] = 16'b0000110000000000;
//            Mem[57] = 16'b0010000000100000;
//            Mem[58] = 16'b0001000000101110;
//            Mem[90] = 16'b0000010000100000;
//            Mem[91] = 16'b0000000000000000;
//            Mem[92] = 16'b0000111000100000;
//            Mem[93] = 16'b0000000000100000;
//            Mem[94] = 16'b0001000000001011;
//            Mem[105] = 16'b0000000000000000;
            
                // Branch on sign instruction if(cc==1)Mem[12] = c|(a+b); else Mem[11] = (a+b)
//              Mem[55] = 16'b0000010000000000;
//              Mem[56] = 16'b0000110000000000;
//              Mem[57] = 16'b1000000000100000;
//              Mem[58] = 16'b0001000000101110;
//              Mem[90] = 16'b0000010000100000;
//              Mem[91] = 16'b0000000000000000;
//              Mem[92] = 16'b0000111000100000;
//              Mem[93] = 16'b0000000000100000;
//              Mem[94] = 16'b0001000000001011;
//              Mem[105] = 16'b0000000000000000;

            // Call instruction (a+b-c)
//            Mem[55] = 16'h00E0;
//            Mem[56] = 16'h0060;
//            Mem[57] = 16'h0000;
            
//            Mem[58] = 16'h0400;
//            Mem[59] = 16'h0C00;
//            Mem[60] = 16'h0D20;
//            Mem[61] = 16'h0020;
//            Mem[62] = 16'h0C00;
//            Mem[63] = 16'h0800;
            
//            Mem[91] = 16'h0400;
//            Mem[92] = 16'h0460;
//            Mem[93] = 16'h04E0;
//            Mem[94] = 16'hAFD8;
//            Mem[95] = 16'h0000;
           
	   end
	
	assign dbus = Mem[abus];
endmodule

module dmemory(
		input clk,rd,w,stall,
		input[15:0] abus,
		input[15:0] wbus,
		output[15:0] rdbus
	);
	
	reg[15:0] Mem[0:127];
	reg useless;
	
	initial
	   begin
            // ALU instruction (a+b-c)
            Mem[10] = 16'd6;
            Mem[11] = 16'd5;
            Mem[12] = 16'd3;
	       
           // ALU instruction (a+b|c)
//           Mem[10] = 16'd6;
//           Mem[11] = 16'd5;
//           Mem[12] = 16'd3;
	           
           // Branch on zero instruction if(cc==1)Mem[2] = c|(a+b); else Mem[1] = (a+b)
//           Mem[10] = 16'h0003;
//           Mem[11] = 16'b1111111111111100;
//           Mem[12] = 16'b0001100000001011;
           
          // Branch on overflow instruction if(cc==1)Mem[2] = c|(a+b); else Mem[1] = (a+b)
//          Mem[10] = 16'h8003;
//          Mem[11] = 16'b1111110001111101;
//          Mem[12] = 16'b0000000000101011;
          
            // Branch on carry instruction if(cc==1)Mem[2] = c|(a+b); else Mem[1] = (a+b)
//            Mem[10] = 16'h8003;
//            Mem[11] = 16'b1111110001111101;
//            Mem[12] = 16'b0000000000101011;
            
        // Branch on sign instruction if(cc==1)Mem[2] = c|(a+b); else Mem[1] = (a+b)
//          Mem[10] = 16'h0003;
//          Mem[11] = 16'b1111111111111100;
//          Mem[12] = 16'b0000000000101011;

            // Call instruction (a+b-c)
//            Mem[10] = 16'd6;
//            Mem[11] = 16'd5;
//            Mem[12] = 16'd3;
           
	   end
	
	assign rdbus = (rd) ? Mem[abus] : 'bz;
	
	always @(negedge clk)
	   begin
	       if(w==1'b1 && stall!=1'b1)Mem[abus] <= wbus;
	       else useless <= 1'b0;
	   end

endmodule


module sprpc(
    input clk,
    input ld,
    input stall, 
    input[15:0] inbus,
    output[15:0] outbus,
    input[15:0] init
    );
    
    reg[15:0] register;
    //reg[15:0] sample;
    reg useless;
    
    initial
        begin
            #1 register <= init;
        end
    
    always @(negedge clk)
        begin
            if(ld==1'b1 && stall!=1'b1)register <= inbus;
            else useless <= 1'b0;
        end
    
    assign outbus = register;
endmodule

module sprsp(
    input clk,
    input ld,stall,
    input[15:0] inbus,
    output[15:0] outbus,
    input[15:0] init
    );
    
    reg[15:0] register;
    reg useless;
    
    initial
        begin
            #1 register = init;
        end
    
    always @(negedge clk)
        begin
            if(ld==1'b1 && stall!=1'b1)register <= inbus;
            else useless <= 1'b0;
        end
    
    assign outbus = register;
endmodule

module regbank(
    input clk,
    input t,ld,
    input[15:0] rinstr,
    input[15:0] winstr,
    input[15:0] inbus,
    output[15:0] outbus
    );
    
    wire t0,t1,t2,t3,t4,t5,t6,t7,ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7;
    
    assign t0 = t & (~rinstr[7]) & (~rinstr[6]) & (~rinstr[5]);
    assign t1 = t & (~rinstr[7]) & (~rinstr[6]) & rinstr[5];
    assign t2 = t & (~rinstr[7]) & rinstr[6] & (~rinstr[5]);
    assign t3 = t & (~rinstr[7]) & rinstr[6] & rinstr[5];
    assign t4 = t & rinstr[7] & (~rinstr[6]) & (~rinstr[5]);
    assign t5 = t & rinstr[7] & (~rinstr[6]) & rinstr[5];
    assign t6 = t & rinstr[7] & rinstr[6] & (~rinstr[5]);
    assign t7 = t & rinstr[7] & rinstr[6] & rinstr[5];    
    
    assign ld0 = ld & (~winstr[7]) & (~winstr[6]) & (~winstr[5]);
    assign ld1 = ld & (~winstr[7]) & (~winstr[6]) & winstr[5];
    assign ld2 = ld & (~winstr[7]) & winstr[6] & (~winstr[5]);
    assign ld3 = ld & (~winstr[7]) & winstr[6] & winstr[5];
    assign ld4 = ld & winstr[7] & (~winstr[6]) & (~winstr[5]);
    assign ld5 = ld & winstr[7] & (~winstr[6]) & winstr[5];
    assign ld6 = ld & winstr[7] & winstr[6] & (~winstr[5]);
    assign ld7 = ld & winstr[7] & winstr[6] & winstr[5];
    
    gpr r0(clk,t0,ld0,inbus,outbus);
    gpr r1(clk,t1,ld1,inbus,outbus);
    gpr r2(clk,t2,ld2,inbus,outbus);
    gpr r3(clk,t3,ld3,inbus,outbus);
    gpr r4(clk,t4,ld4,inbus,outbus);
    gpr r5(clk,t5,ld5,inbus,outbus);
    gpr r6(clk,t6,ld6,inbus,outbus);
    gpr r7(clk,t7,ld7,inbus,outbus);
endmodule

module gpr(
    input clk,
    input t,ld,
    input[15:0] inbus,
    output[15:0] outbus
    );
    
    reg[15:0] register;
    reg useless;
    
    always @(negedge clk)
        begin
            if(ld==1'b1)register <= inbus;
            else useless <= 1'b0;
        end
    
    assign outbus = t ? register : 'bz;
    
endmodule

module inc1(
    input[15:0] x,
    output[15:0] z
    );
    
    assign z = x + 16'd1;    
endmodule

module incl(
    input[15:0] x,y,
    output[15:0] z
    );

    assign z = x+y;
endmodule

module mux2to1(
    input[15:0] in0,in1,
    input sel,
    output[15:0] out 
    );
    
    assign out = sel ? in1 : in0;

endmodule

module alu(
    input clk,
    input[15:0] in1,in2,
    input[15:0] instr,
    output reg c,z,v,s,
    output[15:0] out
    );

    reg[15:0] z1;
    reg z2;
    reg[16:0] zadd1,zadd2,zadd;
    
    always @(*)
        begin
            case(instr[9:8])
                2'b00 : 
                    begin
                        z1 = in1 + in2;
                        zadd1[15:0] = in1;
                        zadd1[16] = 1'b0;
                        zadd2[15:0] = in2;
                        zadd2[16] = 1'b0;
                        zadd = zadd1 + zadd2;
                        c = zadd[16];
                        v = ((~in1[15]) & (~in2[15]) & zadd[15]) | (in1[15] & in2[15] & (~zadd[15])); 
                    end
                2'b01 : 
                    begin
                        z1 = -in2;
                        c = 1'b0;
                        v = 1'b0;
                    end
                2'b10 : 
                    begin
                        z1 = in1 | in2;
                        c = 1'b0;
                        v = 1'b0;
                    end
                2'b11 : 
                    begin
                        z1 = !in2;
                        c = 1'b0;
                        v = 1'b0;
                    end
            endcase
            
            s = z1[15];
            z = (z1==16'b0000000000000000) ? 1'b1 : 1'b0;
        end
    
    assign out = z1;
endmodule

module condflag(
    input clk,c,z,v,s,
    input[15:0] instr,
    input fclk,
    output reg cf
    );
    
    reg regc,regnc,regnz,regz,regv,regnv,regs,regns,useless;
    
    always @(negedge clk)
        begin
            if(fclk==1'b1)
                begin 
                    regc <= c;
                    regz <= z;
                    regs <= s;
                    regv <= v;
                    regnc <= !c;
                    regnz <= !z;
                    regns <= !s;
                    regnv <= !v;
                end
            else useless = 1'b0;
        end 
        
    always @(*)
        begin
            case(instr[15:12])
                4'b0001 : cf = 1'b1;
                4'b0010 : cf = regc;
                4'b0011 : cf = regnc;
                4'b0100 : cf = regz;
                4'b0101 : cf = regnz;
                4'b0110 : cf = regv;
                4'b0111 : cf = regnv;
                4'b1000 : cf = regs;
                4'b1001 : cf = regns;
                
            endcase
        end
    
endmodule

module stat(
    input[15:0] instr,
    output sta,stc,
    output[1:0] stb
    );
    
    assign sta = ~(instr[15] | instr[14] | instr[13] | instr[12]);
    assign stb = instr[11:10];
    assign stc = instr[15] & (~instr[14]) & instr[13] & (~instr[12]);

endmodule