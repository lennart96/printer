#include <Motor.h>

int posX = 0;
int posY = 0;
int posZ = 0;

boolean configured = false;

Motor motorX(2, 3, 4, 5);
Motor motorY(6, 7, 8, 9);
Motor motorZ(10, 11, 12, 13);

void setup() {
    Serial.begin(9600);
    while(!Serial);
}

void cmdMotor(int & pos, Motor & motor) {
    int steps = Serial.parseInt();
    pos += steps;
    motor.rotateSteps(steps);
    Serial.write("OK.\n");
}

void writePos(char name, int var) {
    Serial.write("set pos.");
    Serial.write(name);
    Serial.write(' ');
    Serial.print(var);
    Serial.write('\n');
}

void loop() {
    int arg;
    if (Serial.available()) {
        char axis = Serial.read();
        switch (axis) {
            case 'r': // reset
                if (configured) {
                    motorX.rotateSteps(-posX);
                    motorY.rotateSteps(posY);
                    motorZ.rotateSteps(-posZ);
                    Serial.write("ok. done\n");
                } else {
                    Serial.write("err not configured\n");
                }
            case 'c': // config
                while (!Serial.available());
                switch (arg = Serial.read()) {
                    case '0': // set reference point
                        configured = true;
                        posX = posY = posZ = 0;
                        Serial.write("OK.\n");
                        break;
                    case '!': // unset reference point
                        configured = false;
                        break;
                    default:
                        Serial.write("err unknown config\n");
                }
                break;
            case 's': // status
                while (!Serial.available());
                switch (arg = Serial.read()) {
                    case '0': // check if reference point exists
                        if (configured)
                            Serial.write("set ref.on yes\n");
                        else
                            Serial.write("set ref.on no\n");
                        break;
                    case 'x':
                        writePos(arg, posX);
                        break;
                    case 'y':
                        writePos(arg, posY);
                        break;
                    case 'z':
                        writePos(arg, posZ);
                        break;
                    default:
                        Serial.write("err unknown status\n");
                        Serial.write(arg);
                }
                break;
            case 'p': // ping
                Serial.write("ack\n");
                break;
            case 'x': // move x
                cmdMotor(posX, motorX);
                break;
            case 'y': // move y
                cmdMotor(posY, motorY);
                break;
            case 'z': // move z
                cmdMotor(posZ, motorZ);
                break;
            case '+': // head on
            case '-': // head off
                Serial.write("err not implemented\n");
                break;
            case '\r':
            case '\n':
                break;
            default:
                Serial.write("err unknown command ");
                Serial.write(axis);
                Serial.write('\n');
        }
    }
}

