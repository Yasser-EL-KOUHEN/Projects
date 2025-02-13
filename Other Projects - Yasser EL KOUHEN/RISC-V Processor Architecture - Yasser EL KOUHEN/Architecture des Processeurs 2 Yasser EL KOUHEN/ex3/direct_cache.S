// direct_cache.sv
module direct_cache #(
    // Q1: Caractéristiques du cache
    localparam ByteOffsetBits = 4,               // 4 bits d'offset => 16 octets par ligne
    localparam IndexBits      = 6,               // 6 bits d'index => 64 lignes
    localparam TagBits        = 22,              // 22 bits de tag (32-4-6)
    localparam NrWordsPerLine = 4,               // 4 mots (32 bits chacun) par ligne
    localparam NrLines        = 1 << IndexBits,  // Nombre de lignes = 2^6 = 64
    localparam LineSize       = 32 * NrWordsPerLine // Taille d'une ligne en bits (4*32 = 128 bits)
) (
    input  logic        clk_i,
    input  logic        rstn_i,

    input  logic [31:0] addr_i,

    // Port lecture du processeur
    input  logic        read_en_i,
    output logic        read_valid_o,
    output logic [31:0] read_word_o,

    // Port vers la mémoire
    output logic [31:0] mem_addr_o,

    // Port lecture de la mémoire
    output logic        mem_read_en_o,
    input  logic        mem_read_valid_i,
    input  logic [LineSize-1:0] mem_read_data_i
);

    // Q2: Déclaration des registres de stockage
    // Pour chaque ligne du cache, on stocke : 
    // - un bit de validité,
    // - le tag associé (22 bits),
    // - la donnée sur une ligne complète (128 bits).
    logic        valid    [NrLines-1:0];
    logic [TagBits-1:0] tag_mem  [NrLines-1:0];
    logic [LineSize-1:0] data_mem [NrLines-1:0];

    // Q4: Découpage de l'adresse en tag, index et offset.
    // Pour une adresse de 32 bits :  [31:10] tag, [9:4] index, [3:0] offset.
    wire [TagBits-1:0]       addr_tag   = addr_i[31:10];
    wire [IndexBits-1:0]     addr_index = addr_i[9:4];
    wire [ByteOffsetBits-1:0] addr_offset= addr_i[3:0];

    // Pour extraire le mot dans une ligne, on utilise les bits d'offset supérieurs :
    localparam WordOffsetBits = $clog2(NrWordsPerLine);
    wire [WordOffsetBits-1:0] word_index = addr_offset[ByteOffsetBits-1:2];

    // Q5: Signal indiquant si la requête est un hit
    wire hit = valid[addr_index] && (tag_mem[addr_index] == addr_tag);

    // Pour gérer un accès en cas de miss, nous utilisons une FSM simple.
    typedef enum logic [1:0] { IDLE, MISS_WAIT } state_t;
    state_t state, next_state;

    // Registre pour mémoriser l'adresse de la requête en cas de miss.
    logic [31:0] req_addr;
    // On recalcule les champs de req_addr pour le traitement du miss.
    wire [TagBits-1:0]       req_tag    = req_addr[31:ByteOffsetBits+IndexBits]; // [31:10]
    wire [IndexBits-1:0]     req_index  = req_addr[ByteOffsetBits+IndexBits-1:ByteOffsetBits]; // [9:4]
    wire [ByteOffsetBits-1:0] req_offset = req_addr[ByteOffsetBits-1:0]; // [3:0]
    wire [WordOffsetBits-1:0] req_word_index = req_offset[ByteOffsetBits-1:2];

    // Q7: Logique combinatoire pour la requête à la mémoire et la transition d'état
    always_comb begin
        // Affectations par défaut
        next_state     = state;
        mem_read_en_o  = 1'b0;
        mem_addr_o     = 32'b0;
        if (state == IDLE) begin
            if (read_en_i && !hit) begin
                // Q7: En cas de miss, envoyer une requête à la mémoire avec l'adresse alignée.
                next_state    = MISS_WAIT;
                mem_read_en_o = 1'b1;
                // L'adresse mémoire doit être alignée sur la taille de la ligne (mise à 0 des bits d'offset).
                mem_addr_o    = {addr_i[31:ByteOffsetBits], {ByteOffsetBits{1'b0}}};
            end
        end
        else if (state == MISS_WAIT) begin
            if (mem_read_valid_i) begin
                next_state = IDLE;
            end
        end
    end

    // Q3 & Q9: Logique séquentielle pour le passage d'état, stockage de req_addr et mise à jour du cache.
    always_ff @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            state    <= IDLE;
            req_addr <= 32'b0;
            // Q2: Mise à l'état invalide de toutes les lignes lors du reset.
            for (int i = 0; i < NrLines; i++) begin
                valid[i]    <= 1'b0;
                tag_mem[i]  <= '0;
                data_mem[i] <= '0;
            end
        end else begin
            state <= next_state;
            // Lorsqu'une requête est en cours et qu'il y a un miss, on mémorise l'adresse.
            if (state == IDLE && read_en_i && !hit)
                req_addr <= addr_i;
            // Q9: Dès que la mémoire renvoie des données, on met à jour la ligne du cache.
            if (state == MISS_WAIT && mem_read_valid_i) begin
                data_mem[req_index] <= mem_read_data_i;
                tag_mem[req_index]  <= req_tag;
                valid[req_index]    <= 1'b1;
            end
        end
    end

    // Q6 & Q8: Logique de réponse au processeur.
    // En cas de hit, on renvoie le mot extrait de la ligne du cache.
    // En cas de miss, dès que la mémoire renvoie sa réponse, on transmet le mot demandé.
    always_comb begin
        if (state == IDLE) begin
            if (read_en_i && hit) begin
                read_valid_o = 1'b1;
                read_word_o  = data_mem[addr_index][32*word_index +: 32];
            end else begin
                read_valid_o = 1'b0;
                read_word_o  = 32'b0;
            end
        end else if (state == MISS_WAIT) begin
            if (mem_read_valid_i) begin
                read_valid_o = 1'b1;
                read_word_o  = mem_read_data_i[32*req_word_index +: 32];
            end else begin
                read_valid_o = 1'b0;
                read_word_o  = 32'b0;
            end
        end else begin
            read_valid_o = 1'b0;
            read_word_o  = 32'b0;
        end
    end

endmodule
