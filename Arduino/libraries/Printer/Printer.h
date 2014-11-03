#ifndef Printer_h
#define Printer_h

#include "Arduino.h"
#include <Motor.h>

enum motor {
    X, Y1, Y2, Z;
};

class Printer {
public:
            Printer();
    void    reset();
    void    setMotor(enum motor, int p1, int p2, int p3);
    void    moveNorth();
    void    moveSouth();
    void    moveEast();
    void    moveWest();
private:
    Motor   m_x;
    Motor   m_y1;
    Motor   m_y2;
    Motor   m_z;
};

#endif
