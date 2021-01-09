# Login Presenter

> ## Regras
1. Chamar validation ao alterar o email
2. Notiticar o emailErrorStream com o mesmo erro do Validation, caso retorne o erro
3. Notificar o emailErrorStream com null, caso o Validation não retorne erro
4. Não notificar  o emailErrorStream se o valor for igual o ultimo
5. Notificar o isFormValidation após alterar o email
6. Chamar Validation ao alterar a senha
7. Notificar o passwordErrorStream com o mesmo erro do Validation, caso retorne erro
8. Notificar o passwordErrorStream com null, caso o Valitation não retorne erro
9. Não notificar o passwordErrorStream se o valor for igual ao ultimo
10. Notificar o isFormValidStream após alterar a senha
11. Para o formulário estar válido todos os Streams de erro precisam estar null e todos os campos
obrigatórios não podem estar vazios.
12. Não notificar o isFormValidStream se o valor for igual ao ultimo
13. Chamar o Authentication com email e senha corretos
14. Notificar o isLoadingStream  como true antes de chamar o Authentication
15. Notificar o isLoadingStream como false no fim do Authentication
16. Notificar o mainErrorStream  caso o Authentication retorne um DomainError
17. Fechar todos os Streams no dispose
18. Gravar o Account no cache em caso de sucesso
19. Levar o usuario pra tela de enquetes em caso de sucesso