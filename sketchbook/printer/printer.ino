#include <Motor.h>

Motor motorX(8, 9, 10, 11);
Motor motorY(8, 9, 10, 11);
Motor motorZ(2, 3, 4, 5);

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
            case 'P':
                Serial.write("ACK\n");
                break;
            case 'X':
                cmdMotor(motorX);
                break;
            case 'Y':
                cmdMotor(motorY);
                break;
            case 'Z':
                cmdMotor(motorZ);
                break;
            case '+':
            case '-':
                Serial.write("WRN Not implemented\n");
                break;
            default:
                Serial.write("ERR Unknown command ");
                Serial.write(axis);
                Serial.write('\n');
        }
    }
}

