`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2017 10:22:34 PM
// Design Name: 
// Module Name: Booth
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

module test_Booth();
    reg[7:0] mpcand;
    reg[7:0] mplier1;
    reg go;
    reg clk;
    reg rst;
    wire[15:0] mplier;
    
    initial
        begin
            mpcand = 8'b11011010;
            mplier1 = 8'b10110111;
            go = 1'b0;
            rst = 1'b1;
            clk = 0;
            #20 go = 1'b1;
        end
        
    always
        begin
            #20 clk = !clk;
            #20 rst = 1'b0;
        end
        
    FSM_controller fsm(mpcand,mplier1,go,rst,clk,mplier);
endmodule

//module test_mod();
//    reg[3:0] nst;
//    reg clk,rst;
//    wire[3:0] st;
    
//    initial
//        begin
//            nst = 4'b1011;
//            clk = 1'b0;
//            rst = 1'b1;
//        end
        
//    always
//        begin
//            #100 clk = ~clk;
//            rst = 1'b0;
//        end
        
//    delay flip(nst,clk,rst,st);
//endmodule

module FSM_controller(
    input[7:0] mpcand,
    input[7:0] mplier1,
    input go,rst,clk,
    output[15:0] mplier2
    );
    wire[15:0] mplier;
    
    wire[3:0] st;
    wire[3:0] nst;
    wire[3:0] fnsel;
    wire[2:0] varxselect;
    wire[2:0] varyselect;
    
    wire ldmpcand;
    wire ldmplier;
    wire ldlast;
    wire ldcount;
    wire ldacc;
    wire ldmm;
    wire last;
    
    wire status;
    
    assign mplier2 = mplier;
    delay flip(nst,clk,rst,st);
    datapath data(mpcand,mplier1,fnsel,varxselect,varyselect,ldmpcand,ldmplier,ldlast,ldcount,ldacc,ldmm,rst,status,mplier,last);
    
    assign nst[3] = (~(st[3]) & st[2] & st[1]) | (~(st[3]) & st[2] & st[0] & ((~(mplier[1]) & ~(mplier[0]) & ~(last)) | (mplier[1] & mplier[0] & last))) | (st[3] & ~(st[2]) & ~(st[1])) | (st[3] & ~(st[2]) & ~(st[0]) & ~(status)) | (st[3] & ~(st[2]) & st[0] & go);
    assign nst[2] = (~(st[3]) & ~(st[2]) & st[1] & st[0]) | (~(st[3]) & st[2] & ~(st[1]) & ~(st[0])) | (st[3] & ~(st[2]) & st[1] & ~(st[0]) & status) | (~(st[3]) & st[2] & ~(st[1]) & ((mplier[1]^mplier[0]) | (mplier[1]^last)));
    assign nst[1] = (~(st[3]) & ~(st[2]) & ~(st[1]) & st[0] & go) | (~(st[3]) & ~(st[2]) & st[1] & ~(st[0])) | (~(st[3]) & st[2] & ~(st[1]) & st[0] & ((mplier[1]^mplier[0]) | (mplier[1]^last))) | (st[3] & ~(st[2]) & ~(st[1]) & st[0]) | (st[3] & ~(st[2]) & st[1] & ~(st[0]) & ~(status)) | (st[3] & ~(st[2]) & st[0] & go);
    assign nst[0] = (~(st[3]) & ~(st[1]) & ~(st[0])) | (~(st[3]) & st[2] & ~(st[1]) & mplier[1] & ~(mplier[0] & last)) | (~(st[2]) & ~(st[0])) | (st[3] & ~(st[2]) & st[1] & go);
    
    assign ldmpcand = (~(st[3]) & ~(st[2]) & ~(st[1]) & ~(st[0]));
    assign ldmplier = (~(st[3]) & ~(st[2]) & ~(st[1]) & st[0]);
    assign ldlast = (~(st[2]) & ~(st[0]) & (st[3] ^ st[1]));
    assign ldcount = (~(st[2]) & st[1] & (st[3] ^ st[0]));
    assign ldacc = ((~(st[3]) & st[2] & st[1]) | (st[3] & ~(st[2]) & ~(st[1]) & st[0]));
    assign ldmm = (~(st[3]) & st[2] & ~(st[1]) & st[0]);
    
    assign varxselect = 3'b011;
    assign varyselect = 3'b101;
    
    assign fnsel[3] = st[3] & st[1];
    assign fnsel[2] = (~(st[3]) & st[1] & ~(st[2] ^ st[0])) | (st[3] & ~(st[2]) & ~(st[1]));
    assign fnsel[1] = (~(st[3]) & st[2] & ~(st[1]) & st[0] & ((~(mplier[1]) & mplier[0] & last) | (mplier[1] & ~(mplier[0]) & ~(last)))) | (~(st[3]) & st[2] & st[1] & ~(st[0])) | (st[3] & ~(st[2]) & ~(st[1]));
    assign fnsel[0] = (~(st[3]) & st[1] & ~(st[0])) | (st[3] & ~(st[2]) & ~(st[1]) & st[0]) | (~(st[3]) & st[2] & ~(st[1]) & st[0] & (mplier[0] ^ last));
endmodule

module delay(
    input[3:0] nst,
    input clk,rst,
    output reg[3:0] st
    );
    
    always @(posedge clk)
        begin
            if(rst)st = 4'b0000;
            else st = nst;
        end

endmodule

module datapath(
    input[7:0] mpcand,
    input[7:0] mplier1,
    input[3:0] fnsel,
    input[2:0] varxselect,
    input[2:0] varyselect,
    input ldmpcand,
    input ldmplier,
    input ldlast,ldcount,ldacc,ldmm,rst,
    output status,
    output[15:0] aluinam,
    output aluinlast
    );
    
    wire[7:0] alux;
    wire[7:0] aluy;
    wire[7:0] aluz8;
    wire aluz1;
    wire[15:0] aluz16;
    
    wire[7:0] aluinmpcand;
    //wire aluinlast;
    wire[7:0] aluincount;
    wire[7:0] aluinmm;
    //wire[15:0] aluinam;
    
    wire[7:0] regincount;
    wire[7:0] reginmm;
    wire[15:0] reginam;
    wire reginlast;
    
    //wire[7:0] regtmplier;
    wire[7:0] regtcount;
    //wire[7:0] regtacc;
    wire[7:0] regtmm;
    wire regtlast;
    wire[15:0] regtam;
    
    regt8 A(mpcand,ldmpcand,rst,aluinmpcand);     
                                    
    reg8 B(regincount,ldcount,rst,aluincount);                                     
    reg8 C(reginmm,ldmm,rst,aluinmm);                                     
    reg1 D(reginlast,ldlast,rst,aluinlast);                                    
    reg16 E(reginam,ldacc,rst,ldmplier,aluinam);                                     
    
    regt8 F(regtcount,ldcount,rst,regincount);                                     
    regt8 G(regtmm,ldmm,rst,reginmm);                                     
    regt1 H(regtlast,ldlast,rst,reginlast);                                     
    regt16 I(mplier1,regtam,ldacc,rst,ldmplier,reginam);     
    
    mux X(aluincount,aluinmm,varxselect,alux);
    mux Y(aluincount,aluinmm,varyselect,aluy);
    
    functional func(fnsel,alux,aluy,aluinmpcand,aluinlast,aluinam,aluz1,aluz8,aluz16);
    
    statdet J(regincount,status);
    
    assign regtcount = aluz8;
    assign regtmm = aluz8;
    assign regtlast = aluz1;
    assign regtam = aluz16;
    
endmodule

module reg8(
    input[7:0] in,
    input signal,rst,
    output reg [7:0] out
    );

    reg pass;
    always @(*)
        begin
            if(~signal)out = in;
            else  pass=1'b0;
            if(rst)out = 8'b00000000;
            else pass = 1'b0;
        end
endmodule

module regt8(
    input[7:0] in,
    input signal,rst,
    output reg [7:0] out
    );

    reg pass;
    always @(*)
        begin
            if(signal)out = in;
            else pass=1'b0;
            if(rst)out = 8'b00000000;
            else pass = 1'b0;
        end
endmodule

module reg16(
   input[15:0] in,
   input signal1,rst,
   input signal2,
   output reg [15:0] out
   );

   reg pass;
   always @(*)
       begin
           if(~(signal1) & ~(signal2))out = in;
           else  pass = 1'b0;
           if(rst)out = 16'b0000000000000000;
           else pass = 1'b0;
       end
endmodule
   
module regt16(
    input[7:0] hin,
    input[15:0] in,
    input signal1,rst,
    input signal2,
    output reg[15:0] out
    );

    reg pass;
    always @(*)
        begin
            if(~(signal1) & signal2)
                begin
                    out[7:0] = hin;
                    out[15:8] = 8'b00000000;
                end
            else 
                begin
                    if(signal1 & ~(signal2))out = in;
                    else pass = 1'b0;
                end
            if(rst)out = 16'b0000000000000000;
            else pass = 1'b0;
        end
endmodule
   
module reg1(
    input in,
    input signal,rst,
    output reg out
    );

    reg pass;
    always @(*)
        begin
            if(~signal)out = in;
            else  pass=1'b0;
            if(rst)out = 1'b0;
            else pass = 1'b0;
        end
endmodule
  
module regt1(
    input in,
    input signal,rst,
    output reg out
    );
    
    reg pass;
    always @(*)
        begin
          if(signal)out = in;
          else pass=1'b0;
          if(rst)out = 1'b0;
          else pass = 1'b0;
        end
endmodule

module functional(
    input[3:0] fnsel,
    input [7:0] x,
    input [7:0] y,
    input [7:0] mpcand,
    input last,
    input[15:0] am,
    output reg z1,
    output reg[7:0] z8,
    output reg[15:0] z16
    );
    
    wire[7:0] macc;
    assign macc = am[15:8];
    wire[7:0] left;
    wire[15:0] right;
    always @(*)
        begin
            case(fnsel)
                4'b0000 : z8 = 8'b00000000; 
                4'b0001 : z8 = mpcand;
                4'b0010 : z8 = left;
                4'b0011 : begin
                            z16[15:8] = macc + y;
                            z16[7:0] = am[7:0];
                          end
                4'b0100 : begin
                            z16[15:8] = macc - y;
                            z16[7:0] = am[7:0];
                          end
                4'b0101 : z1 = 1'b0;
                4'b0110 : z1 = am[1];
                4'b0111 : z16 = right;
                4'b1000 : z8 = x + 1;
            endcase
        end
        
    shl lshift(mpcand,left);
    shr rshift(am,right);
endmodule

module shl(
    input[7:0] mpcand,
    output[7:0] left
    );
    
    assign left[7] = mpcand[6];
    assign left[6] = mpcand[5];
    assign left[5] = mpcand[4];                          
    assign left[4] = mpcand[3];
    assign left[3] = mpcand[2];
    assign left[2] = mpcand[1];
    assign left[1] = mpcand[0];
    assign left[0] = 1'b0;
    
endmodule

module shr(
    input[15:0] am,
    output[15:0] right
    );
    
    assign right[15] = am[15];
    assign right[14] = am[15];
    assign right[13] = am[15];
    assign right[12] = am[14];
    assign right[11] = am[13];
    assign right[10] = am[12];
    assign right[9] = am[11];
    assign right[8] = am[10];
    assign right[7] = am[9];
    assign right[6] = am[8];
    assign right[5] = am[7];
    assign right[4] = am[6];
    assign right[3] = am[5];
    assign right[2] = am[4];
    assign right[1] = am[3];
    assign right[0] = am[2];
     
endmodule

module statdet(
    input[7:0] x,
    output status
    );  
    
    assign status = ~(x[2] | x[3] | x[4] | x[5] | x[6] | x[7]);
    
endmodule

module mux(
    input[7:0] count,mm,
    input[2:0] varselect,
    output reg [7:0] out
    );
    
    always @(*)
        begin
            case(varselect)
                3'b101 : out = mm;
                3'b011 : out = count;
            endcase   
        end
    
endmodule