#!/bin/bash
# A small Bash script to set up User LED3 to be turned on or off from 
#  Linux console. Written by Derek Molloy (derekmolloy.ie) for the 
#  book Exploring BeagleBone.

LED3_PATH=/sys/class/leds/beaglebone:green:usr3

# Example bash function
function removeTrigger
{
  echo "none" >> "$LED3_PATH/trigger"
}

declare -i X
echo "Starting the LED Bash Script"
if [ $# -eq 0 ]; then
  echo "There are no arguments. Usage is:"
  echo -e " bashLED Command \n  where command is one of "
  echo -e "   on, off, flash, status, or blink \n e.g. 'bashLED on' "
  echo -e "blink command takes two arguments \n e.g. 'blink 3' "
  exit 2
fi
echo "The LED Command that was passed is: $1"
if [ "$1" == "on" ]; then
  echo "Turning the LED on"
  removeTrigger
  echo "1" >> "$LED3_PATH/brightness"
elif [ "$1" == "off" ]; then
  echo "Turning the LED off"
  removeTrigger
  echo "0" >> "$LED3_PATH/brightness"
elif [ "$1" == "flash" ]; then
  echo "Flashing the LED"
  removeTrigger
  echo "timer" >> "$LED3_PATH/trigger"
  sleep 1
  echo "100" >> "$LED3_PATH/delay_off"
  echo "100" >> "$LED3_PATH/delay_on"
elif [ "$1" == "blink" ]; then
  X=$2
  echo "Blinking the LED $X times"
  removeTrigger
while [ $X -gt 0 ]
do
  echo "1" >> "$LED3_PATH/brightness"
  sleep 1
  echo "0" >> "$LED3_PATH/brightness"
  sleep 1
  X=$[$X-1]
done
elif [ "$1" == "status" ]; then
  cat "$LED3_PATH/trigger";
fi
echo "End of the LED Bash Script"
