#include "Arduino.h"
#include "Motor.h"

Motor::Motor(int pin1, int pin2, int pin3, int pin4) {
    _totalSteps = 0;
    _p1 = pin1; pinMode(pin1, OUTPUT);
    _p2 = pin2; pinMode(pin2, OUTPUT);
    _p3 = pin3; pinMode(pin3, OUTPUT);
    _p4 = pin4; pinMode(pin4, OUTPUT);
}

void Motor::rotateSteps(int n) {
    _totalSteps += n;
    if      (n > 0)  for (int i=0; i< n; i++)  stepCw();
    else if (n < 0)  for (int i=0; i<-n; i++)  stepCcw();
}

void Motor::stepCw() {
    int A  =  HIGH; int _  =   LOW;
    write(_,_,_,A); write(_,_,A,A);
    write(_,_,A,_); write(_,A,A,_);
    write(_,A,_,_); write(A,A,_,_);
    write(A,_,_,_); write(A,_,_,A);
}

void Motor::stepCcw() {
    int A  =  HIGH; int _  =   LOW;
    write(A,_,_,_); write(A,A,_,_);
    write(_,A,_,_); write(_,A,A,_);
    write(_,_,A,_); write(_,_,A,A);
    write(_,_,_,A); write(A,_,_,A);
}

void Motor::write(int m1, int m2, int m3, int m4) {
    digitalWrite(_p1, m1);
    digitalWrite(_p2, m2);
    digitalWrite(_p3, m3);
    digitalWrite(_p4, m4);
    delay(1);
}

int   Motor::totalSteps() {
     return _totalSteps;
}
 
int   Motor::currentSteps() {
     return totalSteps() % 512;
}
 
float Motor::totalRevolutions() {
     return totalSteps() / 512.0;
}
 
float Motor::currentPart() {
     return currentSteps() / 512.0;
}
 
int   Motor::currentDegrees() {
     return round(currentPart() * 360.0);
}
 
float Motor::currentRadians() {
     return round(currentPart() * TWO_PI );
}

void  Motor::rotateRevolutions(float part) {
     rotateSteps(round(part * 512));
}
 
void  Motor::rotateRadians(float radians) {
     rotateRevolutions(radians / TWO_PI);
}
 
void  Motor::rotateDegrees(int degrees) {
     rotateRevolutions(degrees / 360.0);
}
