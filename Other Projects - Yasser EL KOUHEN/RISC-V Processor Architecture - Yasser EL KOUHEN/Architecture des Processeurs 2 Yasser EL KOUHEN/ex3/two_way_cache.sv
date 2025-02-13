// two_way_cache.sv
module two_way_cache #(
    // Q1: Paramétrage identique au cache direct pour les dimensions de ligne
    localparam ByteOffsetBits = 4,               // 4 bits d'offset => 16 octets par ligne
    localparam IndexBits      = 6,               // 6 bits d'index => 64 ensembles (sets)
    localparam TagBits        = 22,              // 22 bits de tag
    localparam NrWordsPerLine = 4,               // 4 mots par ligne
    localparam NrLines        = 1 << IndexBits,  // Nombre d'ensembles = 64
    localparam LineSize       = 32 * NrWordsPerLine // Taille d'une ligne en bits (128 bits)
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

    // Q11: Déclaration des registres pour le cache à 2 voies et pour le LRU
    // Chaque ensemble (set) possède 2 voies.
    logic                valid    [1:0][NrLines-1:0];      // valid[voie][set]
    logic [TagBits-1:0]  tag_mem  [1:0][NrLines-1:0];      // tag par voie
    logic [LineSize-1:0] data_mem [1:0][NrLines-1:0];       // données par voie
    // Pour chaque ensemble, un bit LRU : 0 signifie que la voie 0 est la moins récemment utilisée (à évincer)
    // et 1 signifie que c'est la voie 1.
    logic lru [NrLines-1:0];

    // Q4: Découpage de l'adresse en tag, index et offset.
    // Pour une adresse 32 bits : [31:10] tag, [9:4] index, [3:0] offset.
    wire [TagBits-1:0]       addr_tag   = addr_i[31:ByteOffsetBits+IndexBits]; // [31:10]
    wire [IndexBits-1:0]     addr_index = addr_i[ByteOffsetBits+IndexBits-1:ByteOffsetBits]; // [9:4]
    wire [ByteOffsetBits-1:0] addr_offset= addr_i[ByteOffsetBits-1:0]; // [3:0]

    localparam WordOffsetBits = $clog2(NrWordsPerLine);
    wire [WordOffsetBits-1:0] word_index = addr_offset[ByteOffsetBits-1:2];

    // Q12: Vérification de hit pour chaque voie
    wire hit_way0 = valid[0][addr_index] && (tag_mem[0][addr_index] == addr_tag);
    wire hit_way1 = valid[1][addr_index] && (tag_mem[1][addr_index] == addr_tag);
    wire hit      = hit_way0 || hit_way1;

    // FSM pour gérer les miss.
    typedef enum logic [1:0] { IDLE, MISS_WAIT } state_t;
    state_t state, next_state;

    // Registres pour mémoriser l'adresse de la requête et la voie choisie lors d'un miss.
    logic [31:0] req_addr;
    logic        req_way; // Q14: voie à évincer (0 ou 1)

    // On recalcule les champs de req_addr.
    wire [TagBits-1:0]       req_tag    = req_addr[31:ByteOffsetBits+IndexBits];
    wire [IndexBits-1:0]     req_index  = req_addr[ByteOffsetBits+IndexBits-1:ByteOffsetBits];
    wire [ByteOffsetBits-1:0] req_offset = req_addr[ByteOffsetBits-1:0];
    wire [WordOffsetBits-1:0] req_word_index = req_offset[ByteOffsetBits-1:2];

    // Q7: Logique combinatoire pour la requête à la mémoire
    always_comb begin
        next_state    = state;
        mem_read_en_o = 1'b0;
        mem_addr_o    = 32'b0;
        if (state == IDLE) begin
            if (read_en_i && !hit) begin
                next_state    = MISS_WAIT;
                mem_read_en_o = 1'b1;
                mem_addr_o    = {addr_i[31:ByteOffsetBits], {ByteOffsetBits{1'b0}}};
            end
        end
        else if (state == MISS_WAIT) begin
            if (mem_read_valid_i)
                next_state = IDLE;
        end
    end

    // Q3, Q9, Q11, Q13, Q14, Q15: FSM et mise à jour du cache et du LRU.
    always_ff @(posedge clk_i or negedge rstn_i) begin
        if (!rstn_i) begin
            state    <= IDLE;
            req_addr <= 32'b0;
            req_way  <= 0;
            // Initialisation de tous les ensembles et voies
            for (int i = 0; i < NrLines; i++) begin
                valid[0][i]   <= 1'b0;
                valid[1][i]   <= 1'b0;
                tag_mem[0][i] <= '0;
                tag_mem[1][i] <= '0;
                data_mem[0][i]<= '0;
                data_mem[1][i]<= '0;
                lru[i]        <= 1'b0; // Par défaut, voie 0 est considérée comme LRU
            end
        end else begin
            state <= next_state;
            // En cas de miss (IDLE et read_en avec !hit), mémoriser l'adresse et choisir la voie à évincer.
            if (state == IDLE && read_en_i && !hit) begin
                req_addr <= addr_i;
                // Q14: Sélection de la voie à évincer
                if (!valid[0][addr_index])
                    req_way <= 0;
                else if (!valid[1][addr_index])
                    req_way <= 1;
                else
                    req_way <= (lru[addr_index] == 0) ? 0 : 1;
            end
            // Q9: Lorsqu'une réponse mémoire arrive, mettre à jour la voie sélectionnée.
            if (state == MISS_WAIT && mem_read_valid_i) begin
                data_mem[req_way][req_index] <= mem_read_data_i;
                tag_mem[req_way][req_index]  <= req_tag;
                valid[req_way][req_index]    <= 1'b1;
                // Q15: Mettre à jour le LRU : la voie remplie devient MRU.
                if (req_way == 0)
                    lru[req_index] <= 1;  // voie 0 utilisée → voie 1 devient LRU
                else
                    lru[req_index] <= 0;  // voie 1 utilisée → voie 0 devient LRU
            end
            // Q15: En cas de hit, mettre à jour le LRU.
            if (state == IDLE && read_en_i && hit) begin
                if (hit_way0)
                    lru[addr_index] <= 1; // accès voie 0 → voie 1 devient LRU
                else if (hit_way1)
                    lru[addr_index] <= 0; // accès voie 1 → voie 0 devient LRU
            end
        end
    end

    // Q6, Q8, Q13: Logique de réponse au processeur.
    // Si hit, renvoyer le mot provenant de la voie concernée.
    // Sinon, dès que la mémoire renvoie sa réponse, transmettre le mot extrait.
    always_comb begin
        if (state == IDLE) begin
            if (read_en_i && hit) begin
                read_valid_o = 1'b1;
                if (hit_way0)
                    read_word_o = data_mem[0][addr_index][32*word_index +: 32];
                else if (hit_way1)
                    read_word_o = data_mem[1][addr_index][32*word_index +: 32];
                else
                    read_word_o = 32'b0;
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
