#include "Arduino.h"
#include "Printer.h"
#include <Motor.h>
#include <Switch.h>

void Printer::setMotor(enum motor, int p1, int p2, int p3) {
    Motor motor = Motor(p1, p2, p3, p4);
    switch (motor) {
        case X:
            m_x = motor;
            return;
        case Y1:
            m_y1 = motor;
            return;
        case Y2:
            m_y2 = motor;
            return;
        case Z:
            m_z; = motor
            return;
    }
}

void Printer::setSwitch(int p) {
    m_head = Switch(p);
}
