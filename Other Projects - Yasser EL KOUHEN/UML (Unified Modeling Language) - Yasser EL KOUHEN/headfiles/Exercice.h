#ifndef EXERCICE_H
#define EXERCICE_H

#include <string>

enum TypeExercice { CARDIO, MUSCULATION, FLEXIBILITE };

class Exercice {
private:
    std::string nom;
    TypeExercice type;

public:
    Exercice(std::string nom, TypeExercice type);
    std::string getInstructions() const;
};

#endif
