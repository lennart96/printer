#include "Arduino.h"
#include "Printer.h"
#include <Motor.h>
#include <Switch.h>

void reset() {
    // todo: implement resetting motor, if possible
    off();
}

void moveNorth() {
    m_x.rotateSteps(_steps_x);
}

void moveSouth() {
    m_x.rotateSteps(-_steps_x);
}

void moveEast() {
    for (int i = 0; i < _steps_y) {
        m_y1.rotateSteps(1);
        m_y2.rotateSteps(1);
    }
}

void moveWest() {
    for (int i = 0; i < _steps_y) {
        m_y1.rotateSteps(-1);
        m_y2.rotateSteps(-1);
    }
}

void on() {
    m_head.on();
}

void off() {
    m_head.off();
}

void moveUp() {
    m_z.rotateSteps(_steps_z);
}

void moveDown() {
    m_z.rotateSteps(-_steps_z);
}

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
