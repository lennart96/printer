#include "Arduino.h"
#include "Printer.h"
#include <Motor.h>
#include <Switch.h>

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
    // note: this will be slow. might be better to modify Motor.{cpp, h}
    // to allow more control; delay is called twice, while only one call
    // should be enough
    for (int i = 0; i < _steps_y; i++) {
        m_y1.rotateSteps(1);
        m_y2.rotateSteps(1);
    }
}

void Printer::moveWest() {
    for (int i = 0; i < _steps_y; i++) {
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

