`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2017 09:05:38 PM
// Design Name: 
// Module Name: behavioural
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

module test_perfect();
    reg[15:0] num;
    reg go;
    //reg clk;
    reg rst;
    wire display;
    wire over;
    
    initial
        begin
            num = 16'b0000000000011100;
            go = 1'b0;
            rst = 1'b1;
            //clk = 0;
            #20 go = 1'b1;
            #2000 go = 1'b0;
        end
        
    always
        begin
            //#20 clk = !clk;
            #20 rst = 1'b0;
        end
        
    FSM_controller fsm(num,go,rst,display,over);
endmodule

module FSM_controller(
    input[15:0] num,
    input go,rst,
    output display,over
    );
    
    reg clk;
    initial 
        begin
            clk = 1'b0;
        end   
        
    always
        begin
            #20 clk = !clk;
        end 
    
    wire[3:0] st;
    reg[3:0] nst;
    reg[2:0] fnsel;
    reg fnsel1;
    reg[2:0] varxselect;
    reg[2:0] varyselect;
    reg ldnum;
    reg ldcount;
    reg ldsum;
    reg ldrem;
    reg lddivor;
    reg over;
    reg display;
    wire statusz;
    wire statuseq;
    wire statuslt;
    wire statusgte;
    
    initial
        begin
            nst = 4'b0000;
        end
    
    delay flip(nst,clk,rst,st);
    datapath data(num,fnsel,varxselect,varyselect,ldnum,ldcount,ldsum,ldrem,lddivor,clk,rst,statusz,statuseq,statuslt,statusgte);
    
    always @(posedge clk)
        begin
            #5
            case(st)
                4'b0000 :   begin
                                ldnum = 1'b1;
                                #10 ldnum = 1'b0;
                                over = 1'b0;
                                display = 1'b0;
                                if(go)nst = 4'b0001;
                            end 
                            
                4'b0001 :   begin
                                fnsel = 3'b110;    
                                ldcount = 1'b1;
                                #10 ldcount = 1'b0;
                                fnsel = 3'b001;    
                                ldsum = 1'b1;
                                #10 ldsum = 1'b0;
                                nst = 4'b0010;
                            end
                            
                4'b0010 :   begin
                                if(statuslt)nst = 4'b0011;
                                else 
                                    begin
                                        if(statuseq)nst = 4'b1001;
                                        else nst = 4'b1000;
                                    end
                            end
                            
                4'b0011 :   begin
                                fnsel = 3'b000;
                                varxselect = 3'b000;
                                ldrem = 1'b1;
                                #10 ldrem = 1'b0;
                                varxselect = 3'b001;
                                lddivor = 1'b1;
                                #10 lddivor = 1'b0;
                                nst = 4'b0100;
                            end 
                            
                4'b0100 :   begin
                                if(statusgte)nst = 4'b0110;
                                else 
                                    begin
                                        if(statusz)nst = 4'b0101;
                                        else nst = 4'b0111;
                                    end
                            end
                            
                4'b0101 :   begin
                                fnsel = 3'b011;
                                varxselect = 3'b010;
                                varyselect = 3'b001;
                                ldsum = 1'b1;
                                #10 ldsum = 1'b0;
                                nst = 4'b0111;
                            end 
                            
                4'b0110 :   begin
                                fnsel = 3'b100;
                                varxselect = 3'b011;
                                varyselect = 3'b100;
                                ldrem = 1'b1;
                                #10 ldrem = 1'b0;
                                nst = 4'b0100;
                            end
                            
                4'b0111 :   begin
                                fnsel = 3'b101;
                                varxselect = 3'b001;
                                ldcount = 1'b1;
                                #10 ldcount = 1'b0;
                                nst = 4'b0010;
                            end 
                            
                4'b1000 :   begin
                                display = 1'b0;
                                nst = 4'b1010;
                            end 
                            
                4'b1001 :   begin
                                display = 1'b1;
                                nst = 4'b1010;
                            end 
                            
                4'b1010 :   begin
                                over = 1'b1;
                                if(~go)
                                    begin
                                        nst = 4'b0000;
                                        //$finish;
                                    end
                            end      
                            
                default :   nst = 4'b0000;        
            endcase
        end
        
endmodule

module delay(
    input[3:0] nst,
    input clk,rst,
    output[3:0] st
    );
    
    reg[3:0] st;
    
    always @(posedge clk)
        begin
            if(rst)st = 4'b0000;
            else
                begin
                    st = nst;
                end
        end

endmodule

module datapath(
    input[15:0] num,
    input[2:0] fnsel,
    input[2:0] varxselect,
    input[2:0] varyselect,
    input ldnum,ldcount,ldsum,ldrem,lddivor,clk,rst,
    output statusz,statuseq,statuslt,statusgte
    );
    
    wire[15:0] alux;
    wire[15:0] aluy;
    wire[15:0] aluz;
    
    wire[15:0] aluinnum;
    wire[15:0] aluincount;
    wire[15:0] aluinsum;
    wire[15:0] aluinrem;
    wire[15:0] aluindivor;
    
    wire[15:0] regincount;
    wire[15:0] reginsum;
    wire[15:0] reginrem;
    wire[15:0] regindivor;
    
    wire[15:0] regtcount;
    wire[15:0] regtsum;
    wire[15:0] regtrem;
    wire[15:0] regtdivor;
    
    regt16 A(num,ldnum,clk,rst,aluinnum);                                     //Number
    register16 B(regincount,ldcount,clk,rst,aluincount);                                     //Count
    register16 C(reginsum,ldsum,clk,rst,aluinsum);                                     //Sum 
    register16 D(reginrem,ldrem,clk,rst,aluinrem);                                     //Remainder
    register16 E(regindivor,lddivor,clk,rst,aluindivor);                                     //Divisor
    
    regt16 F(regtcount,ldcount,clk,rst,regincount);                                     
    regt16 G(regtsum,ldsum,clk,rst,reginsum);                                     
    regt16 L(regtrem,ldrem,clk,rst,reginrem);                                     
    regt16 M(regtdivor,lddivor,clk,rst,regindivor);     
    
    mux X(aluinnum,aluincount,aluinsum,aluinrem,aluindivor,varxselect,alux);
    mux Y(aluinnum,aluincount,aluinsum,aluinrem,aluindivor,varyselect,aluy);
    
    functional func(fnsel,clk,alux,aluy,aluz);
    
    statdetzero H(aluinrem,statusz);
    statdeteq I(aluinsum,aluinnum,statuseq);
    statdetlt J(aluincount,aluinnum,statuslt);
    statdetgte K(aluinrem,aluindivor,statusgte);
    
    assign regtcount = aluz;
    assign regtsum = aluz;
    assign regtrem = aluz;
    assign regtdivor = aluz;
    
endmodule

module register16(
    input[15:0] in,
    input signal,clk,rst,
    output[15:0] out
    );
    reg[15:0] out;
    
    always @(*)
        begin
            if(~signal)out = in;
            else out = out;
            if(rst)out = 16'b0000000000000000;
            else out = out;
        end
endmodule

module regt16(
    input[15:0] in,
    input signal,clk,rst,
    output[15:0] out
    );
    reg[15:0] out;
    
    always @(*)
        begin
            if(signal)out = in;
            else out = out;
            if(rst)out = 16'b0000000000000000;
            else out = out;
        end
endmodule

module functional(
    input[2:0] fnsel,
    input clk,
    input [15:0] x,
    input [15:0] y,
    output [15:0] z
    );
    
    reg[15:0] z;
    always @(*)
        begin
            case(fnsel)
                3'b000 : z = x; 
                3'b001 : z = 16'b0000000000000000;
                3'b010 : z = 16'b0000000000000001;
                3'b011 : z = x + y;
                3'b100 : z = x - y;
                3'b101 : z = x + 1;
                3'b110 : z = 16'b0000000000000010;
                default : z = 16'b0000000000000000;
            endcase
        end
endmodule

module statdetzero(
    input[15:0] x,
    output status
    );  
    
    assign status = ~(x[0] | x[1] | x[2] | x[3] | x[4] | x[5] | x[6] | x[7] | x[8] | x[9] | x[10] | x[11] | x[12] | x[13] | x[14] | x[15]);
    
endmodule

module statdeteq(
    input[15:0] x,
    input[15:0] y,
    output status 
    );
    
    wire[15:0] z;
    assign z = x + 1 - y;
    
    assign status = ~(z[0] | z[1] | z[2] | z[3] | z[4] | z[5] | z[6] | z[7] | z[8] | z[9] | z[10] | z[11] | z[12] | z[13] | z[14] | z[15]);
    
endmodule

module statdetlt(
    input[15:0] x,
    input[15:0] y,
    output status 
    );
    
    wire[15:0] z;
    assign z = x - y;
    
    assign status = (z[15]);
    
endmodule

module statdetgte(
    input[15:0] x,
    input[15:0] y,
    output status 
    );
    
    wire[15:0] z;
    assign z = x - y;
    
    assign status = ~(z[15]);
    
endmodule

module mux(
    input[15:0] num,count,sum,rem,divor,
    input[2:0] varselect,
    output[15:0] out
    );
    
    reg[15:0] out;
    
    always @(*)
        begin
            case(varselect)
                3'b000 : out = num;
                3'b001 : out = count;
                3'b010 : out = sum;
                3'b011 : out = rem;
                3'b100 : out = divor;
                default : out = num;
             endcase   
        end
    
endmodule