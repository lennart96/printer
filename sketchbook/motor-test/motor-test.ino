#include <Motor.h>

Motor motor(8, 9, 10, 11);

void setup() {
    Serial.begin(9600);
    while(!Serial);
}

void loop() {
    if (Serial.available()) {
        int steps = Serial.parseInt();
        motor.rotateSteps(steps);
        Serial.write("Done\n");
    }
}

