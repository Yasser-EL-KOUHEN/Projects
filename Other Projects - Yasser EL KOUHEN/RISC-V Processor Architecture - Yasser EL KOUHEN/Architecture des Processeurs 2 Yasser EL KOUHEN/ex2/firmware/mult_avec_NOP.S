.section .start;
.globl start;
nop : add x0, x0, x0

start:
    li t0, 0x8          # Opérande 1 (multiplicateur)
    li t1, 0x7          # Opérande 2 (multiplicande)
    li t2, 16           # Compteur pour les 16 itérations
    li t3, 0            # Registre pour accumuler le résultat
    nop

.loop:
    andi t4, t1, 1      # Vérifier si le bit LSB de t1 est 1
    nop
    nop
    nop
    beq t4, zero, .skip_add  # Sauter l'addition si le bit LSB est 0
    nop
    nop
    add t3, t3, t0       # Ajouter t0 à t3 si LSB est 1

.skip_add:
    slli t0, t0, 1      # Décaler t0 à gauche
    srli t1, t1, 1      # Décaler t1 à droite
    addi t2, t2, -1     # Décrémenter le compteur
    bne t2, zero, .loop # Boucler jusqu'à 16 itérations
    nop
    nop
lab1 :  j  lab1
	nop

.end start

