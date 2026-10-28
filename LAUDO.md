# Laudo técnico — Operação Resgate

> Projeto corrigido a partir dos defeitos encontrados no código fornecido. O teste final com duas contas depende de configurar o Firebase da escola e de executar o app em dois perfis de navegador.

## Bug 01 — Identificação do responsável no modelo
**Arquivo:** `lib/models/ocorrencia.dart`  
**Sintoma:** o ID do responsável podia ser igual ao nome exibido, fazendo a autorização falhar.  
**Causa:** `autorId` era lido do campo `autorNome`.  
**Correção:** `autorId` agora é lido de `d['autorId']`.  
**Teste:** conferir que o `autorId` carregado corresponde ao UID armazenado no documento.

## Bug 02 — Estado de resolução invertido
**Arquivo:** `lib/models/ocorrencia.dart`  
**Sintoma:** itens abertos apareciam resolvidos e vice-versa.  
**Causa:** o valor booleano era negado durante a leitura.  
**Correção:** o modelo usa diretamente o campo `resolvido`, com padrão `false`.  
**Teste:** cadastrar uma ocorrência e confirmar que aparece como “Em aberto”.

## Bug 03 — Validação do cadastro
**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** o formulário aceitava o cadastro quando apenas um dos campos obrigatórios estava preenchido.  
**Causa:** a condição usava `&&` em vez de `||`.  
**Correção:** título vazio **ou** local vazio bloqueia o envio.  
**Teste:** tentar cadastrar sem título e depois sem local; ambos devem ser recusados.

## Bug 04 — Controle do filtro
**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** o interruptor podia ficar com estado diferente do valor selecionado.  
**Causa:** o callback invertia o estado local sem usar o valor recebido.  
**Correção:** `somenteAbertos` recebe diretamente `value`.  
**Teste:** ligar e desligar o filtro e confirmar que o interruptor acompanha a seleção.

## Bug 05 — Filtro de ocorrências abertas
**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** o filtro “Somente não resolvidos” mostrava itens resolvidos.  
**Causa:** a lista filtrava `o.resolvido` em vez de `!o.resolvido`.  
**Correção:** são exibidas apenas ocorrências não resolvidas quando o filtro está ligado.  
**Teste:** comparar a lista com o filtro desligado e ligado.

## Bug 06 — Navegação para detalhes
**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** abrir uma ocorrência não fornecia o objeto necessário à tela de detalhes.  
**Causa:** `DetalhePage` era criada sem o parâmetro obrigatório.  
**Correção:** a navegação passa a ocorrência selecionada.  
**Teste:** abrir duas ocorrências diferentes e conferir título, local e descrição.

## Bug 07 — UID salvo no cadastro
**Arquivo:** `lib/services/central_service.dart`  
**Sintoma:** o usuário que criou uma ocorrência podia não ser reconhecido como responsável.  
**Causa:** `autorId` armazenava o e-mail, e não o UID do Firebase Authentication.  
**Correção:** salvar `user.uid` e manter o nome/e-mail somente em `autorNome`.  
**Teste:** comparar o UID da sessão com o campo `autorId` no Firestore.

## Bug 08 — Alternância do status
**Arquivo:** `lib/services/central_service.dart`  
**Sintoma:** tocar em “Marcar como resolvido” podia gravar o mesmo valor anterior.  
**Causa:** o serviço atualizava `resolvido` com `item.resolvido`.  
**Correção:** gravar `!item.resolvido`, após verificar se o usuário é o responsável.  
**Teste:** marcar como resolvido e depois reabrir com a conta proprietária.

## Bug 09 — Caminho de gravação das pistas
**Arquivo:** `lib/services/central_service.dart`  
**Sintoma:** as pistas não apareciam na ocorrência correta.  
**Causa:** o serviço usava o documento fixo `pistas` em vez do ID da ocorrência.  
**Correção:** gravar em `ocorrencias/{ocorrenciaId}/pistas`.  
**Teste:** enviar pistas em dois casos e confirmar que cada uma aparece somente no caso correto.

## Bug 10 — Validação do texto da pista
**Arquivo:** `lib/pages/detalhe_page.dart`  
**Sintoma:** o envio era interrompido quando havia texto e tentava prosseguir com o campo vazio.  
**Causa:** a condição de retorno estava invertida.  
**Correção:** texto vazio exibe aviso e interrompe o envio.  
**Teste:** tentar enviar vazio e depois uma pista válida.

## Bug 11 — Conteúdo enviado como pista
**Arquivo:** `lib/pages/detalhe_page.dart`  
**Sintoma:** o serviço recebia uma string vazia mesmo quando o usuário digitava uma pista.  
**Causa:** a chamada passava `''` em vez do conteúdo do controlador.  
**Correção:** enviar a mensagem aparada (`pista.text.trim()`) e limpar o campo após sucesso.  
**Teste:** enviar uma frase e confirmar que ela aparece na lista de pistas.

## Bug 12 — Fechamento do formulário
**Arquivo:** `lib/pages/central_page.dart`  
**Sintoma:** após cadastrar, a navegação podia fechar a tela central em vez do diálogo.  
**Causa:** o código fechava usando o contexto da página.  
**Correção:** o cadastro recebe e usa o contexto do diálogo para fechá-lo.  
**Teste:** cadastrar uma ocorrência e confirmar que o diálogo fecha e a central continua aberta.

## Verificações de entrega
- [ ] `flutter pub get` conclui sem erro.
- [ ] `flutter analyze` executado e mensagens restantes revisadas.
- [ ] Firebase configurado com o projeto autorizado da escola.
- [ ] Login Google testado.
- [ ] Duas contas/perfis veem a mesma ocorrência em tempo real.
- [ ] Uma conta diferente não consegue alterar o status de ocorrência alheia; as regras de segurança do Firestore também devem impor essa restrição.
- [ ] Captura de tela das duas contas anexada ao repositório.
