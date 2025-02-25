#ifndef UTILISATEUR_H
#define UTILISATEUR_H

#include <string>
#include <vector>
#include "Capteur.h"
#include "Seance.h"
#include "Abonnement.h"

class Utilisateur {
private:
    std::string nom;
    std::string prenom;
    int age;
    bool shareData;
    std::vector<std::string> historiqueSeances;

public:
    Utilisateur(std::string nom, std::string prenom, int age);
    
    void creerCompte();
    bool getShareData() const;
    void rechercherCapteur();
    void selectionnerCapteur(Capteur& capteur);
    void confirmerAppairage(Capteur& capteur);
    void choisirAbonnement(TypeAbonnement type);
    Seance creerSeance();
    void ajouterExercice(Exercice& exercice);
};

#endif
