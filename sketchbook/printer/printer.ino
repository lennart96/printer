#include <Motor.h>

Motor motorX(2, 3, 4, 5);
Motor motorY(6, 7, 8, 9);
Motor motorZ(12, 12, 12, 12);

void setup() {
    Serial.begin(9600);
    while(!Serial);
}

void cmdMotor(Motor & motor) {
    motor.rotateSteps(Serial.parseInt());
    Serial.write("OK.\n");
}

void loop() {
    if (Serial.available()) {
        char axis = Serial.read();
        switch (axis) {
            case '\r':
            case '\n':
                break;
            case 'p':
                Serial.write("ack\n");
                break;
            case 'x':
                cmdMotor(motorX);
                break;
            case 'y':
                cmdMotor(motorY);
                break;
            case 'z':
                cmdMotor(motorZ);
                break;
            case '+':
            case '-':
                Serial.write("err not implemented\n");
                break;
            default:
                Serial.write("err unknown command ");
                Serial.write(axis);
                Serial.write('\n');
        }
    }
}

