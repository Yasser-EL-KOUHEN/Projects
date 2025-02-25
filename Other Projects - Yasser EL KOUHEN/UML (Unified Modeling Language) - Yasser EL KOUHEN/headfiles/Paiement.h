#ifndef PAIEMENT_H
#define PAIEMENT_H

#include <string>

enum TypePaiement { CARTE_CREDIT, PAYPAL, CRYPTO };
enum StatutPaiement { SUCCES, ECHEC, EN_COURS };

class Paiement {
private:
    float montant;
    std::string date;
    StatutPaiement statut;

public:
    Paiement(float montant, std::string date, StatutPaiement statut);
    bool processPaiement();
    void initierPaiement();
    void confirmerPaiement();
};

#endif
