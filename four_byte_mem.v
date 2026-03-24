`timescale 1ns / 1ps

module byte_memory(
    input [7:0] data,
    input store,
    output reg [7:0] memory
    );
    
    always @(data, store) begin
        if (store)
            memory[7:0] <= data[7:0];
    end
    
endmodule

module memory_system (
    input [7:0] data,
    input store,
    input [1:0] addr,
    output [7:0] memory
);

wire [0:0] arr_store[3:0];

demultiplexer_bit demux_store(
    .data(store),
    .sel(addr),
    .A(arr_store[0]),
    .B(arr_store[1]),
    .C(arr_store[2]),
    .D(arr_store[3])
);

wire [7:0] arr_data[3:0];


demultiplexer_byte demux_data(
    .data(data),
    .sel(addr),
    .A(arr_data[0]),
    .B(arr_data[1]),
    .C(arr_data[2]),
    .D(arr_data[3])
);

wire [7:0] arr_output[3:0];

byte_memory byte00_A(
    .data(arr_data[0]),
    .store(arr_store[0]),
    .memory(arr_output[0])
);

byte_memory byte01_B(
    .data(arr_data[1]),
    .store(arr_store[1]),
    .memory(arr_output[1])
);

byte_memory byte10_C(
    .data(arr_data[2]),
    .store(arr_store[2]),
    .memory(arr_output[2])
);

byte_memory byte11_D(
    .data(arr_data[3]),
    .store(arr_store[3]),
    .memory(arr_output[3])
);

multiplexer_byte mem_output (
    .A(arr_output[0]),
    .B(arr_output[1]),
    .C(arr_output[2]),
    .D(arr_output[3]),
    .sel(addr),
    .data(memory)
);

endmodule

module demultiplexer_byte(
    input [7:0] data,
    input [1:0] sel,
    output reg [7:0] A,
    output reg [7:0] B,
    output reg [7:0] C,
    output reg [7:0] D
);

    always @(*) begin 
        case(sel)
            2'b00: {D, C, B, A} <= {8'b0, 8'b0, 8'b0, data}; 
            2'b01: {D, C, B, A} <= {8'b0, 8'b0, data, 8'b0};
            2'b10: {D, C, B, A} <= {8'b0, data, 8'b0, 8'b0};
            2'b11: {D, C, B, A} <= {data, 8'b0, 8'b0, 8'b0};
        endcase
    end

endmodule

module demultiplexer_bit(
    input data,
    input [1:0] sel,
    output reg A,
    output reg B,
    output reg C,
    output reg D
);

    always @(*) begin 
        case(sel)
            2'b00: {D, C, B, A} <= {1'b0, 1'b0, 1'b0, data}; 
            2'b01: {D, C, B, A} <= {1'b0, 1'b0, data, 1'b0};
            2'b10: {D, C, B, A} <= {1'b0, data, 1'b0, 1'b0};
            2'b11: {D, C, B, A} <= {data, 1'b0, 1'b0, 1'b0};
        endcase
    end

endmodule

module multiplexer_byte(
    output reg [7:0] data,
    input [1:0] sel,
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D
);

    always @(*) begin 
        case(sel)
            2'b00: data <= A; 
            2'b01: data <= B;
            2'b10: data <= C;
            2'b11: data <= D;
        endcase
    end

endmodule
