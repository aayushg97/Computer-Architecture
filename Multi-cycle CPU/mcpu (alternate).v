`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2017 11:36:58 PM
// Design Name: 
// Module Name: ecpu
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


module testbench();
    reg clk;
    reg[15:0] pci;
    reg[15:0] spi;
    initial
        begin
            clk = 1'b1;
            pci = 16'b0000000001011010;
            spi = 16'b0000000000000000;
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
    
    // GPR's and special purpose registers
    wire tpc,tmar,tt,t1,tn1,tir,trb,tsp,tzmdr,txmdr,tdmdr;
    wire ldmar,ldir,ldt,ldpc,ldxmdr,lddmdr,ldzmdr,ldsp,ldrb;
    wire[2:0] fnsel;
    wire statusa,statusb,statusc,cf;
    wire[2:0] statusd;
    wire rd,w,cng,mfc;
    
    controller CONTROL(clk,statusa,statusb,statusc,cf,mfc,statusd,tpc,tmar,tt,t1,tn1,tir,trb,tsp,tzmdr,txmdr,tdmdr,ldmar,ldir,ldt,ldpc,ldxmdr,lddmdr,ldzmdr,ldsp,ldrb,fnsel,rd,w,cng);
    
    datapath DATAPATH(clk,cng,tpc,tmar,rd,w,tt,t1,tn1,tir,trb,tsp,tzmdr,txmdr,tdmdr,ldmar,ldir,ldt,ldpc,ldxmdr,lddmdr,ldzmdr,ldsp,ldrb,fnsel,statusa,statusb,statusc,cf,mfc,statusd,pci,spi);
endmodule

module controller(
    input clk,
    input statusa,statusb,statusc,cf,mfc,
    input[2:0] statusd,
    output reg tpc,tmar,tt,t1,tn1,tir,trb,tsp,tzmdr,txmdr,tdmdr,ldmar,ldir,ldt,ldpc,ldxmdr,lddmdr,ldzmdr,ldsp,ldrb,
    output reg[2:0] fnsel,
    output reg rd,w,cng
    );
   
    // states
    wire[4:0] st;
    reg[4:0] nst;
    reg useless;
    
    initial
        begin
            nst = 5'b00000;
            tpc = 1'b0;
            ldmar = 1'b0;
            tmar = 1'b0;
            rd = 1'b0;
            ldir = 1'b0;
            w = 1'b0;
            cng = 1'b1;
            tt = 1'b0;
            t1 = 1'b0;
            tir = 1'b0;
            tn1 = 1'b0;
            trb = 1'b0;
            tsp = 1'b0;
            tzmdr = 1'b0;
            txmdr = 1'b0;
            tdmdr = 1'b0;
            ldt = 1'b0;
            ldpc = 1'b0;
            ldxmdr = 1'b0;
            lddmdr = 1'b0;
            ldzmdr = 1'b0;
            ldsp = 1'b0;
            ldrb = 1'b0;
        end
    
    always @(posedge clk)
        begin
            case(st)
                5'b00000 : 
                    begin
                        //tpc = 1'b0;
                        //ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tpc = 1'b1;
                        ldmar = 1'b1;
                        nst = 5'b00001;   
                    end
                    
                5'b00001 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        //tmar = 1'b0;
                        //rd = 1'b0;
                        //ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tmar = 1'b1;
                        rd = 1'b1;
                        ldir = 1'b1;
                        nst = 5'b00010;
                    end
                    
                5'b00010 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        nst = 5'b00011;
                    end
                    
                5'b00011 :
                    begin
                        //tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        //ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tpc = 1'b1;
                        ldt = 1'b1;
                        nst = 5'b00100;
                    end
                    
                5'b00100 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        //tt = 1'b0;
                        //t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        //ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        ldpc = 1'b1;
                        tt = 1'b1;
                        t1 = 1'b1;
                        fnsel = 3'b000;
                        if(statusa==1'b1)
                            begin
                                if(statusb==1'b1)nst = 5'b00101;
                                else nst = 5'b01000;
                            end
                        else
                            begin
                                if(statusc==1'b1)nst = 5'b00111;
                                else 
                                    begin
                                        if(cf==1'b1)nst = 5'b11010;
                                        else nst = 5'b00000;
                                        cng = 1'b1;
                                    end
                            end
                    end
                    
                5'b00101 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        //trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        //ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        trb = 1'b1;
                        ldxmdr = 1'b1;           
                        // port address in the datapath
                        nst = 5'b10101;
                    end
                
                5'b00110 :
                    begin
                        // may be useless state
                        // nst = 5'b;
                    end
                    
                5'b00111 :
                    begin
                        //tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        //ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tpc = 1'b1;
                        ldxmdr = 1'b1;
                        nst = 5'b10101;
                    end
                
                5'b01000 :
                    begin
                        tpc = 1'b0;
                        //ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        //tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tsp = 1'b1;
                        ldmar = 1'b1;
                        nst = 5'b01001;
                    end
                
                5'b01001 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        //tmar = 1'b0;
                        //rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        //lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tmar = 1'b1;
                        rd = 1'b1;
                        lddmdr = 1'b1;
                        nst = 5'b01010;
                    end
                    
                5'b01010 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        nst = 5'b01011;
                    end
                    
                5'b01011 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        //tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        //ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tsp = 1'b1;
                        ldt = 1'b1;
                        nst = 5'b01100;
                    end
                
                5'b01100 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        //tt = 1'b0;
                        //t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        //ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tt = 1'b1;
                        t1 = 1'b1;
                        ldsp = 1'b1;
                        fnsel = 3'b000;    
                        case(statusd)
                            3'b000 : nst = 5'b01101;
                            3'b001 : nst = 5'b01110;
                            3'b010 : nst = 5'b01111;
                            3'b011 : nst = 5'b10001;
                            3'b100 : nst = 5'b10010;
                            3'b101 : nst = 5'b10100; 
                        endcase
                    end
                    
                5'b01101 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        //txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        //ldrb = 1'b0;
                        
                        
                        txmdr = 1'b1;
                        fnsel = 3'b100;
                        ldrb = 1'b1;
                        nst = 5'b00000;
                    end
                
                5'b01110 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        //txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        //ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        txmdr = 1'b1;
                        fnsel = 3'b100;
                        ldpc = 1'b1;
                        nst = 5'b00000;
                    end
                
                5'b01111 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        //trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        //ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        trb = 1'b1;
                        ldt = 1'b1;
                        nst = 5'b10000;
                    end
                    
                5'b10000 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        //tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        //txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        //ldrb = 1'b0;
                        
                        
                        tt = 1'b1;
                        txmdr = 1'b1;
                        ldrb = 1'b1;
                        fnsel = 3'b000;
                        nst = 5'b00000;
                    end
                    
                5'b10001 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        //txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        //ldrb = 1'b0;
                        
                        
                        txmdr = 1'b1;
                        ldrb = 1'b1;
                        fnsel = 3'b001;
                        nst = 5'b00000;
                    end
                
                5'b10010 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        //trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        //ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        trb = 1'b1;
                        ldt = 1'b1;
                        nst = 5'b10011;
                    end
                    
                5'b10011 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        //tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        //txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        //ldrb = 1'b0;
                        
                        
                        tt = 1'b1;
                        txmdr = 1'b1;
                        ldrb = 1'b1;
                        fnsel = 3'b010;
                        nst = 5'b00000;
                    end
                
                5'b10100 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        //txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        //ldrb = 1'b0;
                        
                        
                        txmdr = 1'b1;
                        ldrb = 1'b1;
                        fnsel = 3'b011;
                        nst = 5'b00000;
                    end
                
                5'b10101 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        //tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        //ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tsp = 1'b1;
                        ldt = 1'b1;    
                        nst = 5'b10110;
                    end
                    
                5'b10110 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        //tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        //tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        //ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tt = 1'b1;
                        tn1 = 1'b1;
                        ldsp = 1'b1;
                        fnsel = 3'b000;
                        nst = 5'b10111;
                    end
                    
                5'b10111 :
                    begin
                        tpc = 1'b0;
                        //ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        //tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tsp = 1'b1;
                        ldmar = 1'b1;
                        nst = 5'b11000;
                    end
                
                5'b11000 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        //tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                       // w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        //tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tmar = 1'b1;
                        tdmdr = 1'b1;
                        w = 1'b1;
                        nst = 5'b11001;
                    end
                    
                5'b11001 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        if(statusa==1'b1)nst = 5'b00000;
                        else nst = 5'b11010;
                    end
                
                5'b11010 :
                    begin
                        //tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        tt = 1'b0;
                        t1 = 1'b0;
                        tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        //ldt = 1'b0;
                        ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                        
                        
                        tpc = 1'b1;
                        ldt = 1'b1;    
                        nst = 5'b11011;
                    end
                
                5'b11011 :
                    begin
                        tpc = 1'b0;
                        ldmar = 1'b0;
                        tmar = 1'b0;
                        rd = 1'b0;
                        ldir = 1'b0;
                        w = 1'b0;
                        //tt = 1'b0;
                        t1 = 1'b0;
                        //tir = 1'b0;
                        tn1 = 1'b0;
                        trb = 1'b0;
                        tsp = 1'b0;
                        tzmdr = 1'b0;
                        txmdr = 1'b0;
                        tdmdr = 1'b0;
                        ldt = 1'b0;
                        //ldpc = 1'b0;
                        ldxmdr = 1'b0;
                        lddmdr = 1'b0;
                        ldzmdr = 1'b0;
                        ldsp = 1'b0;
                        ldrb = 1'b0;
                    
                    
                        tt = 1'b1;
                        tir = 1'b1;
                        ldpc = 1'b1;    
                        nst = 5'b00000;
                    end
            endcase
        end
    
    delay D(clk,nst,st);
    
endmodule

module delay(
    input clk,
    input[5:0] nst,
    output reg[5:0] st
    );
    
    initial
        begin
            st = 5'b00000;
        end
    always @(negedge clk)
        begin
            st = nst;
        end

endmodule

module datapath(
	input clk,cng,tpc,tmar,rd,w,tt,t1,tn1,tir,trb,tsp,tzmdr,txmdr,tdmdr,ldmar,ldir,ldt,ldpc,ldxmdr,lddmdr,ldzmdr,ldsp,ldrb,
	input[2:0] fnsel,
	output statusa,statusb,statusc,cf,mfc,
	output[2:0] statusd,
	input[15:0] pci,spi
    );
    
    wire[15:0] xbus,zbus,abus,dbus,opr1,instr;
    wire c,v,s,z;
    
    memory MEMO(clk,rd,w,abus,dbus,mfc);
    spr SP(clk,tsp,ldsp,zbus,xbus,spi);
    spr PC(clk,tpc,ldpc,zbus,xbus,pci);
    spr MAR(clk,tmar,ldmar,xbus,abus,pci);
    vspr IR(clk,tir,ldir,dbus,xbus,instr);
    spr T(clk,tt,ldt,xbus,opr1,spi);
    regc1 CONST1(t1,xbus);
    regcn1 CONSTN1(tn1,xbus);
    datareg MDR(clk,tdmdr,txmdr,tzmdr,lddmdr,ldxmdr,ldzmdr,dbus,xbus,zbus);
    regbank RB(clk,trb,ldrb,instr,zbus,xbus);
    stata STA(instr,statusa);
    statb STB(instr,statusb);
    statc STC(instr,statusc);
    statd STD(instr,statusd);
    alu LUNIT(clk,cng,opr1,xbus,fnsel,c,z,v,s,zbus);
    condflag CF(c,z,v,s,instr,cf);
    
endmodule

module memory(
		input clk,rd,w,
		input[15:0] abus,
		inout[15:0] dbus,
		output reg mfc
	);
	
	reg[15:0] Mem[0:127];
	reg useless;
	
	initial
        begin
            Mem[0] = 16'b0000000000000011;
            Mem[1] = 16'b1111111111111101;
            Mem[2] = 16'b0000000000101011;
            Mem[55] = 16'b0000010000000000;
            Mem[56] = 16'b0000110000000000;
            Mem[57] = 16'b0100000000100000;
            Mem[58] = 16'b0001000000101110;
            Mem[90] = 16'b0000010000100000;
            Mem[91] = 16'b0000000000000000;
            Mem[92] = 16'b0000111000100000;
            Mem[93] = 16'b0000000000100000;
            Mem[94] = 16'b0001000000001011;
            Mem[105] = 16'b0000000000000000;
	   end
	
	assign dbus = (rd) ? Mem[abus] : 'bz;
	
	always @(posedge w)
	   begin
	       #1
	       Mem[abus] = dbus;
       end

endmodule

module regbank(
    input clk,
    input t,ld,
    input[15:0] instr,
    input[15:0] inbus,
    output[15:0] outbus
    );
    
    wire t0,t1,t2,t3,t4,t5,t6,t7,ld0,ld1,ld2,ld3,ld4,ld5,ld6,ld7;
    reg[15:0] rout;
    reg useless;
    wire[15:0] init;
    
    assign t0 = t & (~instr[7]) & (~instr[6]) & (~instr[5]);
    assign t1 = t & (~instr[7]) & (~instr[6]) & instr[5];
    assign t2 = t & (~instr[7]) & instr[6] & (~instr[5]);
    assign t3 = t & (~instr[7]) & instr[6] & instr[5];
    assign t4 = t & instr[7] & (~instr[6]) & (~instr[5]);
    assign t5 = t & instr[7] & (~instr[6]) & instr[5];
    assign t6 = t & instr[7] & instr[6] & (~instr[5]);
    assign t7 = t & instr[7] & instr[6] & instr[5];    
    
    assign ld0 = ld & (~instr[7]) & (~instr[6]) & (~instr[5]);
    assign ld1 = ld & (~instr[7]) & (~instr[6]) & instr[5];
    assign ld2 = ld & (~instr[7]) & instr[6] & (~instr[5]);
    assign ld3 = ld & (~instr[7]) & instr[6] & instr[5];
    assign ld4 = ld & instr[7] & (~instr[6]) & (~instr[5]);
    assign ld5 = ld & instr[7] & (~instr[6]) & instr[5];
    assign ld6 = ld & instr[7] & instr[6] & (~instr[5]);
    assign ld7 = ld & instr[7] & instr[6] & instr[5];
    
    spr r0(clk,t0,ld0,inbus,outbus,init);
    spr r1(clk,t1,ld1,inbus,outbus,init);
    spr r2(clk,t2,ld2,inbus,outbus,init);
    spr r3(clk,t3,ld3,inbus,outbus,init);
    spr r4(clk,t4,ld4,inbus,outbus,init);
    spr r5(clk,t5,ld5,inbus,outbus,init);
    spr r6(clk,t6,ld6,inbus,outbus,init);
    spr r7(clk,t7,ld7,inbus,outbus,init);

endmodule

module spr(
    input clk,
    input t,ld,
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
    
    always @(posedge ld)
        begin
            #1 register = inbus;
        end
    
    assign outbus = t ? register : 'bz;
    
endmodule

module vspr(
    input clk,
    input t,ld,
    input[15:0] inbus,
    output[15:0] outbus,
    output[15:0] instr
    );
    
    reg[15:0] register;
    reg[15:0] halfreg;
    reg useless;
    
    always @(posedge ld)
        begin
            #1 register = inbus;
            halfreg[11:0] = register[11:0];
            halfreg[15:12] = 4'b0000;
        end
    
    assign outbus = t ? halfreg : 'bz;
    assign instr = register;
    
endmodule

module datareg(
    input clk,td,tx,tz,
    input ldd,ldx,ldz,
    inout[15:0] iobusd,iobusx,iobusz
    );
    
    reg[15:0] register;
    reg useless;
    
    always @(posedge ldd or posedge ldx or posedge ldz)
        begin
            #1
            if(ldd==1'b1)register = iobusd;
            else
                begin
                    if(ldx==1'b1)register = iobusx;
                    else
                        begin
                            if(ldz==1'b1)register = iobusz;
                            else useless = 1'b0;
                        end
                end
        end
        
    assign iobusd = td ? register : 'bz;
    assign iobusx = tx ? register : 'bz;
    assign iobusz = tz ? register : 'bz;

endmodule

module regc1(
    input t,
    output[15:0] outbus
    );

    assign outbus = t ? 16'b0000000000000001 : 'bz;    

endmodule

module regcn1(
    input t,
    output[15:0] outbus
    );

    assign outbus = t ? 16'b1111111111111111 : 'bz;    

endmodule

module stata(
    input[15:0] instr,
    output statusa
    );
    
    assign statusa = !(instr[15] | instr[14] | instr[13] | instr[12]);

endmodule

module statb(
    input[15:0] instr,
    output statusb
    );
    
    assign statusb = !(instr[11] | instr[10]);

endmodule

module statc(
    input[15:0] instr,
    output statusc
    );
    
    assign statusc = (instr[15] & ~(instr[14]) & instr[13] & ~(instr[12]));

endmodule

module statd(
    input[15:0] instr,
    output[2:0] statusd
    );
    
    assign statusd[2] = (instr[11] & instr[10] & instr[9]);
    assign statusd[1] = (instr[11] & instr[10] & ~(instr[9]));
    assign statusd[0] = (~(instr[10]) | instr[8]);

endmodule

module alu(
    input clk,cng,
    input[15:0] in1,inbus,
    input[2:0] fnsel,
    output reg c,z,v,s,
    output[15:0] outbus
    );

    reg[15:0] z1;
    reg z2;
    reg[16:0] zadd1,zadd2,zadd;
    
    always @(*)
        begin
            case(fnsel)
                3'b000 : z1 = in1 + inbus;
                3'b001 : z1 = -inbus;
                3'b010 : z1 = in1 | inbus;
                3'b011 : z1 = !inbus;
                3'b100 : z1 = inbus;
            endcase
        end
    
    assign outbus = z1;
    
    always @(*)
        begin
            if(cng==1'b1)
                begin
                    zadd1[15:0] = in1;
                    zadd1[16] = 1'b0;
                    zadd2[15:0] = inbus;
                    zadd2[16] = 1'b0;
                    zadd = zadd1 + zadd2;
                    c = zadd[16];
                    v = ((~in1[15]) & (~inbus[15]) & zadd[15]) | (in1[15] & inbus[15] & (~zadd[15]));
                    s = zadd[15];
                    z = ((in1+inbus)==16'b0000000000000000) ? 1'b1 : 1'b0;
                end
            else
                begin
                
                end
        end
   
endmodule

module condflag(
    input c,z,v,s,
    input[15:0] instr,
    output cf
    );
    
    assign cf = ((~instr[15]) & (~instr[14]) & (~instr[13]) & instr[12]) | ((~instr[15]) & (~instr[14]) & instr[13] & (instr[12]^c)) | ((~instr[15]) & instr[14] & (~instr[13]) & (instr[12]^z)) | ((~instr[15]) & instr[14] & instr[13] & (instr[12]^v)) | (instr[15] & (~instr[14]) & (~instr[13]) & (instr[12]^s)); 
    
endmodule
