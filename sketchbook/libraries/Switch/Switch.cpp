#include "Arduino.h"
#include <Servo.h>
#include "Switch.h"

Switch::Switch(int pin) {
    _servo.attach(pin);
}

void Switch::on() {
    _servo.write(180);
}

void Switch::off() {
    _servo.write(0);
}

bool Switch::state() {
    return _servo.read() > 90;
}

void Switch::set(bool state) {
    if (state)
        on();
    else
        off();
}
