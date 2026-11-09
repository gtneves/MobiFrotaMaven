CREATE TABLE motorista (
    id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome            VARCHAR(120) NOT NULL,
    cnh             VARCHAR(20)  NOT NULL UNIQUE,
    categoria_cnh   VARCHAR(3)   NOT NULL,
    validade_cnh    DATE         NOT NULL,
    ativo           BOOLEAN      NOT NULL DEFAULT TRUE
);
