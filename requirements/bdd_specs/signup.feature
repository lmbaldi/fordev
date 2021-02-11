Feature: Criar Conta
  Como um cliente
  Quero poder criar uma conta e me manter logado
  Para que eu possa ver e responder enquetes de forma rápida

Scenario:  Dados Válidos
Given que o cliente informou dados válidos
When  solicitar para criar a conta
Then  o sistema deve enviar o usuário para a tela de pesquisas
And   manter o usuário conectado

Scenario: Dados Inválidos
Given que o cliente informou dados inválidos
When solicitar para criar a conta
Then o sistema deve retornar uma mensagem de erro