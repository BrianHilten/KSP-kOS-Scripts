**Work in Progress**
This is a kOS script designed for the Vacuum Delivery System (VDS) (Patent pending), allowing you to insert a ground exploration rover on any body (planned) in the Kerbol system. 
It utilizes a custom PID controller (WIP) which stabilizes the VDS along the x, y, and z axes, providing a controlled descent down to the surface.

Current State:
-Optimized for bodies without an atmosphere, controlled descent through an atmosphere is planned but likely won't be implemented for awhile. 
-Deorbit and controlled descent burns work well, but the hover PID requires some tuning. I am working on overhauling it so it can be much more general.

Planned Features:
-Better control over landing site, specifically to avoid hazardous landing sites such as severe slopes or other environmental hazards.
-The user can input coordinates and the craft will land there! (This is a far future planned feature)
