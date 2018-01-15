//
//  Touchpad.h
//  GlassCon
//
//  Created by Ricky Ayoub on 1/14/18.
//

#ifndef Touchpad_h
#define Touchpad_h

#include "MultitouchSupport.h"

// from Glassview.swift
void clearFingers(void);
void addFinger(float, float, float);

void startTouchListener();
int print_data(int device, Finger *data, int nFingers, double timestamp, int frame);

#endif /* Touchpad_h */
