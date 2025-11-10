# Welcome to my kOS github. 

This is a collection of scripts intended to be used in the game Kerbal Space Program.
Big kudos goes to CheersKevin for his kOS guides. Some sections of my scripts are inspired/adapted from his tutorials.

# Programs:

-Kerbal Launch System Ascent Guidance, Equatorial Orbits (Basic Functionality completed)\
-Kerbal Launch System Ascent Guidance, Polar Orbits (Basic Functionality completed)\
-Vacuum Delivery System (WIP)

------------------------
## KERBAL LAUNCH SYSTEM:
This script is designed specifically for the Kerbal Launch System medium and heavy lift variants. The Kerbal Launch System is designed to put any payload into any orbit. From low Kerbin orbit to Plock, the Kerbal Launch System will take you there. The ascent guidance script safely and autonomously takes your spacecraft into LKO at approximately 100,000 km, with plenty of fuel to spare for any further orbital manuevers you require.\
Current State:\
-KLS and KLS Heavy will autonomously put your payload into LKO at approximately 100,000 km. It will automatically stage, maintain attitude control during ascent, and deploy fairings once safely above the atmosphere.\
Planned Features:\
-I would like to create more scripts to allow the user to specify what altitude they want the final orbit to reach, potentially rolling them all into one. Idk if kOS can even collect input though.\
-The ascent system works pretty well, but it isn't super elegant. I am toying around with using orbital eccentricity to optimize ascents. The program would use a hill climbing algorithm, inspired by CheersKevin's tutorials.

------------------------
## VACUUM DELIVERY SYSTEM:
**Work in Progress**\
This is a kOS script designed for the Vacuum Delivery System (VDS) (Patent pending), allowing you to insert a ground exploration rover on any body (planned) in the Kerbol system.\
It utilizes a custom PID controller (WIP) which stabilizes the VDS along the x, y, and z axes, providing a controlled descent down to the surface.\

Current State:\
-Optimized for bodies without an atmosphere, controlled descent through an atmosphere is planned but likely won't be implemented for awhile.\
-Deorbit and controlled descent burns work well, but the hover PID requires some tuning. I am working on overhauling it so it can be much more general.

Planned Features:\
-Better control over landing site, specifically to avoid hazardous landing sites such as severe slopes or other environmental hazards.\
-The user can input coordinates and the craft will land there! (This is a far future planned feature)
