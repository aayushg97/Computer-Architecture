////////////////////////////////////////////////////////////////////


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
        reg[13:0] num;
        reg go;
        reg clk;
        reg rst;
        wire display;
        wire over;
        
        initial
            begin
                num = 14'b00000111110000;
                go = 1'b0;
                rst = 1'b1;
                clk = 0;
                #20 go = 1'b1;
                //#2000 go = 1'b0;
            end
            
        always
            begin
                #20 clk = !clk;
                #20 rst = 1'b0;
            end
            
        FSM_controller fsm(num,go,rst,clk,display,over);
    endmodule
    
    module FSM_controller(
        input[13:0] num,
        input go,rst,clk,
        output display,over
        );
        
        wire[3:0] st;
        reg[3:0] nst;
        reg[2:0] fnsel;
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
        
        always @(negedge clk)
            begin
                ldnum = 1'b0;
                ldcount = 1'b0;
                ldsum = 1'b0;
                ldrem = 1'b0;
                lddivor = 1'b0;
            end
        
        always @(posedge clk)
            begin
                case(st)
                    4'b0000 :   begin
                                    ldnum = 1'b0;
                                    ldcount = 1'b0;
                                    ldsum = 1'b0;
                                    ldrem = 1'b0;
                                    lddivor = 1'b0;
                                    ldnum = 1'b1;
                                    over = 1'b0;
                                    display = 1'b0;
                                    if(go)nst = 4'b0001;
                                    else nst = 4'b0000;
                                end 
                                
                    4'b0001 :   begin
                                    fnsel = 3'b110;    
                                    ldcount = 1'b1;
                                    nst = 4'b0010;
                                    
                                end
                                
                    4'b0010 :   begin
                                    fnsel = 3'b010;    
                                    ldsum = 1'b1;
                                    nst = 4'b0011;
                                end
                                
                    4'b0011 :   begin
                                    if(statuslt)nst = 4'b0100;
                                    else 
                                        begin
                                            if(statuseq)nst = 4'b1011;
                                            else nst = 4'b1010;
                                        end
                                end
                                
                    4'b0100 :   begin
                                    fnsel = 3'b000;
                                    varxselect = 3'b000;
                                    ldrem = 1'b1;
                                    nst = 4'b0101;
                                    
                                end 
                                
                    4'b0101 :   begin
                                    fnsel = 3'b000;
                                    varxselect = 3'b001;
                                    lddivor = 1'b1;
                                    nst = 4'b0110;
                                end
                                
                    4'b0110 :   begin
                                    if(statusgte)nst = 4'b1001;
                                    else 
                                        begin
                                            if(statusz)nst = 4'b0111;
                                            else nst = 4'b1000;
                                        end
                                end
                                
                    4'b0111 :   begin
                                    fnsel = 3'b011;
                                    varxselect = 3'b010;
                                    varyselect = 3'b001;
                                    ldsum = 1'b1;
                                    nst = 4'b1000;
                                end 
                                
                    4'b1001 :   begin
                                    fnsel = 3'b100;
                                    varxselect = 3'b011;
                                    varyselect = 3'b100;
                                    ldrem = 1'b1;
                                    nst = 4'b0110;
                                end
                                
                    4'b1000 :   begin
                                    fnsel = 3'b101;
                                    varxselect = 3'b001;
                                    ldcount = 1'b1;
                                    nst = 4'b0011;
                                end 
                                
                    4'b1010 :   begin
                                    display = 1'b0;
                                    nst = 4'b1100;
                                end 
                                
                    4'b1011 :   begin
                                    display = 1'b1;
                                    nst = 4'b1100;
                                end 
                                
                    4'b1100 :   begin
                                    over = 1'b1;
                                    if(~go)nst = 4'b0000;
                                    else nst = 4'b1100;
                                end      
                                
                endcase
            end
            
    endmodule
    
    module delay(
        input[3:0] nst,
        input clk,rst,
        output reg [3:0] st
        );
        
        always @(negedge clk)
            begin
                if(rst)st = 4'b0000;
                else st = nst;
            end
    
    endmodule
    
    module datapath(
        input[13:0] num,
        input[2:0] fnsel,
        input[2:0] varxselect,
        input[2:0] varyselect,
        input ldnum,ldcount,ldsum,ldrem,lddivor,clk,rst,
        output statusz,statuseq,statuslt,statusgte
        );
        
        wire[13:0] alux;
        wire[13:0] aluy;
        wire[13:0] aluz;
        
        wire[13:0] aluinnum;
        wire[13:0] aluincount;
        wire[13:0] aluinsum;
        wire[13:0] aluinrem;
        wire[13:0] aluindivor;
        
        wire[13:0] regincount;
        wire[13:0] reginsum;
        wire[13:0] reginrem;
        wire[13:0] regindivor;
        
        wire[13:0] regtcount;
        wire[13:0] regtsum;
        wire[13:0] regtrem;
        wire[13:0] regtdivor;
        
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
        input[13:0] in,
        input signal,clk,rst,
        output reg [13:0] out
        );

        reg pass;
        always @(*)
            begin
                if(~signal)out = in;
                else  pass=1'b0;
                if(rst)out = 14'b00000000000000;
                else pass = 1'b0;
            end
    endmodule
    
    module regt16(
        input[13:0] in,
        input signal,clk,rst,
        output reg [13:0] out
        );

        reg pass;
        always @(*)
            begin
                if(signal)out = in;
                else pass=1'b0;
                if(rst)out = 14'b00000000000000;
                else pass = 1'b0;
            end
    endmodule
    
    module functional(
        input[2:0] fnsel,
        input clk,
        input [13:0] x,
        input [13:0] y,
        output reg [13:0] z
        );
        

        always @(*)
            begin
                case(fnsel)
                    3'b000 : z = x; 
                    3'b001 : z = 14'b00000000000000;
                    3'b010 : z = 14'b00000000000001;
                    3'b011 : z = x + y;
                    3'b100 : z = x - y;
                    3'b101 : z = x + 1;
                    3'b110 : z = 14'b00000000000010;
                   
                endcase
            end
    endmodule
    
    module statdetzero(
        input[13:0] x,
        output status
        );  
        
        assign status = ~(x[0] | x[1] | x[2] | x[3] | x[4] | x[5] | x[6] | x[7] | x[8] | x[9] | x[10] | x[11] | x[12] | x[13]);
        
    endmodule
    
    module statdeteq(
        input[13:0] x,
        input[13:0] y,
        output status 
        );
        
        wire[13:0] z;
        assign z = x - y;
        
        assign status = ~(z[0] | z[1] | z[2] | z[3] | z[4] | z[5] | z[6] | z[7] | z[8] | z[9] | z[10] | z[11] | z[12] | z[13]);
        
    endmodule
    
    module statdetlt(
        input[13:0] x,
        input[13:0] y,
        output status 
        );
        
        wire[13:0] z;
        assign z = x - y;
        
        assign status = (z[13]);
        
    endmodule
    
    module statdetgte(
        input[13:0] x,
        input[13:0] y,
        output status 
        );
        
        wire[13:0] z;
        assign z = x - y;
        
        assign status = ~(z[13]);
        
    endmodule
    
    module mux(
        input[13:0] num,count,sum,rem,divor,
        input[2:0] varselect,
        output reg [13:0] out
        );
        
        always @(*)
            begin
                case(varselect)
                    3'b000 : out = num;
                    3'b001 : out = count;
                    3'b010 : out = sum;
                    3'b011 : out = rem;
                    3'b100 : out = divor;
                 endcase   
            end
        
    endmodule