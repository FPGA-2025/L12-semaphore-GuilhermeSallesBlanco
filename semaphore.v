module Semaphore #(
    parameter CLK_FREQ = 100_000_000
) (
    input wire clk,
    input wire rst_n,

    input wire pedestrian,

    output wire green,
    output wire yellow,
    output wire red
);

reg [1:0] estado; // Variável para guardar o estado atual

localparam [2:0] RED = 2'b01, YELLOW = 2'b10, GREEN = 2'b11; // Definindo os estados

reg [31:0] contador; // Variável de armazenamento do contador
localparam RED_TIME = (5 * CLK_FREQ) - 1; // Tempo em ciclos para o estado RED
localparam YELLOW_TIME = (CLK_FREQ / 2) - 1; // Tempo em ciclo para o estado YELLOW
localparam GREEN_TIME = (7 * CLK_FREQ) - 1; // Tempo em ciclos para o estado GREEN

assign red = (estado == RED);
assign yellow = (estado == YELLOW);
assign green = (estado == GREEN);

// Lógica de alteração de estado
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        estado <= RED; // Se o reset for acionado, inicia no estado RED
        contador <= 0;
    end else begin
        case(estado)
        RED: begin if(contador >= RED_TIME) begin // Contanto que o contador não tenha passado do limite do vermelho, permanece nele. Caso contrário, vai pra verde.
            estado <= GREEN;
            contador <= 0;
        end else begin
            estado <= RED;
            contador <= contador + 1;
        end
        end
        GREEN: begin if(pedestrian || contador >= GREEN_TIME) begin // Se o pedestre ativar o botão, ou o tempo do verde passar do limite, passa pro amarelo.
            estado <= YELLOW;
            contador <= 0;
        end else begin
            estado <= GREEN;
            contador <= contador + 1;
        end
        end
        YELLOW: begin if(contador >= YELLOW_TIME) begin // Contanto que o contador não tenha passado do limite do amarelo, permanece nele. Caso contrário, vai para vermelho.
            estado <= RED;
            contador <= 0;
        end else begin
            estado <= YELLOW;
            contador <= contador + 1;
        end
        end
        default: begin 
            estado <= RED;
            contador <= 0;
        end
    endcase
    end
end

endmodule
