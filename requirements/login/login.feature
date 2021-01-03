#language:pt

Feature: Login
Como um cliente
Quero poder acessr minha conta e me manter logado
Para que eu possa ver e responder enquetes de forma rápida

Cenario: Credenciais Válidas
Dado que o cliente informou credenciais válidas
Quando solicitar para fazer login
Então o sistema deve enviar o usuário para a tela de pesquisas
E manter o usuario conectado

Cenário: Credenciais Inválidas
Dado que o cliente informou credenciais inválidas
Quando solicitar para fazer login
Então o sistema dever informar uma mensagem de erro


