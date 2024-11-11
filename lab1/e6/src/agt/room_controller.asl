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

// Foi colocado um ".wait" na condição base de "wait_until".
// Acredito que a razão para isso seja para que o agente
// não fique exageradamente percebendo a temperatura.
// Dentro do Wait poderia ter um códgio que coloque o 
// agente em modo de baixo consumo, por exemplo.
// Porém, o programa vai ficar eternamente diminuindo a temperatura.
// A razão disso é pq o programa fica preso por 3 segundos
// dentro do "wait". Durante esse tempo a temperatura vai
// continuar abaixando até ficar menor que a temperatura desejada: T = 20.
// Quando a temperatura ficar menor que 20, ela vai continuar
// diminuindo indefinidamente, pois a condição do primeiro plano 
// nunca será satisfeita, deixando o agente preso no segundo plano. 
// A solução é ...
// 
+!wait_until(T) : temperature(T) <- stopAirConditioner.
+!wait_until(T) 
    <- .wait(3000); // wait 3 seconds
       !wait_until(T).

+state("cooling") <- println("so cool").
+state("heating") <- println("so hot").

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
