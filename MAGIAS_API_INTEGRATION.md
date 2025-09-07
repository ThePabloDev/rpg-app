# Integração com API D&D 5e SRD - ATUALIZADA

## Mudanças Realizadas

### 📡 API Atualizada
- **Antes**: `https://api-magias-dnd.herokuapp.com/api` (não funcionando)
- **Depois**: `https://www.dnd5eapi.co/api/2014` (API oficial do D&D 5e SRD)

### 🔄 Estrutura de Dados Atualizada

A nova API possui uma estrutura diferente dos dados, com as seguintes melhorias:

#### Campos Novos:
- `material`: Componente material necessário para a magia
- `classes`: Lista de classes que podem usar a magia
- URLs mais consistentes e confiáveis

#### Campos Modificados:
- `desc`: Array de strings (em vez de string única)
- `higher_level`: Array de strings (em vez de string única) 
- `school`: Objeto com `name` e `url` (em vez de string)
- `components`: Array de strings (em vez de string)

### 🚀 Melhorias no Serviço

#### Cache Implementado
- As magias são armazenadas em cache para melhor performance
- Método `clearCache()` para limpar o cache quando necessário

#### Métodos Disponíveis:
1. `fetchMagias()` - Busca 20 magias para demonstração (com cache)
2. `fetchMagiaByName(String name)` - Busca magia específica
3. `searchMagias(String query)` - Pesquisa nas magias carregadas
4. `fetchAllMagias()` - Busca todas as 319 magias (mais lento)

#### Tratamento de Erros Melhorado:
- Logs detalhados durante o carregamento
- Tratamento específico para diferentes códigos de erro HTTP
- Fallback em caso de erro em magias específicas

### 🎯 API Testada

A nova API foi testada e confirmada funcionando:
- ✅ 319 magias disponíveis
- ✅ Dados consistentes e completos
- ✅ API oficial e confiável
- ✅ Suporte a pesquisa por nome específico

### 📚 Exemplo de Uso

```dart
final service = MagiasService();

// Buscar magias (cache automático)
final magias = await service.fetchMagias();

// Buscar magia específica
final fireball = await service.fetchMagiaByName('Fireball');

// Pesquisar magias
final resultados = await service.searchMagias('fire');

// Limpar cache
MagiasService.clearCache();
```

### 🎮 Campos Disponíveis por Magia

```dart
class Magia {
  final String name;           // Nome da magia
  final String level;          // Nível (0-9)
  final String school;         // Escola de magia
  final String castingTime;    // Tempo de conjuração
  final String range;          // Alcance
  final String components;     // Componentes (V, S, M)
  final String duration;       // Duração
  final String description;    // Descrição completa
  final String? higherLevel;   // Efeitos em níveis superiores
  final String? ritual;        // Se pode ser ritual
  final String? concentration; // Se requer concentração
  final String? material;      // Componente material
  final List<String>? classes; // Classes que podem usar
}
```

### ⚡ Performance

- **Cache**: Primeiro carregamento pode levar ~10 segundos para 20 magias
- **Pesquisa**: Instantânea após carregamento inicial
- **Busca específica**: ~1 segundo por magia
- **Todas as magias**: ~2-3 minutos para carregar todas as 319 magias

## Uso na Aplicação

O serviço já está integrado na tela de magias (`TelaMagias`) e funcionará automaticamente com as melhorias implementadas. Não são necessárias mudanças adicionais nas telas existentes.

---

## Documentação Anterior (Arquivada)

## Arquivos Criados

### 1. Modelo de Dados
- **`lib/models/magia.dart`**: Define a classe `Magia` com todos os campos necessários para representar uma magia D&D.

### 2. Serviço da API
- **`lib/services/magias_service.dart`**: Serviço responsável por consumir a API de magias.
  - `fetchMagias()`: Busca todas as magias
  - `fetchMagiaByName()`: Busca uma magia específica por nome
  - `searchMagias()`: Busca magias por termo de pesquisa

### 3. Componentes de Interface
- **`lib/ui/molecules/magia_card.dart`**: Card compacto para exibir magias na lista
- **`lib/ui/organisms/magia_detail_organism.dart`**: Tela de detalhes completos da magia

### 4. Tela Principal
- **`lib/screens/tela_magias.dart`**: Tela principal que lista todas as magias com:
  - Barra de pesquisa
  - Lista infinita de magias
  - Contador de resultados
  - Estados de loading, erro e lista vazia
  - Pull-to-refresh

## Funcionalidades Implementadas

### 🔍 Pesquisa de Magias
- Pesquisa por nome da magia
- Pesquisa por escola de magia
- Pesquisa por nível
- Filtros aplicados em tempo real

### 📱 Interface Responsiva
- Cards estilizados seguindo o design system RPG
- Cores diferenciadas por escola de magia:
  - **Azul**: Abjuração
  - **Verde**: Conjuração
  - **Roxo**: Adivinhação
  - **Rosa**: Encantamento
  - **Vermelho**: Evocação
  - **Índigo**: Ilusão
  - **Cinza**: Necromancia
  - **Laranja**: Transmutação

### 📖 Detalhes Completos
- Nome e nível da magia
- Escola de magia
- Tempo de conjuração
- Alcance
- Componentes necessários
- Duração
- Descrição completa
- Informações de níveis superiores
- Indicadores de ritual e concentração

### 🌐 Integração com API
- Base URL: `https://api-magias-dnd.herokuapp.com/api`
- Endpoint português: `/br/spells`
- Endpoint inglês: `/en/spells`
- Busca específica: `/br/spells/{nome-da-magia}`

## Navegação

A tela de magias foi integrada ao menu principal da aplicação como a terceira aba, acessível através do BottomNavigationBar com o ícone de varinha mágica.

## Estados da Interface

1. **Loading**: Indicador de carregamento com texto explicativo
2. **Erro**: Tela de erro com botão para tentar novamente
3. **Lista Vazia**: Mensagem quando nenhuma magia é encontrada na pesquisa
4. **Lista Preenchida**: Grid de cards com as magias encontradas

## Tratamento de Erros

- Timeout de conexão
- Erro de rede
- Erro de parsing JSON
- Magia não encontrada (404)
- Erro interno do servidor (500)

## Dependências Adicionadas

```yaml
dependencies:
  http: ^1.2.0  # Para requisições HTTP
```

## Melhorias Futuras Possíveis

- [ ] Cache offline das magias
- [ ] Favoritar magias
- [ ] Filtros avançados (nível, escola, componentes)
- [ ] Compartilhamento de magias
- [ ] Integração com personagens (magias conhecidas)
- [ ] Modo offline com sincronização
- [ ] Animações de transição melhoradas

## Exemplo de Uso

```dart
// Buscar todas as magias
final magias = await MagiasService().fetchMagias();

// Buscar magia específica
final magia = await MagiasService().fetchMagiaByName('fireball');

// Pesquisar magias
final resultados = await MagiasService().searchMagias('fogo');
```

A integração está completa e funcional, proporcionando uma experiência rica para consulta de magias D&D diretamente no aplicativo RPG.
