import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_app/services/magias_service.dart';

void main() {
  group('MagiasService - Testes Unitários', () {
    test('TU-01: Deve validar se URL base da API está correta', () {
      // Arrange & Act
      final baseUrl = MagiasService.baseUrl;
      
      // Assert
      expect(baseUrl, equals('https://www.dnd5eapi.co/api'));
      expect(baseUrl, isNotEmpty);
      expect(baseUrl, contains('https://'));
    });

    test('TU-02: Deve criar instância do serviço corretamente', () {
      // Arrange & Act
      final magiasService = MagiasService();
      
      // Assert
      expect(magiasService, isNotNull);
      expect(magiasService, isA<MagiasService>());
    });
  });
}