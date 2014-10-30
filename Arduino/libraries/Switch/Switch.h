#ifndef Switch_h
#define Switch_h

#include "Arduino.h"
#include <Servo.h>

class Switch {
public:
            Switch(int pin);
    void    on();
    void    off();
    bool    state();
    void    set(bool state);
private:
    Servo   _servo;
}

#endif
