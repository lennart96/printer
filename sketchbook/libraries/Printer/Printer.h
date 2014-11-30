#ifndef Printer_h
#define Printer_h

#include "Arduino.h"
#include <Motor.h>
#include <Switch.h>

class Printer {
public:
            Printer(int xsteps, int ysteps, int zsteps,
                    const Motor & x,
                    const Motor & y1,
                    const Motor & y2,
                    const Motor & z,
                    const Switch & m)
                    : _steps_x(xsteps), _steps_y(ysteps), _steps_z(zsteps),
                      m_x(x), m_y1(y1), m_y2(y2), m_z(z), m_head(m) {}
    void    reset();
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
