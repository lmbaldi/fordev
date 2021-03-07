Feature: Responder uma Enquete
Como um cliente
Quero poder responder uma enquete
Para dar minha contribuição e opinião para a comunidade

Scenario: : Com internet
Given que o cliente tem conexão com a internet
When solicitar para responder uma enquete
Then o sistema deve gravar sua resposta
And atualizar o cache com as novas estatísticas
And mostrar para o usuário o resultado atualizado

Scenario:  Sem internet
Given que o cliente não tem conexão com a internet
When solicitar para responder uma enquete
Then o sistema deve exibir uma mensagem de erro