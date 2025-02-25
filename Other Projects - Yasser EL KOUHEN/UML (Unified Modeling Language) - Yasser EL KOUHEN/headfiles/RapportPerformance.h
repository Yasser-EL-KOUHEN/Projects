#ifndef RAPPORTPERFORMANCE_H
#define RAPPORTPERFORMANCE_H

#include <string>

class RapportPerformance {
private:
    std::string date;
    float scoreCardio;
    float scoreMusculation;

public:
    RapportPerformance(std::string date, float scoreCardio, float scoreMusculation);
    std::string genererRapport() const;
};

#endif
