# Central de Achados — versão corrigida

Os defeitos intencionais do modelo, cadastro, filtro, navegação, status e pistas foram corrigidos. O relatório de alterações está em `LAUDO.md`.

## Importante: configurar o Firebase

O ZIP original não contém `lib/firebase_options.dart` porque esse arquivo é gerado para o projeto Firebase específico da escola. Não é seguro inventar chaves ou substituir a configuração por valores falsos.

1. Abra o projeto no VS Code.
2. Configure o projeto Firebase fornecido pelo professor usando FlutterFire CLI, ou copie `lib/firebase_options.dart` gerado para esse mesmo projeto.
3. Confirme que Authentication > Google está ativado e que o domínio de desenvolvimento está autorizado.
4. Preserve as regras de segurança do Firestore; elas devem restringir alterações de status ao autor da ocorrência.
5. Rode `flutter pub get` e depois `flutter analyze`.

Se `flutter pub get` falhar com `ERROR_ACCESS_DENIED` ao criar um link em `linux/flutter/ephemeral/.plugin_symlinks`, abra PowerShell na pasta do projeto e rode `flutter config --no-enable-linux-desktop`, depois tente `flutter pub get` novamente. Isso desativa apenas o alvo de desktop Linux no SDK local, não remove a autenticação nem desativa as regras do Firestore. Se a política do computador bloquear essa alteração, peça ao professor/admin para habilitar a criação de links simbólicos.

Para o teste multiusuário, use duas contas autorizadas em perfis separados do Chrome. A captura deve mostrar a mesma ocorrência nas duas sessões.
