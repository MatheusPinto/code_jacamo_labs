teacher(karlos). // cria a variavel teacher e atribui ao agente karlos

// Um plano de contingêcia é um plano que começa com o sinal de menos ("-").
// Esse plano é invocado quando um erro/falta é lançado ao agente.
// Esse erro pode ser lançado externamente ou internamente ao agente.
// O tipo de erro que o plano de contingêcia trata é indicado no campo entre colchetes.
// No exemplo atual, esse plano será lançado quando algum pedido de plano for lançado, mas Alice não tiver esse plano.
// O tipo de erro que é lançado nesse caso é o "no_relevant".
// Ou seja, é um erro lançado internamente pela Alice.
// Nesse exemplo, Bob irá lançar à Alice o objetivo "show".
// Como Alice não tem um plano para esse objetivo, o plano de contingência abaixo será lançado.
// Neste plano Alice irá pedir a karlos, os planos para tratar "+!G" e guardar esses planos em "Plans".
// "+!G" indica o plano que falhou, que no caso é o "+!show".
// Em seguida, os planos recebidos são adicionados ao estado mental de Alice com ".add_plans".
// Por fim, Alice lança o objetivo !G, relacionado ao plano "+!G", ou seja "!show".
// Como Alice agora tem os planos para "!show", eles serão invocados normalmente.
-!G[error(no_relevant)] 
   :  teacher(T) 
   <- .send(T, askHow, { +!G }, Plans);
      .add_plan(Plans);
      !G.
