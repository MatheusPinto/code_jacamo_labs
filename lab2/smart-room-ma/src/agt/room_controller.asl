// Esse plano será o primeiro a ser feito, pois o objetivo "voting" é lançado no arquivo
// "smart-room.jcm" com as opções "[21,25,30]".
// As etapas são: abrir votação, enviando a todos os agentes assistentes;
//                Esperar todos os votos, por uma período máximo de 4 segundos;
//                Fechar votação, enviando a resposta a todos os agentes assistentes;
//                Setar a temperatura, com o valor mais votado.
+!voting(Options) 
   <- !open_voting(Id,Options);
      !wait_votes(Id);
      !close_voting(Id,T);
      !temperature(T).

// Plano para abrir votação.
// As opções de voto são passadas ao plano, e o Id da votação é definida dentro do plano 
// com o valor 1. Em seguida, é enviado a todos os agentes no ambientes, a crença
// "open_voting", com os valores de Id da votação, a lista de opções e o timeout de votação.
+!open_voting(Id,Options)
   <- Id = 1;
      .broadcast(tell, open_voting(Id,Options,4000)).

// O predicado "all_votes_received" irá ser verificado constantemente duruante o período
// de timeout até retornar true, indicando que todos os votos foram recebidos.
// "wait" irá finalizar depois de 4 segundos se os votos não forem recebidos.
// O underscore no terceiro argumento indica uma variável que não tem nome, pois não tenho interesse nela.
// Sem esse ultimo argumento, se ocorrer timeout é lançado um erro.
// Esse ultimo argumento é o tempo em milissegundos que demorou para que todos os votos fossem recebidos, mas não é usado aqui (por isso o underscore).
+!wait_votes(Id) <- .wait(all_votes_received(Id), 4000, _).

// Isso é chamado "regra estilo prolog", também chamado predicado.
// Podemos interepretar isso como: Se todos os votos foram recebidos, então retorna true. 
// Vai contar o número de votos, vinculados aos sources.
// ".count" irá retornar true apenas se o número de votos for 3.
// Note que sem o parametro "[source(_)]", se, por exemplo, os três agente enviarem o mesmo voto,
// então count irá contar apenas uma vez. Por exemplo, dado que o Id = 1, e supondo que os três
// agentes votaram pela temperatura 21, então se teriam 3 votos iguais (vote(1, 21)).
// Sem vincular um source, nesse caso, seria verificado na base de crenças apenas um vote com esse Id. 
all_votes_received(Id)
  :- .count(vote(Id,_)[source(_)], 3).  

// Após todos os votos serem chamados ou timeout acontecido, então se busca na base de crenças,
// a crença "most_voted(Id,T)". A crença que será achada é o predicado abaixo.
// O predicado irá colocar o valor da temperatura mais votada em T.
+!close_voting(Id,T)
   <- ?most_voted(Id,T);
      .println("New goal to set temperature to ",T);
      .broadcast(tell, close_voting(Id,T)).

//
most_voted(Id,T)
   :- .findall(
          t(C,V), 
          vote(Id,V) & .count(vote(Id,V)[source(_)],C), 
          LV)
      & .print("votes: ",LV)
      & .max(LV,t(_,T)).


// Aqui, o arquivo "temp_management.asl" não descreve um agente, mas sim 
// um conjunto de planos para controle da temperatura.
// Todo código de "temp_management.asl" é inserido nesse ponto arquivo "room_controller.asl".
tolerance(2). // used in temp_management
{ include("temp_management.asl") }

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
