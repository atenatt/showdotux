FROM postgres:latest

# Copiar os arquivos de inicialização e garantir a ordem de execução
COPY init.sql /docker-entrypoint-initdb.d/01-init.sql
COPY perguntas.yaml /docker-entrypoint-initdb.d/perguntas.yaml
COPY configs/import_questions.sh /docker-entrypoint-initdb.d/02-import_questions.sh

# Ajustar permissões para os scripts e arquivos
RUN chmod +x /docker-entrypoint-initdb.d/02-import_questions.sh && \
    touch /docker-entrypoint-initdb.d/03-import_questions.sql && \
    chmod 666 /docker-entrypoint-initdb.d/03-import_questions.sql && \
    chmod 644 /docker-entrypoint-initdb.d/perguntas.yaml
