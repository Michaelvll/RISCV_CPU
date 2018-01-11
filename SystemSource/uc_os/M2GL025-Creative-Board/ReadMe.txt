BLINKY EXAMPLE FOR THE MICROSEMI IGLOO2 CREATIVE DEVELOPMENT BOARD(M2GL025)

This example project demonstrates how to create a kernel task which blinks an LED.

MICRIUM PRODUCT VERSIONS
- uC/OS-II  v2.92.13
- uC/CPU    v1.31.01
- uC/LIB    v1.38.02

IDE/COMPILER VERSIONS
- SoftConsole V5.1

HARDWARE SETUP
- Connect Micro B cable USB port

WORKSPACE LOCATIONS
- Microsemi/M2GL025-Board-Creative/Blinky/OS2/SoftConsole/

PROGRAMMING THE TARGET DEVICE
- Install FlashPro Express software contained in the Microsemi Program Debug installer.
- Connect the Target Hardware (Creative Board) to computer using USB cable.
- Start FlashPro Express software from the Start menu and under Job Projects click Open.
- Go to the folder 'Microsemi/BSP/M2GL025-Creative-Board/Programming_The_Target_Device/PROC_SUBSYSTEM_BaseDesign' 
  and select the PROC_SUBSYSTEM_BaseDesign.pro file and click Open.
- The Flash Pro window should now show the Programmer and the target M2GL025 device.
- Click the RUN button 
- On completion status bar will show green and 1 programmer passed. You can Exit FlashPro Express.  

USAGE INSTRUCTIONS
- Open the workspace in SoftConsole by File->Import and Select "Existing Project into Workspace". DONOT check "Copy projects into workspace" option.
- Compile project by clicking in Project->Build ALL.
- Download the code to the board by right-clicking inside the project directory and selecting Debug As–>Local C/C++ Application.
- The project creates a task which blinks the LEDs on board.
- Now modify the call to OSTimeDlyHMSM() in StartupTask() to increase or decrease the frequency at which the LEDs blink.
- Build and run again to see the change.


Please feel free to post questions or comments related to this example project at Micrium's forum page:

https://www.micrium.com/forums/topic/microsemi-igloo2-creative-dev-board-blinky/
