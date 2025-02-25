#ifndef BASEDEDONNEES_H
#define BASEDEDONNEES_H

#include <vector>
#include "Utilisateur.h"
#include "Seance.h"
#include "Paiement.h"
#include "Abonnement.h"

class BaseDeDonnees {
private:
    std::vector<Utilisateur> utilisateurs;
    std::vector<Seance> seances;
    std::vector<Paiement> paiements;
    std::vector<Abonnement> abonnements;

public:
    void sauvegarderDonnees();
    void chargerDonnees();
    bool verifierPaiement();
};

#endif
