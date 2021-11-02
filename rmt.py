#!/usr/bin/python
from evdev import InputDevice, categorize, ecodes
from subprocess import call

def volup():
    call('amixer -q set Digital 1+', shell=True)
def voldown():
    call('amixer -q set Digital 1-', shell=True)

rmt = InputDevice('/dev/input/by-id/usb-MIC_MIC_Device-if02-event-kbd')
for event in rmt.read_loop():
    if event.value==1 or event.value==2:
        if event.code == 2:
            volup()
        elif event.code == 3:
            voldown()
