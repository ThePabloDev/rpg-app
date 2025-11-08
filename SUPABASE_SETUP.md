# 🎲 RPG D&D 5e App - Configuração Supabase

## 📋 Instruções de Setup

### 1. **Criar Projeto Supabase**
1. Acesse [supabase.com/dashboard](https://supabase.com/dashboard)
2. Clique em "New Project"
3. Escolha uma organização/crie uma nova
4. Configure:
   - **Name**: `rpg-dnd-5e-app`
   - **Database Password**: (anote esta senha)
   - **Region**: escolha a mais próxima (ex: South America)
5. Clique "Create new project" (demora ~2 minutos)

### 2. **Obter Credenciais**
1. No dashboard do projeto, vá em **Settings** → **API**
2. Copie:
   - **Project URL** (ex: `https://abcxyzcompany.supabase.co`)
   - **anon public** key (chave pública, pode ser exposta)

### 3. **Configurar Credenciais no App**
Edite o arquivo `lib/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String url = 'https://SEU_PROJETO.supabase.co'; // ← Cole sua URL
  static const String anonKey = 'SUA_ANON_KEY_AQUI'; // ← Cole sua chave anônima
  
  static const bool enableDebug = true; // ← Mude para false em produção
  static const Duration timeout = Duration(seconds: 30);
}
```

### 4. **Criar Tabelas no Banco**
1. No dashboard Supabase, vá em **SQL Editor**
2. Clique "New query"
3. **Cole e execute** os SQLs abaixo (um por vez):

#### **4.1 Tabela de Personagens:**
```sql
-- Tabela de personagens D&D 5e
CREATE TABLE IF NOT EXISTS personagens (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  nome TEXT NOT NULL,
  classe TEXT NOT NULL,
  raca TEXT NOT NULL,
  nivel INTEGER DEFAULT 1 CHECK (nivel >= 1 AND nivel <= 20),
  
  -- Atributos D&D 5e
  forca INTEGER DEFAULT 10 CHECK (forca >= 3 AND forca <= 20),
  destreza INTEGER DEFAULT 10 CHECK (destreza >= 3 AND destreza <= 20),
  constituicao INTEGER DEFAULT 10 CHECK (constituicao >= 3 AND constituicao <= 20),
  inteligencia INTEGER DEFAULT 10 CHECK (inteligencia >= 3 AND inteligencia <= 20),
  sabedoria INTEGER DEFAULT 10 CHECK (sabedoria >= 3 AND sabedoria <= 20),
  carisma INTEGER DEFAULT 10 CHECK (carisma >= 3 AND carisma <= 20),
  
  -- Informações adicionais
  historia TEXT,
  imagem_url TEXT,
  
  -- Stats calculados
  pontos_vida INTEGER,
  classe_armadura INTEGER DEFAULT 10,
  velocidade INTEGER DEFAULT 30,
  
  -- Metadados
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);
```

#### **4.2 Configurar Row Level Security (RLS):**
```sql
-- RLS (Row Level Security) - Cada usuário vê apenas seus personagens
ALTER TABLE personagens ENABLE ROW LEVEL SECURITY;

-- Policy: Usuários podem ver apenas seus próprios personagens
CREATE POLICY "Usuários podem ver seus próprios personagens" ON personagens
  FOR SELECT USING (auth.uid() = user_id);

-- Policy: Usuários podem inserir apenas personagens para si mesmos
CREATE POLICY "Usuários podem criar personagens para si mesmos" ON personagens
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy: Usuários podem atualizar apenas seus próprios personagens
CREATE POLICY "Usuários podem atualizar seus próprios personagens" ON personagens
  FOR UPDATE USING (auth.uid() = user_id);

-- Policy: Usuários podem deletar apenas seus próprios personagens
CREATE POLICY "Usuários podem deletar seus próprios personagens" ON personagens
  FOR DELETE USING (auth.uid() = user_id);
```

#### **4.3 Trigger para updated_at:**
```sql
-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_personagens_updated_at BEFORE UPDATE ON personagens
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
```

### 5. **Configurar Autenticação**
1. Vá em **Authentication** → **Settings**
2. Configure:
   - **Enable email confirmations**: ✅ Ativado (recomendado)
   - **Enable email change confirmations**: ✅ Ativado
   - **Enable phone confirmations**: ❌ Desativado (opcional)

### 6. **Testar Funcionamento**
1. Execute o app: `flutter run`
2. Teste o cadastro de novo usuário
3. Teste login com as credenciais criadas
4. Crie um personagem e verifique se aparece na lista
5. Verifique se outros usuários não veem seus personagens

## 🔐 **Segurança (RLS)**
O sistema implementa **Row Level Security** que garante:
- ✅ Cada usuário vê apenas seus próprios personagens
- ✅ Não é possível acessar dados de outros usuários
- ✅ Todas operações (SELECT, INSERT, UPDATE, DELETE) são protegidas
- ✅ Segurança aplicada no nível do banco, não apenas no app

## 🎯 **Funcionalidades Implementadas**
- ✅ **Cadastro/Login** com Supabase Auth
- ✅ **Criação de personagens** D&D 5e completos
- ✅ **Lista de personagens** com filtros e busca
- ✅ **Edição de personagens** em tempo real
- ✅ **Exclusão de personagens** com confirmação
- ✅ **Cálculos automáticos** (HP, CA, modificadores)
- ✅ **Real-time updates** (mudanças aparecem instantaneamente)
- ✅ **Dados por usuário** (privacidade garantida)

## 🚀 **Próximos Passos**
- [ ] Implementar upload de imagens de personagens
- [ ] Sistema de magias por personagem
- [ ] Sessões multiplayer de RPG
- [ ] Sistema de grupos/campanhas
- [ ] Fichas de personagem em PDF

## 🆘 **Troubleshooting**

### Erro: "Invalid API key"
- Verifique se copiou a **anon key** correta
- Certifique-se que não há espaços extras

### Erro: "Failed to connect"
- Verifique se a **URL** está correta
- Teste a conexão de internet
- Verifique se o projeto Supabase está ativo

### Personagens não aparecem
- Verifique se o RLS foi configurado corretamente
- Teste se o usuário está logado (`AuthService.isLoggedIn`)
- Verifique os logs no Supabase Dashboard → **Logs**

### Erro de permissão
- Confirme que as **Policies** foram criadas
- Verifique se `auth.uid()` retorna o ID do usuário
- Teste com dados de exemplo via SQL Editor

## 📞 **Suporte**
Em caso de dúvidas:
1. Consulte a [documentação oficial do Supabase](https://supabase.com/docs)
2. Verifique os logs no Dashboard do Supabase
3. Use `SupabaseConfig.enableDebug = true` para debug detalhado