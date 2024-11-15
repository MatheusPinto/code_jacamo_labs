// Task 3: Improve the implementation

// Exercise 5

preference(20). 

!start.

+!start <- !keep_temperature.

+!keep_temperature
   :  preference(P) & temperature(C) & C > P
   <- startCooling; !wait_until(P); !keep_temperature.
+!keep_temperature
   :  preference(P) & temperature(C) & C < P
   <- startHeating; !wait_until(P); !keep_temperature.
+!keep_temperature
  <- !keep_temperature.

+!wait_until(T) : temperature(T) <- stopAirConditioner.
+!wait_until(T) <- !wait_until(T).

!show_hvac_state.

+!show_hvac_state
   : state(S) & S = "cooling"
   <- .println("so cool"); .wait(250); !show_hvac_state.
+!show_hvac_state
   : state(S) & S = "heating"
   <- .println("so hot"); .wait(250); !show_hvac_state.
+!show_hvac_state
   <- !show_hvac_state.


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
