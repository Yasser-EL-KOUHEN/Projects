#ifndef SEANCE_H
#define SEANCE_H

#include <vector>
#include "Exercice.h"

class Seance {
private:
    std::vector<Exercice> exercices;

public:
    void demarrer();
    void ajouterExercice(const Exercice& exercice);
    void sauvegarderSeance();
};

#endif
