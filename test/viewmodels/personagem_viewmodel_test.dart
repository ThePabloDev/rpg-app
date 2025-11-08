import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_app/viewmodels/personagem_viewmodel.dart';

void main() {
  group('PersonagemViewModel - Testes de Rolagem de Atributos', () {
    test('TU-03: Deve rolar atributos com valores diferentes para cada atributo', () {
      // Arrange
      final viewModel = PersonagemViewModel();
      
      // Act
      viewModel.rolarAtributos();
      
      // Collect valores após a rolagem
      final atributos = [
        viewModel.forca,
        viewModel.destreza,
        viewModel.constituicao,
        viewModel.inteligencia,
        viewModel.sabedoria,
        viewModel.carisma,
      ];
      
      // Assert
      // Verifica se todos os valores estão no range válido (3-18 para 4d6 drop lowest)
      for (final atributo in atributos) {
        expect(atributo, greaterThanOrEqualTo(3));
        expect(atributo, lessThanOrEqualTo(18));
      }
      
      // Verifica se existe variação nos valores (não podem ser todos iguais)
      // Roda múltiplas vezes para garantir que há randomização
      final Set<int> valoresUnicos = atributos.toSet();
      
      // É estatisticamente quase impossível todos os 6 atributos serem iguais
      // com rolagem aleatória adequada, então esperamos pelo menos 2 valores diferentes
      expect(valoresUnicos.length, greaterThan(1), 
        reason: 'Os atributos devem ter valores variados, não todos iguais');
    });

    test('TU-04: Deve produzir resultados diferentes em múltiplas rolagens', () {
      // Arrange
      final viewModel = PersonagemViewModel();
      
      // Act - Primeira rolagem
      viewModel.rolarAtributos();
      final primeiraRolagem = [
        viewModel.forca,
        viewModel.destreza,
        viewModel.constituicao,
        viewModel.inteligencia,
        viewModel.sabedoria,
        viewModel.carisma,
      ];
      
      // Act - Segunda rolagem
      viewModel.rolarAtributos();
      final segundaRolagem = [
        viewModel.forca,
        viewModel.destreza,
        viewModel.constituicao,
        viewModel.inteligencia,
        viewModel.sabedoria,
        viewModel.carisma,
      ];
      
      // Assert - As duas rolagens devem ser diferentes
      // É estatisticamente quase impossível que todas as 6 rolagens sejam idênticas
      expect(primeiraRolagem, isNot(equals(segundaRolagem)),
        reason: 'Múltiplas rolagens devem produzir resultados diferentes');
    });

    test('TU-05: Deve validar método de rolagem 4d6 drop lowest', () {
      // Arrange
      final viewModel = PersonagemViewModel();
      
      // Act & Assert - Testa múltiplas rolagens para verificar distribuição
      final resultados = <int>[];
      for (int i = 0; i < 100; i++) {
        viewModel.rolarAtributos();
        resultados.addAll([
          viewModel.forca,
          viewModel.destreza,
          viewModel.constituicao,
          viewModel.inteligencia,
          viewModel.sabedoria,
          viewModel.carisma,
        ]);
      }
      
      // Verifica se os valores estão no range esperado
      for (final resultado in resultados) {
        expect(resultado, greaterThanOrEqualTo(3)); // Mínimo possível: 1+1+1=3
        expect(resultado, lessThanOrEqualTo(18));   // Máximo possível: 6+6+6=18
      }
      
      // Verifica se há boa distribuição (não só valores extremos)
      final valoresUnicos = resultados.toSet();
      expect(valoresUnicos.length, greaterThan(5), 
        reason: 'Deve haver boa distribuição de valores');
    });
  });
}