import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ocorrencia.dart';

class CentralService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Ocorrencia>> acompanhar() => _db
      .collection('ocorrencias')
      .orderBy('criadoEm', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map(Ocorrencia.fromDoc).toList());

  Future<void> registrar({
    required String titulo,
    required String local,
    required String descricao,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Você precisa entrar para registrar uma ocorrência.');
    if (titulo.trim().isEmpty || local.trim().isEmpty) {
      throw ArgumentError('Informe o objeto e o local.');
    }
    await _db.collection('ocorrencias').add({
      'titulo': titulo.trim(),
      'local': local.trim(),
      'descricao': descricao.trim(),
      'autorId': user.uid,
      'autorNome': user.displayName ?? user.email ?? 'Anônimo',
      'resolvido': false,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> alterarStatus(Ocorrencia item) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Você precisa entrar para alterar o status.');
    if (user.uid != item.autorId) {
      throw StateError('Apenas quem registrou a ocorrência pode alterar o status.');
    }
    await _db.collection('ocorrencias').doc(item.id).update({
      'resolvido': !item.resolvido,
    });
  }

  Future<void> enviarPista(String ocorrenciaId, String mensagem) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Você precisa entrar para enviar uma pista.');
    final texto = mensagem.trim();
    if (texto.isEmpty) throw ArgumentError('Digite uma pista antes de enviar.');
    await _db.collection('ocorrencias').doc(ocorrenciaId).collection('pistas').add({
      'mensagem': texto,
      'autorId': user.uid,
      'autorNome': user.displayName ?? user.email ?? 'Anônimo',
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> pistas(String id) => _db
      .collection('ocorrencias')
      .doc(id)
      .collection('pistas')
      .orderBy('criadoEm', descending: false)
      .snapshots();
}
