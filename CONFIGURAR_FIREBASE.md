# Antes de executar o aplicativo

Este projeto usa Firebase Authentication e Cloud Firestore. O arquivo `lib/firebase_options.dart` é gerado para o projeto Firebase específico da escola e não estava presente no ZIP original enviado.

Não é seguro inventar esse arquivo: ele precisa corresponder ao projeto Firebase autorizado pelo professor.

## Gerar a configuração

1. Abra o terminal na pasta do projeto.
2. Confirme que o FlutterFire CLI está disponível e que você entrou na conta Google que tem acesso ao projeto Firebase da turma.
3. Execute `flutterfire configure`.
4. Selecione o projeto Firebase indicado pelo professor e a plataforma que será usada (por exemplo, Web).
5. Confirme que o comando criou `lib/firebase_options.dart`.
6. No Firebase Console, confirme que o provedor Google está habilitado em Authentication e que o Firestore está criado.
7. Mantenha as regras de segurança da atividade. Não use regras públicas para contornar erros.
8. Execute `flutter pub get` e depois `flutter run -d chrome`.

Se o computador bloquear permissões para criar links simbólicos, use um terminal/perfil autorizado pela escola ou peça ao professor/administrador para habilitar a permissão. Não desative a segurança do Firebase.
