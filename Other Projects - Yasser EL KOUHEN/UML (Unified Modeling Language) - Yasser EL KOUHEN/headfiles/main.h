#ifndef MAIN_H
#define MAIN_H

// Inclusion des fichiers nécessaires
#include "Utilisateur.h"
#include "Seance.h"
#include "Exercice.h"
#include "Capteur.h"
#include "Paiement.h"
#include "Abonnement.h"
#include "CoachVirtuel.h"
#include "RapportPerformance.h"
#include "Notification.h"
#include "BaseDeDonnees.h"

// Inclusion des bibliothèques standards
#include <iostream>
#include <vector>
#include <memory> // Pour la gestion de la mémoire dynamique

using namespace std;

// Déclaration de fonctions utilitaires
void afficherMenu();
void gestionUtilisateur(Utilisateur& utilisateur);
void gestionSeance(Utilisateur& utilisateur);
void gestionPaiement(Utilisateur& utilisateur);
void gestionNotifications(Utilisateur& utilisateur);

#endif
