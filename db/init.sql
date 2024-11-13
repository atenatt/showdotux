CREATE TABLE IF NOT EXISTS jogadores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL,
    pontuacao INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS categorias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO categorias (nome) VALUES ('devops'), ('linux'), ('redes')
ON CONFLICT (nome) DO NOTHING;

CREATE TABLE IF NOT EXISTS perguntas (
    id SERIAL PRIMARY KEY,
    categoria_id INT REFERENCES categorias(id),
    enunciado TEXT NOT NULL,
    opcao_a TEXT NOT NULL,
    opcao_b TEXT NOT NULL,
    opcao_c TEXT NOT NULL,
    opcao_d TEXT NOT NULL,
    resposta_correta CHAR(1) NOT NULL
);
