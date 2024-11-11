//Lab 1, task 3, ex. 7

// São lançados dois objetivos "simultâneamente".
// Dessa forma, dois planos serão executados em paralelo.
// Obviamente, o paralelismo vai depender do sistema subjacente (do agente, do ambiente, etc.)
// No caso do sistema atual, terão dois objetivos conflitantes executando em paralelo:
// O sistema tem temperatura inicial igual a 30; um objetivo vai gerar planos para tentar abaixar
// a temperatura até chegar em 20, enquanto o outro objetivo vai tentar aumentar até chegar em 35.
// Isso vai fazer com que a temperatura nunca chegue nem em 20, nem em 35, pois enquanto um aumenta, 
// o outro diminui.

!keep_temperature(20).
!keep_temperature(35).


+!keep_temperature(P)
   :  temperature(C) & C > P
   <- startCooling; !wait_until(P); !keep_temperature(P).
+!keep_temperature(P)
   :  temperature(C) & C < P
   <- startHeating; !wait_until(P); !keep_temperature(P).
+!keep_temperature(P)
   <- !keep_temperature(P).

+!wait_until(T) : temperature(T) <- stopAirConditioner.
+!wait_until(T) <- !wait_until(T).


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
