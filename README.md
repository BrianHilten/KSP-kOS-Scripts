# Welcome to my kOS github. 

This is a collection of scripts intended to be used in the game Kerbal Space Program.
Big kudos goes to CheersKevin for his kOS guides. Some sections of my scripts are inspired/adapted from his tutorials.

# Programs:

-Kerbal Launch System Ascent Guidance, Equatorial Orbits (Basic Functionality Completed)\
-Kerbal Launch System Ascent Guidance, Polar Orbits (Basic Functionality Completed)\
-Reusable Kerbal Launch System (Basic Deorbit Functionality Completed. Landing feature WIP pending completion of EZ-LAND PID Controller Software)\
-EZ-Hover PID Controller & Companion EZ-Tuning Software (MATLAB required for tuning software, I will hopefully port this to Python someday so anyone can use it for free)\
-EZ-Land 2D PID Controller & Companion EZ-Tuning Software (MATLAB required for tuning software, I will hopefully port this to Python someday so anyone can use it for free)\
-Vacuum Delivery System (WIP)

------------------------
## KERBAL LAUNCH SYSTEM:
This script is designed specifically for the Kerbal Launch System medium and heavy lift variants. The Kerbal Launch System is designed to put any payload into any orbit. From low Kerbin orbit to Plock, the Kerbal Launch System will take you there. The ascent guidance script safely and autonomously takes your spacecraft into LKO at approximately 100,000 km, with plenty of fuel to spare for any further orbital manuevers you require.\
Current State:\
-KLS and KLS Heavy will autonomously put your payload into LKO at approximately 100,000 km. It will automatically stage, maintain attitude control during ascent, and deploy fairings once safely above the atmosphere.\
Planned Features:\
-I would like to create more scripts to allow the user to specify what altitude they want the final orbit to reach, potentially rolling them all into one. Idk if kOS can even collect input though.\
-The ascent system works pretty well, but it isn't super elegant. I am toying around with using orbital eccentricity to optimize ascents. The program would use a hill climbing algorithm, inspired by CheersKevin's tutorials.\
-Reusable Kerbal Launch System! Are you on a budget? The reusable KLS variant will put your payload into a ~100km x 100km orbit, automatically detach, then return back to the Kerbal Space Center for retrieval, refurbishment, and reuse. Status: Basic rocket design and deorbit methodology complete, program implementation is WIP. Largest obstacles include landing PID control system for such a large booster, and calculating proper trajectories. I would like to not use any external mods (Trajectories) and do the calculations myself, but calculating impact positions is no joke, expecially in atmosphere, and I'm not that great at math...

------------------------
## EZ-HOVER PID CONTROLLER AND EZ-TUNING COMPANION SOFTWARE (PATENT TOTALLY PENDING):
Status: Completed\
-This kOS script implements a basic nested PID controller to allow for a craft beginning at a higher altitude to safely descend and hover at a specified altitude (or descend safely to the ground). You will need to adjust the gain values yourself to fit your spacecraft!!! I highly suggest using the companion MATLAB script which simulates the physics (to include drag if on Kerbin. You could modify the density function to fit your needs on another planet) of a body in 1D freefall. The script allows you to input your spacecraft's characteristics (mass, max thrust, ISP, etc.), and your desired initial conditions and target state and see how your controller reacts in a given scenario! With this, you can rapidly tune your controller without the need to waste time setting up and running experiments in game.\

------------------------
## EZ-LAND 2D PID CONTROLLER AND EZ-TUNING COMPANION SOFTWARE (PATENT DEFINITELY PENDING):
Status: **Work in Progress**\
-This kOS script is an extension of my 1D EZ-HOVER PID Controller, but this is meant to take a spacecraft all the way from orbit to the ground, safe and sound. The basic design centers around three separate PID controllers, two of which are nested to control vertical velocity during descent, outputting the appropriate throttle value, with the other controller designated to control the pitch of the craft during descent to appropriately decrease our horizontal velocity. I am currently in the process of modeling the physics behind this scenario in MATLAB before I fully implement it into kOS for use in game.\

------------------------
## VACUUM DELIVERY SYSTEM:
Status: **Work in Progress**\
This is a kOS script designed for the Vacuum Delivery System (VDS) (Patent pending), allowing you to insert a ground exploration rover on any body (planned) in the Kerbol system.\
It utilizes a custom PID controller (WIP) which stabilizes the VDS along the x, y, and z axes, providing a controlled descent down to the surface.\

Current State:\
-Optimized for bodies without an atmosphere, controlled descent through an atmosphere is planned but likely won't be implemented for awhile.\
-Deorbit and controlled descent burns work well, but the hover PID requires some tuning. I am working on overhauling it so it can be much more general.

Planned Features:\
-Better control over landing site, specifically to avoid hazardous landing sites such as severe slopes or other environmental hazards.\
-The user can input coordinates and the craft will land there! (This is a far future planned feature)
