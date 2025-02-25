#ifndef CAPTEUR_H
#define CAPTEUR_H

#include <string>
#include <vector>

class Capteur {
protected:
    std::string id;
    bool statut;

public:
    void activer();
    void desactiver();
};

class BluetoothCapteur : public Capteur {
private:
    std::vector<std::string> appareilsApparies;

public:
    void pairerAppareil();
};

class WifiCapteur : public Capteur {
private:
    std::string ssid;

public:
    void connecterReseau();
};

#endif
