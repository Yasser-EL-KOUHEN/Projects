#ifndef COACHVIRTUEL_H
#define COACHVIRTUEL_H

#include "Utilisateur.h"
#include "RapportPerformance.h"

class CoachVirtuel {
public:
    RapportPerformance analyserPerformance(Utilisateur& utilisateur);
    std::string genererConseils(Utilisateur& utilisateur);
};

#endif
