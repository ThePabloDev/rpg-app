/// Configuração do Supabase
/// Substitua pelas suas credenciais do projeto Supabase
class SupabaseConfig {
  // 🔑 CONFIGURE SUAS CREDENCIAIS AQUI:
  // 1. Crie projeto em https://supabase.com/dashboard
  // 2. Vá em Settings > API
  // 3. Copie a URL do projeto e anon key
  
  static const String url = 'https://wfqlhrqqjheohumrdvzm.supabase.co'; // ex: https://xyzcompany.supabase.co
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmcWxocnFxamhlb2h1bXJkdnptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg1NjY2OTksImV4cCI6MjA3NDE0MjY5OX0.nGkRfdFx5nNS36C9PGZAyrPdTnotuw0sG98hjrq55RY'; // chave anônima pública
  
  // Configurações opcionais
  static const bool enableDebug = true;
  static const Duration timeout = Duration(seconds: 30);
}

/// Tabelas do banco de dados
class SupabaseTables {
  static const String users = 'auth.users'; // Tabela de usuários (built-in)
  static const String personagens = 'personagens';
  static const String magias = 'magias';
  static const String personagemMagias = 'personagem_magias';
}

/// Schemas SQL para criação das tabelas
/// Execute estes comandos no SQL Editor do Supabase Dashboard
class SupabaseSchemas {
  /// Schema para tabela de personagens
  static const String createPersonagensTable = '''
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

    -- Trigger para atualizar updated_at automaticamente
    CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS \$\$
    BEGIN
        NEW.updated_at = TIMEZONE('utc'::text, NOW());
        RETURN NEW;
    END;
    \$\$ language 'plpgsql';

    CREATE TRIGGER update_personagens_updated_at BEFORE UPDATE ON personagens
      FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
  ''';

  /// Schema para tabela de magias (opcional - dados estáticos)
  static const String createMagiasTable = '''
    -- Tabela de magias D&D 5e (dados estáticos/compartilhados)
    CREATE TABLE IF NOT EXISTS magias (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      nome TEXT NOT NULL,
      nivel INTEGER NOT NULL CHECK (nivel >= 0 AND nivel <= 9),
      escola TEXT NOT NULL, -- Evocação, Encantamento, etc.
      tempo_conjuracao TEXT NOT NULL,
      alcance TEXT NOT NULL,
      componentes TEXT NOT NULL,
      duracao TEXT NOT NULL,
      descricao TEXT NOT NULL,
      classes TEXT[], -- Array de classes que podem usar a magia
      
      created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
    );

    -- RLS desabilitado - magias são públicas/compartilhadas
    ALTER TABLE magias DISABLE ROW LEVEL SECURITY;
  ''';

  /// Schema para relacionamento personagem-magias
  static const String createPersonagemMagiasTable = '''
    -- Tabela de relacionamento: quais magias cada personagem conhece
    CREATE TABLE IF NOT EXISTS personagem_magias (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      personagem_id UUID REFERENCES personagens(id) ON DELETE CASCADE,
      magia_id UUID REFERENCES magias(id) ON DELETE CASCADE,
      
      -- Metadados específicos do personagem
      preparada BOOLEAN DEFAULT false,
      slots_gastos INTEGER DEFAULT 0,
      
      created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
      
      -- Constraint: um personagem não pode ter a mesma magia duas vezes
      UNIQUE(personagem_id, magia_id)
    );

    -- RLS: Usuários só veem magias de seus personagens
    ALTER TABLE personagem_magias ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "Usuários veem magias de seus personagens" ON personagem_magias
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM personagens 
          WHERE personagens.id = personagem_magias.personagem_id 
          AND personagens.user_id = auth.uid()
        )
      );

    CREATE POLICY "Usuários podem adicionar magias aos seus personagens" ON personagem_magias
      FOR INSERT WITH CHECK (
        EXISTS (
          SELECT 1 FROM personagens 
          WHERE personagens.id = personagem_magias.personagem_id 
          AND personagens.user_id = auth.uid()
        )
      );

    CREATE POLICY "Usuários podem atualizar magias de seus personagens" ON personagem_magias
      FOR UPDATE USING (
        EXISTS (
          SELECT 1 FROM personagens 
          WHERE personagens.id = personagem_magias.personagem_id 
          AND personagens.user_id = auth.uid()
        )
      );

    CREATE POLICY "Usuários podem remover magias de seus personagens" ON personagem_magias
      FOR DELETE USING (
        EXISTS (
          SELECT 1 FROM personagens 
          WHERE personagens.id = personagem_magias.personagem_id 
          AND personagens.user_id = auth.uid()
        )
      );
  ''';
}