#include "Arduino.h"
#include "Printer.h"
#include <Motor.h>
#include <Switch.h>

Printer::Printer(int steps);
Printer::Printer(int xysteps, int zsteps);
Printer::Printer(int xsteps, int ysteps, int zsteps);

void Printer::reset() {
    // todo: implement resetting motor, if possible
    off();
}

void Printer::moveNorth() {
    m_x.rotateSteps(_steps_x);
}

void Printer::moveSouth() {
    m_x.rotateSteps(-_steps_x);
}

void Printer::moveEast() {
    for (int i = 0; i < _steps_y) {
        m_y1.rotateSteps(1);
        m_y2.rotateSteps(1);
    }
}

void Printer::moveWest() {
    for (int i = 0; i < _steps_y) {
        m_y1.rotateSteps(-1);
        m_y2.rotateSteps(-1);
    }
}

void Printer::on() {
    m_head.on();
}

void Printer::off() {
    m_head.off();
}

void Printer::moveUp() {
    m_z.rotateSteps(_steps_z);
}

void Printer::moveDown() {
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
