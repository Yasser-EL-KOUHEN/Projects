#include "pse.h"

#define CMD "client"

int main(int argc, char *argv[]) {
    int sock, ret;
    struct sockaddr_in adrServ;
    int fin = 0;
    char ligne[LIGNE_MAX];
    char buffer[LIGNE_MAX];

    if (argc != 3)
        erreur("usage: %s machine port\n", argv[0]);

    printf("%s: creating a socket\n", CMD);
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0)
        erreur_IO("socket");

    printf("%s: DNS resolving for %s, port %s\n", CMD, argv[1], argv[2]);
    adrServ = *resolv(argv[1], argv[2]);
    if (adrServ.sin_addr.s_addr == 0)
        erreur("adresse %s port %s inconnus\n", argv[1], argv[2]);

    printf("%s: adr %s, port %hu\n", CMD,
           stringIP(ntohl(adrServ.sin_addr.s_addr)),
           ntohs(adrServ.sin_port));

    printf("%s: connecting the socket\n", CMD);
    ret = connect(sock, (struct sockaddr *)&adrServ, sizeof(adrServ));
    if (ret < 0)
        erreur_IO("connect");

    while (!fin) {
        // Recevoir la grille du serveur
        ret = recv(sock, buffer, LIGNE_MAX, 0);
        if (ret < 0) {
            erreur_IO("recv");
        }
        buffer[ret] = '\0';
        printf("Grille reçue:\n%s\n", buffer);

        // Vérifier si c'est le tour du joueur
        if (strstr(buffer, "Tour du joueur 1") && strcmp(CMD, "client1") == 0) {
            printf("C'est votre tour (joueur 1).\n");
        } else if (strstr(buffer, "Tour du joueur 2") && strcmp(CMD, "client2") == 0) {
            printf("C'est votre tour (joueur 2).\n");
        } else {
            continue;
        }

        // Demander un mouvement au joueur
        printf("ligne> ");
        if (fgets(ligne, LIGNE_MAX, stdin) == NULL)
            erreur("saisie fin de fichier\n");

        ret = ecrireLigne(sock, ligne);
        if (ret == -1)
            erreur_IO("ecrire ligne");

        printf("%s: %d bytes sent\n", CMD, ret);

        if (strcmp(ligne, "fin\n") == 0)
            fin = 1;
    }

    if (close(sock) == -1)
        erreur_IO("close socket");

    exit(EXIT_SUCCESS);
}
