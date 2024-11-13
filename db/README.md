# Banco de Dados - Show do Tux 🗄️

Este diretório contém tudo o que é necessário para configurar o banco de dados PostgreSQL do jogo **Show do Tux**.

## Estrutura

```
db/
├── init.sql               # Script de criação e inicialização das tabelas
├── perguntas.yaml         # Arquivo YAML com perguntas e respostas
├── configs
│   └── import_questions.sh # Script para importar perguntas do YAML para o banco
└── Dockerfile             # Dockerfile para configuração do contêiner PostgreSQL
```

## Configuração

### Estrutura das Tabelas

O banco de dados possui duas tabelas principais:

- **categorias**:
  - `id` SERIAL PRIMARY KEY
  - `nome` VARCHAR(50) UNIQUE NOT NULL

- **perguntas**:
  - `id` SERIAL PRIMARY KEY
  - `categoria` VARCHAR(50) NOT NULL
  - `enunciado` TEXT NOT NULL
  - `opcao_a` TEXT NOT NULL
  - `opcao_b` TEXT NOT NULL
  - `opcao_c` TEXT NOT NULL
  - `opcao_d` TEXT NOT NULL
  - `resposta_correta` CHAR(1) NOT NULL

### Arquivo `perguntas.yaml`

Este arquivo contém as perguntas e respostas em formato YAML. Exemplo:

```yaml
- categoria: linux
  enunciado: Qual comando exibe o diretório atual?
  opcao_a: ls
  opcao_b: pwd
  opcao_c: cd
  opcao_d: dir
  resposta_correta: B

- categoria: redes
  enunciado: Qual é o protocolo usado para resolver endereços IP a partir de nomes de domínio?
  opcao_a: HTTP
  opcao_b: DNS
  opcao_c: FTP
  opcao_d: SSH
  resposta_correta: B
```

### Script `import_questions.sh`

Este script lê o arquivo `perguntas.yaml` e converte cada entrada em um comando SQL `INSERT INTO` para popular a tabela `perguntas`.

## Dockerfile

O Dockerfile configura um contêiner PostgreSQL e automatiza o processo de inicialização:

```Dockerfile
FROM postgres:latest

# Copia os arquivos necessários
COPY init.sql /docker-entrypoint-initdb.d/
COPY perguntas.yaml /docker-entrypoint-initdb.d/
COPY configs/import_questions.sh /docker-entrypoint-initdb.d/

# Ajusta permissões e executa o script de importação
RUN chmod +x /docker-entrypoint-initdb.d/import_questions.sh
```

## Como Usar

1. **Construir e Subir o Contêiner do Banco de Dados**:
   ```bash
   docker-compose up -d db
   ```

2. **Verificar as Tabelas e Dados**:
   ```bash
   docker exec -it showdotux-db-1 psql -U tux -d game -c "\d perguntas"
   docker exec -it showdotux-db-1 psql -U tux -d game -c "SELECT * FROM perguntas;"
   ```

## Notas

- **YAML**: Certifique-se de que o arquivo `perguntas.yaml` esteja corretamente formatado.
- **SQL**: O script de importação escapa caracteres especiais para evitar erros.

## Licença

Este projeto é open-source sob a licença MIT.