.section .start
.globl _start

_start:
    li t0, 0x8       # (x5) Charger l'opérande 1 (multiplicande) dans t0
    li t1, 0x7       # (x6) Charger l'opérande 2 (multiplicateur) dans t1
    li t2, 16        # (x7) Initialisation du compteur de boucle à 16 (multiplication sur 16 bits)
    li t3, 0         # (x28) Initialisation de l'accumulateur du résultat
    nop

loop:
    andi t4, t1, 1   # Tester le bit de poids faible de t1
    nop
    nop
    nop
    beqz t4, skip    # Si LSB == 0, ne pas additionner t0 à t3
    nop
    nop
    add t3, t3, t0   # Additionner t0 à l'accumulateur si LSB == 1

skip:
    slli t0, t0, 1   # Décalage à gauche du multiplicande (t0 <<= 1)
    srli t1, t1, 1   # Décalage à droite du multiplicateur (t1 >>= 1)
    addi t2, t2, -1  # Décrémenter le compteur
    nop
    nop
    nop
    bnez t2, loop    # Répéter jusqu'à ce que t2 atteigne 0

lab1:
    j lab1          # Boucle infinie pour arrêter l'exécution
    nop

.end start
