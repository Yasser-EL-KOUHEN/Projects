#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <string>

enum TypeNotification { RAPPEL_SEANCE, RENOUVELLEMENT_ABONNEMENT };

class Notification {
private:
    TypeNotification type;
    std::string message;
    std::string dateEnvoi;

public:
    Notification(TypeNotification type, std::string message, std::string dateEnvoi);
    void envoyerNotification();
};

#endif
