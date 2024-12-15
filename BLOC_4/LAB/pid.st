VAR_INPUT
    // PID 1
    SetpointY1 : REAL;       
    Yp1 : REAL; 
    Kp1 : REAL;             
    Ti1 : REAL;             
    Td1 : REAL;
    // PID 2
    SetpointY2 : REAL;
    Yp2 : REAL;
    Kp2 : REAL;
    Ti2 : REAL;
    Td2 : REAL;             
    T : REAL;             
END_VAR

VAR_OUTPUT
    Up1 : REAL;
    Up2 : REAL;
END_VAR

VAR
    // PID 1
    Error1 : REAL;         
    PrevError1 : REAL;     
    IntegralSum1 : REAL;       
    Derivative1 : REAL;
    // PID 2
    Error2 : REAL;
    PrevError2 : REAL;
    IntegralSum2 : REAL;
    Derivative2 : REAL;     
END_VAR

(* PID Algorithm *)
Error1 := SetpointY1 - Yp1;
Error2 := SetpointY2 - Yp2;

(* Proportional term *)
Up1 := Kp1 * Error1;
Up2 := Kp2 * Error2;

(* Integral term *)
IntegralSum1 := IntegralSum1 + Kp1 * T * (Error1 + PrevError1) / (2 * Ti1);
Up1 := Up1 + IntegralSum1;
IntegralSum2 := IntegralSum2 + Kp2 * T * (Error2 + PrevError2) / (2 * Ti2);
Up2 := Up2 + IntegralSum2;

(* Derivative term *)
Derivative1 := Kp1 * Td1 * (Error1 - PrevError1) / T;
Up1 := Up1 + Derivative1;
Derivative2 := Kp2 * Td2 * (Error2 - PrevError2) / T;
Up2 := Up2 + Derivative2; 

(* Save current error for next cycle *)
PrevError1 := Error1;
PrevError2 := Error2;
