# Learning dynamical syystems
Control laboratories by using DC servomotor with inertial load, DC servomotor with resonant load, balancing robot.
For each one of the following activity, the performance of the different control methods are validated before in the Simulink platform and later on the real system in the laboratory.
## Lab 0: Position PID–control of a DC servomotor
The model of the DC servomotor with inertial load is derived and the position control system for the DC servomotor based on a standard PID controller is designed. Specifically, the design is carried out in the frequency domain (i.e Bode’s method). By doing so, some unknown values of the motor parameters, including the static and viscous friction, are assumed to be known. In the last part of the laboratory they are estimated and they will used in the next activities.\
[CLAB_ASSIGNMENT_0.pdf](https://github.com/Gioo96/Control_laboratory/files/10153065/CLAB_ASSIGNMENT_0.pdf)
## Lab 1: Position state–space control of a DC servomotor
First, some improvements to the position PID–control system designed in LAB 0. are introduced. Specifically, in order to reduce the large overshoot  occurring in the step response when the controller output saturates and to enhance both the accuracy and speed of response of the conventional feedback controller, the implementation of an anti–windup scheme and a friction plus inertia feedforward compensator are addressed. The second part of the LAB is devoted to the design of a continuous–time position control system by using state–space techniques. Both nominal and robust tracking designs are considered.\
[CLAB_ASSIGNMENT_1.pdf](https://github.com/Gioo96/Control_laboratory/files/10153084/CLAB_ASSIGNMENT_1.pdf)
## Lab 2: Digital position control of a DC servomotor 
A digital position controller for the DC servomotor available in the laboratory is designed. Two different design approaches are considered: in the design by emulation, the digital controller is obtained by discretization of a controller that was originally designed in the continuous–time domain; viceversa, in the direct digital design (or discrete design), the control design is performed directly in the discrete–time domain, using a discrete–time model of the plant to be controlled.\
[CLAB_ASSIGNMENT_2.pdf](https://github.com/Gioo96/Control_laboratory/files/10153105/CLAB_ASSIGNMENT_2.pdf)
## Lab 3: Position control of a DC servomotor with resonant load
The Simulink model of the DC gearmotor with resonant load is designed. Both the PID and state–space control techniques are taken into account for the design. The state–space design is performed with either conventional eigenvalues placement methods, or by using optimal techniques based on the Linear Quadratic Regulator (LQR).\
[CLAB_ASSIGNMENT_3.pdf](https://github.com/Gioo96/Control_laboratory/files/10153147/CLAB_ASSIGNMENT_3.pdf)
## Lab 4: Longitudinal state–space control of the balancing robot
A mathematical model for the longitudinal dynamics of the balancing robot is derived, under the simplifying assumption that the robot moves along a  straight line, namely no lateral motion occurs. The balance and position control of the balancing robot is performed by resorting to conventional state-space methods. In particular: 
1. Both the balance and position controllers are designed in the discrete–time domain, after discretizing the plant dynamics with the exact discretization    method (direct digital design). 
2. The nominal or robust tracking of constant longitudinal position set–points are achieved with the state–space control schemes.
3. The state feedback matrix (state feedback controller gain) of the balance/position state–space controller are designed with the Linear Quadratic (LQ)      optimal design techniques.\
[CLAB_ASSIGNMENT_4.pdf](https://github.com/Gioo96/Control_laboratory/files/10153131/CLAB_ASSIGNMENT_4.pdf)
