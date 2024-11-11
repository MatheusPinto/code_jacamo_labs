// Aqui embaixo, está definida a unica "certeza" que o agente tem inicialmente: que um atributo chamado "preference" é 20.
// Nesse programa, "preference" indica o valor ambiente desejado inicialmente.
// O nome desse atributo é arbitrário, e pode ser visto como uma variável normal em linguagem de programação.
// Note que comentando mais abaixo, existem outros atributos de exemplo, mas que não são usados no programa.    
preference(20). 
//mundo("rosa").
//x(47).

// "start" indica o lançamento de um objetivo, pois está com um ponto de exclamação.
// Esse trecho de código é semelhante a chamada de uma função em uma linguagem de programação funcional.
// O programa irá procurar no arquivo, algum plano que trata esse objetivo.
// Do do ponto de vista da teoria BDI ("belief-desire-intention"), isto é um "desejo": algo que o agente quer.
// Se a aplicação for mal desenvolvida, os desejos podem ser conflitantes (Por exemplo, um drone quer chegar a um ponto ao mesmo tempo
// que quer ficar parado.)
!start.

// Esse é um plano que (na verdade o único possível nesse programa) que trata o lançamento, ou evento, 
// do objetivo "!start".
// Note que o "+" na frente indica que quando for lançada uma crença ou objetivo (no caso "!start"),
// então deverá ser seguida a sequência de passos definidas à direita de "<-" (ou seja, o plano).
// No caso abaixo, o plano consiste no lançamento de outro objetivo: "!keep_temperature".
// Cada comando que consiste o plano (separado por ";", sendo o último terminado com ".") é chamado de 
// "intenção" do agente. Uma intenção leva a uma ação (ex.: quero printar indicando ".print").
// Uma intenção precede uma ação.
// Porque o programa já não lançou o "!keep_temperature" ao invés do "!start"?
// Note que o lançamento desse objetivo partiu do próprio programa, mas poderia ter sido passado externamente a ele, por meio do ambiente.
+!start <- !keep_temperature.

// Abaixo, temos três planos que podem ser realizados, quando for lançado o objetivo "!keep_temperature".
// Qual deles será lançado? 
// Apenas um será lançado, pois os planos tem condições associadas.
// Apenas uma dessas condições será verdadeira por vez.
// O primeiro plano que tiver uma condição verdadeira, será realizado.
// Nas condições estão sendo avaliadas a preferencia de temperatura (um estado mental do agente) e
// a temperatura ambiente (uma propriedade observavel do ambiente).
// No primeiro momento, como a preferência é igual a 20 e a temperatura é igual a 30 (definida no arquivo "smart-room.jcm"),
// então o primeiro plano será realizado.
// Nesse plano temos a seguinte condição:
// Verificamos se existe um valor atual da preferencia de temperatura e, se houver, colocamos na variável P ("preference(P)") - caso essa "preference" nunca tenha sido definida, então, essa codição seria falsa;
// Em seguida verificamos se existe um valor atual de temperatura ambiente e, se houver, colocamos na variável C ("temperature(C)");
// Por fim, comparamos esses dois valores pegos e realizamos uma comparação, se C é maior que P.
// Como a condição é verdadeira no primeiro momento (30 > 20), então o plano será realizado.
// Nesse plano, será feita a "atuação" "startCooling", cuja interface é disponibilizada pelo programa em Java que simula o artefato HVAC.
// Após realizar a atuação "startCooling", o ambiente vai começar a abaixar continuamente a temperatura.
// Em seguida, é lançado o objetivo "!wait_until", que recebe um parâmetro: a temperatura que nós queremos alcançar ("P").
// Abaixo será explicado os planos para "!wait_until", porém agora, focamos no plano atual.
// Quando a temperatura ambiente chegar no valor "P" desejado, "!wait_until" terá finalizado.
// Note que no final dos três planos abaixo, existe um lançamento "recursivo" de "!keep_temperature".
// Sem esse lançamento, o agente não irá mais tentar manter a temperatura de preferência, mesmo que a temperatura ambiente mude.
// O plano base para "!keep_temperature" é o último plano "+!keep_temperature".
// Ele não possui nenhuma condição e serve apenas para lançar novamente o objetivo "!keep_temperature", para que o agente
// verifique de forma ciclica cada plano e ache um que tenha uma condição valida.  
+!keep_temperature
   :  preference(P) & temperature(C) & C > P
   <- startCooling; !wait_until(P); !keep_temperature.
+!keep_temperature
   :  preference(P) & temperature(C) & C < P
   <- startHeating; !wait_until(P); !keep_temperature.
+!keep_temperature
  <- !keep_temperature.

// Da mesma forma que "!keep_temperature", no "!wait_until" temos um plano com condição e um plano base.
// O primeiro plano tem como condição receber a temperatura desejada (referenciada como o parâmetro "T"), e
// verificar se o valor da temperatura ambiente ("temperature") é igual a T.
// Se a condição for verdadeira, é chamada a interface de atuação "stopAirConditioner", que fará com que o 
// HVAC pare de atuar na temperatura.
// Note que a sintaxe de comparação entre uma variável (no exemplo "T") e um belief (no exemplo "temperature")
// no campo de condição (dada por "temperature(T)") é a mesma de atribuição quando colocamos em outra parte do código. 
+!wait_until(T) : temperature(T) <- stopAirConditioner.
+!wait_until(T) <- !wait_until(T).

// Task 3: Improve the implementation

// Exercise 4
// lançado o objetivo de observar o estato do hvac - outro parâmetro observavel além da temperatura.
// Note que pela linguagem Jason, o lancamento do objetivo abaixo e o lancamento do objetivo "!start." lá no começo
// ocorrem de forma paralela/concorrente. Contudo, o paralelismo só vai ocorrer de fato se a camada abaixo
// fornecer esse mecanismo. 
!show_hvac_state.

// Neste plano, estamos usando o campo de condição para recuperar o valor de estado e colocar na variável T ("stete(T)").
// Dentro do plano, estamos utilizando duas funções da API do Jason, ambas começam com um ponto (".").
// A função println imprime os arumentos que recebe, na saída padrão, inserindo caractere de nova linha.
// A função "wait" trava o ciclo de pensamento (reasoning cycle) do agente por uma quantidade de milissegundos.
+!show_hvac_state
   : state(T)
   <- .println("The HVAC state is: ", T); .wait(500); !show_hvac_state.




{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
