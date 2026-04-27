-- ============================================================
--  Capacita CFTI — Centro de Formação em Tecnologias de Informação
--  Laboratório 2 — Módulo 6
--  banco.sql — Estrutura completa da base de dados
-- ============================================================

DROP DATABASE bd_inscricoes;

CREATE DATABASE bd_inscricoes
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bd_inscricoes;

-- ============================================================
--  TABELA: utilizadores
--  Contas de acesso à área administrativa
-- ============================================================
CREATE TABLE utilizadores (
    id              INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    nome_utilizador VARCHAR(60)     NOT NULL,
    senha_hash      VARCHAR(255)    NOT NULL,           -- recomenda-se a encriptar
    telefone        VARCHAR(30)     NULL,
    cargo           VARCHAR(100)    NULL,
    perfil          ENUM(
                        'administrador',
                        'gestor',
                        'secretaria'
                    )               NOT NULL DEFAULT 'gestor',
    estado          ENUM(
                        'activo',
                        'inactivo'
                    )               NOT NULL DEFAULT 'activo',
    criado_em       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_em  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_email           (email),
    UNIQUE KEY uq_nome_utilizador (nome_utilizador)
);

-- Utilizador administrador inicial
INSERT INTO utilizadores (nome, email, nome_utilizador, senha_hash, cargo, perfil, estado)
VALUES (
    'Administrador',
    'admin@capacitacfti.ao',
    'admin',
    '1234567890',   -- substituir por um hash real em produção
    'Gestor do sistema',
    'administrador',
    'activo'
);


-- ============================================================
--  TABELA: cursos
--  Oferta formativa do centro
-- ============================================================
CREATE TABLE cursos (
    id              INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    emoji           VARCHAR(20)     NOT NULL DEFAULT '',
    nome            VARCHAR(150)    NOT NULL,
    subtitulo       VARCHAR(200)    NOT NULL DEFAULT '',  -- ex: "HTML, CSS, JavaScript"
    area            VARCHAR(100)    NOT NULL,             -- ex: "Tecnologia Web"
    duracao         VARCHAR(30)     NOT NULL,             -- ex: "4 meses"
    modalidade      ENUM(
                        'Presencial',
                        'Online',
                        'Híbrido'
                    )               NOT NULL DEFAULT 'Presencial',
    vagas           INT UNSIGNED NOT NULL DEFAULT 20,
    estado          ENUM(
                        'activo',
                        'em-breve',
                        'inactivo'
                    )               NOT NULL DEFAULT 'activo',
    inicio          DATE            NULL,
    horario         VARCHAR(60)     NOT NULL DEFAULT '',  -- ex: "Manhã (08h–12h)"
    preco           DECIMAL(10,2) UNSIGNED NOT NULL DEFAULT 0.00,
    criado_em       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_em  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id)
);

-- Dados iniciais dos cursos
INSERT INTO cursos (emoji, nome, subtitulo, area, duracao, modalidade, vagas, estado, inicio, horario, preco) VALUES
('🖥️', 'Desenvolvimento Web Frontend', 'HTML, CSS, JavaScript & Frameworks', 'Tecnologia Web', '4 meses', 'Presencial', 20, 'activo', '2025-01-15', 'Manhã (08h–12h)',  45000.00),
('⚙️', 'Desenvolvimento Backend',       'Node.js, Python, APIs REST',         'Tecnologia Web', '5 meses', 'Presencial', 20, 'activo', '2025-01-15', 'Tarde (14h–18h)',  55000.00),
('🗄️', 'Base de Dados e SQL',           'MySQL, PostgreSQL, Modelagem',       'Dados',          '3 meses', 'Presencial', 25, 'activo', '2025-02-01', 'Manhã (08h–12h)',  35000.00),
('🎨', 'Design de Interfaces (UI/UX)',   'Figma, Prototipagem, Usabilidade',   'Design',         '3 meses', 'Online',     30, 'activo', '2025-01-20', 'Flexível',         30000.00),
('🌐', 'Redes e Infraestrutura',         'TCP/IP, Servidores, Linux',          'Infraestrutura', '4 meses', 'Presencial', 20, 'activo', '2025-02-10', 'Tarde (14h–18h)',  40000.00),
('🔐', 'Cibersegurança Básica',          'Segurança, Criptografia, Protecção', 'Segurança',      '3 meses', 'Online',     25, 'activo', '2025-02-15', 'Flexível',         35000.00);


-- ============================================================
--  TABELA: formandos
--  Inscrições submetidas pelo formulário público
-- ============================================================
CREATE TABLE formandos (
    id                  INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    numero_inscricao    VARCHAR(20)     NOT NULL,          -- ex: "INS-2025-10001"
    nome                VARCHAR(150)    NOT NULL,
    email               VARCHAR(150)    NOT NULL,
    telefone            VARCHAR(30)     NOT NULL,
    documento           VARCHAR(40)     NOT NULL,          -- BI ou passaporte
    data_nascimento     DATE            NULL,
    escolaridade        VARCHAR(60)     NOT NULL DEFAULT '',
    morada              VARCHAR(200)    NOT NULL DEFAULT '',
    curso_id            INT UNSIGNED    NOT NULL,
    estado              ENUM(
                            'pendente',
                            'aprovado',
                            'rejeitado'
                        )               NOT NULL DEFAULT 'pendente',
    criado_em           TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_em      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_numero_inscricao (numero_inscricao),
    CONSTRAINT fk_formando_curso
        FOREIGN KEY (curso_id)
        REFERENCES cursos (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT      -- impede eliminar curso com inscrições
);

-- Dados de exemplo
INSERT INTO formandos (numero_inscricao, nome, email, telefone, documento, escolaridade, morada, curso_id, estado) VALUES
('INS-2025-10001', 'Ana Cristina Monteiro',   'ana.monteiro@email.com',     '923 111 222', '005123456LA041', 'Licenciatura',             'Bairro Miramar, Luanda',   1, 'aprovado'),
('INS-2025-10002', 'Carlos Eduardo Ferreira', 'carlos.ferreira@email.com',  '924 333 444', '006234567LA042', 'Bacharel',                  'Viana, Luanda',            2, 'aprovado'),
('INS-2025-10003', 'Maria da Graça Santos',   'maria.santos@email.com',     '925 555 666', '007345678LA043', 'Ensino Secundário',         'Cazenga, Luanda',          3, 'pendente'),
('INS-2025-10004', 'João Paulo Lopes',        'joao.lopes@email.com',       '922 777 888', '008456789LA044', 'Licenciatura',              'Talatona, Luanda',         4, 'aprovado'),
('INS-2025-10005', 'Beatriz Simões Neves',    'beatriz.neves@email.com',    '921 999 000', '009567890LA045', 'Bacharel',                  'Kilamba, Luanda',          5, 'pendente'),
('INS-2025-10006', 'Pedro António Vaz',       'pedro.vaz@email.com',        '926 123 456', '010678901LA046', 'Ensino Secundário',         'Sambizanga, Luanda',       6, 'rejeitado'),
('INS-2025-10007', 'Filomena Cruz Teixeira',  'filomena.teixeira@email.com','927 234 567', '011789012LA047', 'Licenciatura',              'Cacuaco, Luanda',          1, 'aprovado'),
('INS-2025-10008', 'António José Rodrigues',  'antonio.rodrigues@email.com','928 345 678', '012890123LA048', 'Pós-graduação / Mestrado',  'Maianga, Luanda',          2, 'aprovado'),
('INS-2025-10009', 'Conceição Lima Pereira',  'conceicao.pereira@email.com','929 456 789', '013901234LA049', 'Bacharel',                  'Ingombota, Luanda',        3, 'pendente'),
('INS-2025-10010', 'Rui Sérgio Mendes',       'rui.mendes@email.com',       '923 567 890', '014012345LA050', 'Licenciatura',              'Samba, Luanda',            4, 'aprovado');

