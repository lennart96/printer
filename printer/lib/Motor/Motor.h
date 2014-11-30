/*
  Motor.h - Library to control 28BYJ-48 Stepper Motor
  using ULN2003 driver board.
*/

#ifndef Motor_h
#define Motor_h

#include "Arduino.h"

class Motor {
public:
            Motor(int pin1, int pin2, int pin3, int pin4);

    void    rotateRadians(float radians);
    void    rotateSteps(int steps);
    void    rotateDegrees(int degrees);
    void    rotateRevolutions(float part);

    int     totalSteps();
    float   totalRevolutions();

    int     currentSteps();
    int     currentDegrees();
    float   currentRadians();
    float   currentPart();

    void    reset();

private:
    int     _totalSteps;

    int     _p1;
    int     _p2;
    int     _p3;
    int     _p4;

    void    write(int p1, int p2, int p3, int p4);

    void    stepCw();
    void    stepCcw();
};

#endif
