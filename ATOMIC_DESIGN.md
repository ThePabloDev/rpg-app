# Arquitetura Atomic Design - RPG App

Este projeto foi refatorado para implementar a metodologia **Atomic Design**, criada por Brad Frost. Esta abordagem organiza os componentes da interface em cinco níveis hierárquicos: Átomos, Moléculas, Organismos, Templates e Páginas.

## 📁 Estrutura de Pastas

```
lib/
├── ui/
│   ├── atoms/              # Elementos básicos e indivisíveis
│   ├── molecules/          # Grupos simples de átomos funcionando juntos
│   ├── organisms/          # Grupos complexos de moléculas formando seções distintas
│   ├── screens/
│   │   └── templates/      # Estruturas de página que definem o layout
│   └── ui_components.dart  # Arquivo de exportação centralizada
└── screens/                # Páginas específicas da aplicação
```

## 🔬 Átomos (Atoms)

### Componentes Básicos Implementados:

- **`RPGText`** - Componente de texto customizado com estilos RPG
- **`RPGButton`** - Botão com diferentes variações (primary, secondary, outlined, text)
- **`RPGTextField`** - Campo de entrada de texto padronizado
- **`RPGDropdown`** - Seletor dropdown customizado
- **`RPGCard`** - Container com estilo de card RPG
- **`RPGBackground`** - Componente de fundo com imagem e overlay

### Características dos Átomos:
- Não podem ser quebrados em componentes menores
- Contêm apenas lógica de apresentação
- São reutilizáveis em todo o app
- Seguem o design system da aplicação

## 🧪 Moléculas (Molecules)

### Componentes Combinados Implementados:

- **`RPGFormField`** - Campo de formulário com label e validação
- **`RPGActionButton`** - Botão com funcionalidades adicionais e semântica
- **`RPGLoginForm`** - Estrutura básica de formulário de login
- **`RPGAttributeSlider`** - Controle deslizante para atributos de personagem

### Características das Moléculas:
- Combinam átomos para formar componentes funcionais
- Têm propósito específico e bem definido
- Mantêm a simplicidade e reutilização

## 🦠 Organismos (Organisms)

### Seções Complexas Implementadas:

- **`LoginFormOrganism`** - Formulário completo de login com validação
- **`RegisterFormOrganism`** - Formulário completo de cadastro
- **`CharacterCreationFormOrganism`** - Sistema completo de criação de personagem

### Características dos Organismos:
- Formam seções distintas da interface
- Combinam moléculas e átomos
- Possuem lógica de negócio específica
- Gerenciam estados complexos

## 📄 Templates

### Estruturas de Layout Implementadas:

- **`AuthTemplate`** - Template para telas de autenticação
- **`AppTemplate`** - Template padrão para telas internas do aplicativo

### Características dos Templates:
- Definem a estrutura geral da página
- Determinam onde os organismos são posicionados
- Não contêm dados específicos
- Focam no layout e estrutura

## 📱 Páginas (Pages/Screens)

### Telas Refatoradas:

- **`TelaLogin`** - Tela de autenticação
- **`TelaCadastro`** - Tela de registro
- **`TelaCriacaoPersonagem`** - Tela de criação de personagem
- **`TelaListaPersonagens`** - Lista de personagens
- **`TelaConfiguracoes`** - Configurações do aplicativo

### Características das Páginas:
- Implementam templates específicos
- Contêm dados e lógica de navegação
- Representam as telas finais da aplicação

## 🎨 Design System

### Paleta de Cores:
- **Primária**: `Colors.amber` (dourado)
- **Secundária**: `Colors.black` (preto)
- **Texto**: `Colors.white` (branco)
- **Fundo**: `Colors.grey[900]` (cinza escuro)

### Tipografia:
- **Títulos**: Google Fonts Cinzel (temática medieval)
- **Corpo**: Flutter default com customizações

## 🛠️ Benefícios da Implementação

### 1. **Reutilização de Código**
- Componentes podem ser usados em diferentes contextos
- Redução significativa de duplicação de código

### 2. **Manutenibilidade**
- Mudanças em componentes básicos se propagam automaticamente
- Facilita atualizações do design system

### 3. **Consistência Visual**
- Garante uniformidade em toda a aplicação
- Facilita a manutenção da identidade visual

### 4. **Desenvolvimento Colaborativo**
- Diferentes desenvolvedores podem trabalhar em diferentes níveis
- Separação clara de responsabilidades

### 5. **Testabilidade**
- Componentes menores são mais fáceis de testar
- Isolamento de funcionalidades facilita testes unitários

## 📚 Como Usar

### Importando Componentes:
```dart
import '../ui/ui_components.dart';
```

### Exemplo de Uso:
```dart
// Átomo
RPGText('Título', style: RPGTextStyle.title)

// Molécula
RPGFormField(
  label: 'Email',
  controller: emailController,
  validator: (value) => /* validação */,
)

// Organismo
LoginFormOrganism(
  onLogin: () => /* ação de login */,
  onNavigateToRegister: () => /* navegação */,
)

// Template
AuthTemplate(
  child: /* conteúdo da página */,
)
```

## 🎯 Próximos Passos

1. **Implementar mais átomos** conforme necessidades surgem
2. **Criar temas** para suportar modo claro/escuro
3. **Adicionar animações** nos componentes
4. **Implementar testes** para todos os níveis
5. **Documentar props** de cada componente
6. **Criar Storybook** para demonstrar componentes

## 📖 Referências

- [Atomic Design por Brad Frost](https://bradfrost.com/blog/post/atomic-web-design/)
- [Flutter Widget Documentation](https://flutter.dev/docs)
- [Material Design Guidelines](https://material.io/design)

---

Esta arquitetura torna o projeto mais escalável, manutenível e consistente, seguindo as melhores práticas de desenvolvimento Flutter e design systems modernos.
