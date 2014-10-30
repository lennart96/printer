#include "Arduino.h"
#include <Servo.h>
#include "Switch.h"

Switch::Switch(int pin) {
    _servo.attach(pin);
}

Switch::on() {
    _servo.write(180);
}

Switch::off() {
    _servo.write(0);
}

Switch::state() {
    return _servo.read() > 90;
}

Switch::set(bool state) {
    if (state)
        on();
    else
        off();
}
