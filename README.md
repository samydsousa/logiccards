# Logic Cards

Aplicativo criado para desenvolver uma abordagem fundamentada na metodologia da gamificação na disciplina de Lógica, do curso de Tecnologia em Análise e Desenvolvimento de Sistemas, do Instituto Federal de Educação, Ciência e Tecnologia do Pará (IFPA), Campus Paragominas.

A proposta foi a criação de uma baralho que pode ser impresso a partir das imagens disponíveis no diretório [images/colorful](https://github.com/samydsousa/logiccards/tree/main/images/colorful) cujo objetivo é que as cartas sejam jogadas de maneira a formar proposições lógicas. O aplicativo serve apenas para indicar as cartas que podem ser jogadas bem como o valor das proposições que vão se formando.

A versão para Andoid está disponível no Google Play por meio do endereço [https://play.google.com/store/apps/details?id=com.sslourenco.logiccards](https://play.google.com/store/apps/details?id=com.sslourenco.logiccards). 

O código fonte do aplicativo está disponível no Github por meio do repositório [logiccards](https://github.com/samydsousa/logiccards/tree/main).

## Regras do Jogo

- O jogo inicia com a distribuição de seis cartas para cada jogador;
- As demais cartas são colocadas ao alcance dos jogadores para serem usadas como cartas reservas;
- As jogadas ocorrem de forma circular;
- Quem inicia a partida e o sentido de rotação das jogadas pode ser livremente definido pelos jogadores;
- Na sua jogada, com exceção do início da partida, cada jogador pode jogar, ordenadamente, quantas cartas desejar, desde que sejam respeitadas as regras:
    - As proposições só podem ser iniciadas por uma carta de negação (¬) ou de valor (V ou F);
    - Após uma carta de negação só pode ser jogada uma carta de valor;
    - Após uma carta de valor pode ser jogada uma carta de operador (∧, ∨, ⊻, → ou ↔) ou, caso a carta de valor conclua uma proposição composta, iniciar uma nova proposição com a carta correspondente ao valor da proposição que se formou;
    - Após uma carta de operador aplica-se a regra do início de uma proposição.
- Caso em sua jogada o jogador não possua nenhuma carta que se enquadre nas permissões anteriores, deverá pegar sequencialmente uma carta dentre as reservas até encontrar uma carta que cumpra alguma das permissões;
- Caso as cartas reservas se esgotem, as que já foram jogadas, com exceção das que estão compondo a última proposição composta, devem ser embaralhadas para serem usadas como reservas;
- Caso a regra anterior não possa mais ser aplicada, o próximo jogador fará sua jogada;
- O vencedor da partida será o primeiro que conseguir jogar todas as suas cartas;
- Se a partida estiver sendo jogada por mais de duas pessoas, o jogo pode continuar com os demais jogadores.