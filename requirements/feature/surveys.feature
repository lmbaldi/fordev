Feature: Listar Enquetes
  Como um cliente
  Quero poder ver todas as enquetes
  Para saber o resultado e poder dar  minha opinião

Scenario: Com internet
Given que o cliente tem conexão com a internet
When  solicitar para ver as enquetes
Then o sistema deve exibir as enquetes
And armazenar os dados atualizados no cache

Scenario: Sem internet
Given que o cliente não tem conexão com a internet
When solicitar para ver as enquetes
Then o sistema deve exibir as enquetes que foram gravadas no cache no último acesso