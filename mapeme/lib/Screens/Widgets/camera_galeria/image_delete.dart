import 'dart:io';

// Função para excluir uma imagem do diretório de documentos do aplicativo
void deleteImageFromDocumentsDirectory(File? imagePath) async {
  try {
    // Verifica se o arquivo existe antes de excluí-lo
    if (await imagePath!.exists()) {
      // Exclui o arquivo
      await imagePath.delete();
      // ignore: avoid_print
      print('Imagem excluída com sucesso: $imagePath');
    } else {
      // ignore: avoid_print
      print('Arquivo não encontrado: $imagePath');
    }
  } catch (error) {
    // ignore: avoid_print
    print('Erro ao excluir a imagem: $error');
  }
}


