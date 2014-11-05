#ifndef Printer_h
#define Printer_h

#include "Arduino.h"
#include <Motor.h>

enum motor {
    X, Y1, Y2, Z;
};

class Printer {
public:
            Printer(int steps);
            Printer(int xysteps, int zsteps);
            Printer(int xsteps, int ysteps, int zsteps);
    void    reset();
    void    setMotor(enum motor, int p1, int p2, int p3);
    void    setSwitch(int p);
    void    moveNorth();
    void    moveSouth();
    void    moveEast();
    void    moveWest();
    void    on();
    void    off();
    void    moveUp();
    void    moveDown();
private:
    int     _steps_x;
    int     _steps_y;
    int     _steps_z;
    Motor   m_x;
    Motor   m_y1;
    Motor   m_y2;
    Motor   m_z;
    Switch  m_head;
};

#endif
