# HTTP Responses Use Case

> ## Sucesso
1. Request com verbo http válido
2. Passar os headers com content type JSON
3. Chamar request com body correto
4. OK - 200 e resposta com dados
5. No content - 204 e responsta sem dados

> ## Erros
1. Bad request - 400
2. Unauthorized - 401
3. Forbidden - 403
4. Not Found - 404
5. Internal server error - 500

> ## Exceção - Status code diferente dos citados acima
1. Internal server error - 500

> ## Exceção - Http request deu alguma exceção
1. Internal server error - 500

> ## Exceção - Verbo Http inválido
1. Internal server error - 500
