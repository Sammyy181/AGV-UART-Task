`timescale 1ns/1ps

// Don't forget to import your module files here
`include "distanceProcess.v"
`include "TxD.v"
`include "uart_rx.v"
`include "RxD.v"

module topModule(
    input wire receiveData,
    input wire clk,
    input wire reset,
    output wire transmitData
    // We don't think you will need any other inputs and outputs, but feel free to add what you want here, and mention it while submitting your code
);

// Include your submodules for receiving, processing and transmitting your data here, we have included sample modules without any inputs and outputs for now

    wire dv_from_rx;
    wire [7:0] ct_from_rx;
    wire [15:0] fsa_from_rx;
    wire [15:0] lsa_from_rx;
    wire dv_to_tx;
    wire [15:0] obs_alert;
    wire [15:0] max_dist_angle;
    wire [15:0] min_dist_angle;

    RxD R0 (
        .clk(clk),
        .serial(receiveData),
        .reset(reset),
        .rx_dv(dv_from_rx),
        .s_CT(ct_from_rx),
        .s_FSA(fsa_from_rx),
        .s_LSA(lsa_from_rx)
    );

    distanceProcess D0 (
        .clk(clk),
        .rx_dv(dv_from_rx), 
        .reset(reset),
        .ct(ct_from_rx),           
        .FSA(fsa_from_rx),         
        .LSA(lsa_from_rx),         
        .dv(dv_to_tx),            
        .obs_alert(obs_alert),
        .max_dist_angle(max_dist_angle),
        .min_dist_angle(min_dist_angle)
    );

   
    TxD T0 (
        .clk(clk),
        .reset(reset),                    
        .start_signal_bit(dv_to_tx),
        .max_distance_angle(max_dist_angle),
        .min_distance_angle(min_dist_angle),
        .obs_alert(obs_alert),
        .Tx(transmitData)
    );

endmodule