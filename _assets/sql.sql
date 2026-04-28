-- ============================================================
--  Capacita CFTI — Centro de Formação em Tecnologias de Informação
--  Laboratório 2
--  banco.sql — Estrutura completa da base de dados
-- ============================================================

DROP DATABASE IF EXISTS bd_inscricoes;

CREATE DATABASE bd_inscricoes
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bd_inscricoes;

-- ============================================================
--  TABELA: utilizadores
-- ============================================================
CREATE TABLE utilizadores (
    id              INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    nome_utilizador VARCHAR(60)     NOT NULL,
    senha_hash      VARCHAR(255)    NOT NULL,
    telefone        VARCHAR(30)     NULL,
    cargo           VARCHAR(100)    NULL,
    perfil          ENUM('administrador','gestor','secretaria')
                                    NOT NULL DEFAULT 'gestor',
    estado          ENUM('activo','inactivo')
                                    NOT NULL DEFAULT 'activo',
    criado_em       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_em  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_email           (email),
    UNIQUE KEY uq_nome_utilizador (nome_utilizador)
);

INSERT INTO utilizadores (nome, email, nome_utilizador, senha_hash, cargo, perfil, estado)
VALUES ('Administrador', 'admin@capacitacfti.ao', 'admin', '1234567890',
        'Gestor do sistema', 'administrador', 'activo');


-- ============================================================
--  TABELA: cursos
-- ============================================================
CREATE TABLE cursos (
    id              INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    emoji           VARCHAR(20)       NOT NULL DEFAULT '',
    nome            VARCHAR(150)      NOT NULL,
    subtitulo       VARCHAR(200)      NOT NULL DEFAULT '',
    area            VARCHAR(100)      NOT NULL,
    duracao         VARCHAR(30)       NOT NULL,
    modalidade      ENUM('Presencial','Online','Hibrido')
                                      NOT NULL DEFAULT 'Presencial',
    vagas           INT UNSIGNED      NOT NULL DEFAULT 20,
    estado          ENUM('activo','em-breve','inactivo')
                                      NOT NULL DEFAULT 'activo',
    inicio          DATE              NULL,
    horario         VARCHAR(60)       NOT NULL DEFAULT '',
    preco           DECIMAL(10,2) UNSIGNED NOT NULL DEFAULT 0.00,
    criado_em       TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_em  TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP
                                      ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

INSERT INTO cursos (nome, subtitulo, area, duracao, modalidade, vagas, estado, inicio, horario, preco) VALUES
('Desenvolvimento Web Frontend', 'HTML, CSS, JavaScript & Frameworks', 'Tecnologia Web', '4 meses', 'Presencial', 20, 'activo', '2025-01-15', 'Manha (08h-12h)',  45000.00),
('Desenvolvimento Backend',      'Node.js, Python, APIs REST',         'Tecnologia Web', '5 meses', 'Presencial', 20, 'activo', '2025-01-15', 'Tarde (14h-18h)',  55000.00),
('Base de Dados e SQL',          'MySQL, PostgreSQL, Modelagem',       'Dados',          '3 meses', 'Presencial', 25, 'activo', '2025-02-01', 'Manha (08h-12h)',  35000.00),
('Design de Interfaces (UI/UX)', 'Figma, Prototipagem, Usabilidade',   'Design',         '3 meses', 'Online',     30, 'activo', '2025-01-20', 'Flexivel',         30000.00),
('Redes e Infraestrutura',       'TCP/IP, Servidores, Linux',          'Infraestrutura', '4 meses', 'Presencial', 20, 'activo', '2025-02-10', 'Tarde (14h-18h)',  40000.00),
('Ciberseguranca Basica',        'Seguranca, Criptografia, Protecao',  'Seguranca',      '3 meses', 'Online',     25, 'activo', '2025-02-15', 'Flexivel',         35000.00);


-- ============================================================
--  TABELA: formandos
-- ============================================================
CREATE TABLE formandos (
    id              INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150)    NOT NULL,
    email           VARCHAR(150)    NOT NULL,
    telefone        VARCHAR(30)     NOT NULL,
    documento       VARCHAR(40)     NOT NULL,
    data_nascimento DATE            NULL,
    escolaridade    VARCHAR(60)     NOT NULL DEFAULT '',
    morada          VARCHAR(200)    NOT NULL DEFAULT '',
    criado_em       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_em  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_email     (email),
    UNIQUE KEY uq_documento (documento)
);

INSERT INTO formandos (nome, email, telefone, documento, escolaridade, morada) VALUES
('Ana Cristina Monteiro',   'ana.monteiro@email.com',      '923 111 222', '005123456LA041', 'Licenciatura',           'Bairro Miramar, Luanda'),
('Carlos Eduardo Ferreira', 'carlos.ferreira@email.com',   '924 333 444', '006234567LA042', 'Bacharel',               'Viana, Luanda'),
('Maria da Graca Santos',   'maria.santos@email.com',      '925 555 666', '007345678LA043', 'Ensino Secundario',      'Cazenga, Luanda'),
('Joao Paulo Lopes',        'joao.lopes@email.com',        '922 777 888', '008456789LA044', 'Licenciatura',           'Talatona, Luanda'),
('Beatriz Simoes Neves',    'beatriz.neves@email.com',     '921 999 000', '009567890LA045', 'Bacharel',               'Kilamba, Luanda'),
('Pedro Antonio Vaz',       'pedro.vaz@email.com',         '926 123 456', '010678901LA046', 'Ensino Secundario',      'Sambizanga, Luanda'),
('Filomena Cruz Teixeira',  'filomena.teixeira@email.com', '927 234 567', '011789012LA047', 'Licenciatura',           'Cacuaco, Luanda'),
('Antonio Jose Rodrigues',  'antonio.rodrigues@email.com', '928 345 678', '012890123LA048', 'Pos-graduacao/Mestrado', 'Maianga, Luanda'),
('Conceicao Lima Pereira',  'conceicao.pereira@email.com', '929 456 789', '013901234LA049', 'Bacharel',               'Ingombota, Luanda'),
('Rui Sergio Mendes',       'rui.mendes@email.com',        '923 567 890', '014012345LA050', 'Licenciatura',           'Samba, Luanda');


-- ============================================================
--  TABELA: inscricoes
--  Liga formandos a cursos. Guarda o acto de inscrição,
--  o estado e informação adicional.
--
--  Relações:
--    formandos 1 --- N inscricoes N --- 1 cursos
-- ============================================================
CREATE TABLE inscricoes (
    id               INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    numero_inscricao VARCHAR(20)     NOT NULL,
    formando_id      INT UNSIGNED    NOT NULL,
    curso_id         INT UNSIGNED    NOT NULL,
    estado           ENUM('pendente','aprovado','rejeitado') NOT NULL DEFAULT 'pendente',
 
    criado_em        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_em   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_numero_inscricao (numero_inscricao),

    -- impede o mesmo formando de se inscrever duas vezes no mesmo curso
    UNIQUE KEY uq_formando_curso (formando_id, curso_id),

    CONSTRAINT fk_inscricao_formando
        FOREIGN KEY (formando_id)
        REFERENCES formandos (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_inscricao_curso
        FOREIGN KEY (curso_id)
        REFERENCES cursos (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

INSERT INTO inscricoes (numero_inscricao, formando_id, curso_id, estado) VALUES
('INS-2025-10001',  1, 1, 'aprovado'),
('INS-2025-10002',  2, 2, 'aprovado'),
('INS-2025-10003',  3, 3, 'pendente'),
('INS-2025-10004',  4, 4, 'aprovado'),
('INS-2025-10005',  5, 5, 'pendente'),
('INS-2025-10006',  6, 6, 'rejeitado'),
('INS-2025-10007',  7, 1, 'aprovado'),
('INS-2025-10008',  8, 2, 'aprovado'),
('INS-2025-10009',  9, 3, 'pendente'),
('INS-2025-10010', 10, 4, 'aprovado');

