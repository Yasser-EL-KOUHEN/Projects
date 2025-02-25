#include "pse.h"

#define PORT 12345
#define NB_JOUEURS 2
#define TAILLE_GRILLE 3

typedef struct {
    int sock;
    int joueur;
} ClientInfo;

int joueurs_connectes = 0;
int fin_jeu = 0;
int tour_joueur = 1;  // Variable pour suivre le tour du joueur
char grille[TAILLE_GRILLE][TAILLE_GRILLE];
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

void *handle_client(void *arg);
void initialiser_grille();
void afficher_grille();
int verifier_gagnant();
int est_plein();
void envoyer_grille(int sock);

int main(int argc, char *argv[]) {
    int sock, client_sock, ret;
    struct sockaddr_in adrServ, adrClient;
    socklen_t lgAdrClient = sizeof(adrClient);
    pthread_t tid;
    ClientInfo clients[NB_JOUEURS];

    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    adrServ.sin_family = AF_INET;
    adrServ.sin_addr.s_addr = INADDR_ANY;
    adrServ.sin_port = htons(PORT);

    if (bind(sock, (struct sockaddr *)&adrServ, sizeof(adrServ)) < 0) {
        perror("bind");
        exit(EXIT_FAILURE);
    }

    if (listen(sock, NB_JOUEURS) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    printf("Serveur en écoute sur le port %d\n", PORT);

    for (int i = 0; i < NB_JOUEURS; i++) {
        client_sock = accept(sock, (struct sockaddr *)&adrClient, &lgAdrClient);
        if (client_sock < 0) {
            perror("accept");
            exit(EXIT_FAILURE);
        }

        printf("Joueur %d connecté\n", i + 1);
        clients[i].sock = client_sock;
        clients[i].joueur = i + 1;

        ret = pthread_create(&tid, NULL, handle_client, (void *)&clients[i]);
        if (ret != 0) {
            perror("pthread_create");
            exit(EXIT_FAILURE);
        }

        pthread_mutex_lock(&mutex);
        joueurs_connectes++;
        if (joueurs_connectes == NB_JOUEURS) {
            pthread_cond_broadcast(&cond);
        }
        pthread_mutex_unlock(&mutex);
    }

    pthread_exit(NULL);
    close(sock);
    return 0;
}

void *handle_client(void *arg) {
    ClientInfo *client = (ClientInfo *)arg;
    char ligne[LIGNE_MAX];
    int ret, fin = 0;
    int row, col;
    char symbole = (client->joueur == 1) ? 'X' : 'O';

    pthread_mutex_lock(&mutex);
    while (joueurs_connectes < NB_JOUEURS) {
        pthread_cond_wait(&cond, &mutex);
    }
    pthread_mutex_unlock(&mutex);

    if (client->joueur == 1) {
        initialiser_grille();
    }

    while (!fin_jeu) {
        envoyer_grille(client->sock);

        // Attendre que ce soit le tour du joueur
        pthread_mutex_lock(&mutex);
        while (tour_joueur != client->joueur) {
            pthread_cond_wait(&cond, &mutex);
        }
        pthread_mutex_unlock(&mutex);

        ret = recv(client->sock, ligne, LIGNE_MAX, 0);
        if (ret < 0) {
            perror("recv");
            exit(EXIT_FAILURE);
        } else if (ret == 0) {
            printf("Client déconnecté\n");
            fin_jeu = 1;
            pthread_cond_broadcast(&cond);
        } else {
            ligne[ret] = '\0';
            printf("Client %d: %s", client->joueur, ligne);

            if (strcmp(ligne, "fin\n") == 0) {
                fin_jeu++;
                if (fin_jeu == NB_JOUEURS) {
                    pthread_cond_broadcast(&cond);
                }
            } else {
                sscanf(ligne, "%d %d", &row, &col);
                pthread_mutex_lock(&mutex);
                if (grille[row][col] == ' ') {
                    grille[row][col] = symbole;
                    fin = verifier_gagnant() || est_plein();
                    // Changer de tour après un mouvement valide
                    tour_joueur = (tour_joueur == 1) ? 2 : 1;
                    pthread_cond_broadcast(&cond);
                }
                pthread_mutex_unlock(&mutex);

                if (fin) {
                    envoyer_grille(client->sock);
                    fin_jeu = NB_JOUEURS;
                    pthread_cond_broadcast(&cond);
                }
            }
        }
    }

    close(client->sock);
    return NULL;
}

void initialiser_grille() {
    for (int i = 0; i < TAILLE_GRILLE; i++) {
        for (int j = 0; j < TAILLE_GRILLE; j++) {
            grille[i][j] = ' ';
        }
    }
}

void afficher_grille() {
    for (int i = 0; i < TAILLE_GRILLE; i++) {
        for (int j = 0; j < TAILLE_GRILLE; j++) {
            printf("%c", grille[i][j]);
            if (j < TAILLE_GRILLE - 1) {
                printf("|");
            }
        }
        printf("\n");
        if (i < TAILLE_GRILLE - 1) {
            printf("-----\n");
        }
    }
}

int verifier_gagnant() {
    for (int i = 0; i < TAILLE_GRILLE; i++) {
        if (grille[i][0] == grille[i][1] && grille[i][1] == grille[i][2] && grille[i][0] != ' ') {
            return 1;
        }
        if (grille[0][i] == grille[1][i] && grille[1][i] == grille[2][i] && grille[0][i] != ' ') {
            return 1;
        }
    }
    if (grille[0][0] == grille[1][1] && grille[1][1] == grille[2][2] && grille[0][0] != ' ') {
        return 1;
    }
    if (grille[0][2] == grille[1][1] && grille[1][1] == grille[2][0] && grille[0][2] != ' ') {
        return 1;
    }
    return 0;
}

int est_plein() {
    for (int i = 0; i < TAILLE_GRILLE; i++) {
        for (int j = 0; j < TAILLE_GRILLE; j++) {
            if (grille[i][j] == ' ') {
                return 0;
            }
        }
    }
    return 1;
}

void envoyer_grille(int sock) {
    char buffer[LIGNE_MAX];
    snprintf(buffer, LIGNE_MAX, "Grille:\n");
    for (int i = 0; i < TAILLE_GRILLE; i++) {
        for (int j = 0; j < TAILLE_GRILLE; j++) {
            snprintf(buffer + strlen(buffer), LIGNE_MAX - strlen(buffer), "%c", grille[i][j]);
            if (j < TAILLE_GRILLE - 1) {
                snprintf(buffer + strlen(buffer), LIGNE_MAX - strlen(buffer), "|");
            }
        }
        snprintf(buffer + strlen(buffer), LIGNE_MAX - strlen(buffer), "\n");
        if (i < TAILLE_GRILLE - 1) {
            snprintf(buffer + strlen(buffer), LIGNE_MAX - strlen(buffer), "-----\n");
        }
    }
    snprintf(buffer + strlen(buffer), LIGNE_MAX - strlen(buffer), "Tour du joueur %d\n", tour_joueur);
    send(sock, buffer, strlen(buffer), 0);
}
