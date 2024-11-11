!start.

//+!start
//   <- .wait(500);
//      .send(karlos, askOne, vl(_)).

// Primeiramente esperamos meio segundo para que Bob envie a mensagem a Karlos primeiro, dando a ele a crençasobre vl.
// Pois queremos de Karlos, o valor de "vl" ("vl(_)") e ele não tem crença nenhuma sobre vl.
// Também, vamos salvar o valor de "vl" na variável "X" ("vl(X)") para printar.
+!start
   <- .wait(500);
      .send(karlos, askOne, vl(_), vl(X));
      .println(X).