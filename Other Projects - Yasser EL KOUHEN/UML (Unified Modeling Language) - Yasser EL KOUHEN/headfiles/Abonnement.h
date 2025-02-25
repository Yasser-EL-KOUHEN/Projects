#ifndef ABONNEMENT_H
#define ABONNEMENT_H

#include "Paiement.h"

enum TypeAbonnement { MENSUEL, ANNUEL };

class Abonnement {
private:
    TypeAbonnement type;
    std::string dateExpiration;
    Paiement paiement;

public:
    Abonnement(TypeAbonnement type, std::string dateExpiration, Paiement paiement);
    void renouveler();
};

#endif
