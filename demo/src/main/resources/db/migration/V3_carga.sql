CREATE TABLE plano_carregamento (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descricao   VARCHAR(150) NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'RASCUNHO'
                CHECK (status IN ('RASCUNHO', 'CALCULADO')),
    criado_em   TIMESTAMP    NOT NULL DEFAULT NOW()
);

-- A parte do plano que vai em UM caminhão
CREATE TABLE carga (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plano_id    BIGINT       NOT NULL REFERENCES plano_carregamento(id) ON DELETE CASCADE,
    veiculo_id  BIGINT       NOT NULL REFERENCES veiculo(id),
    status      VARCHAR(20)  NOT NULL DEFAULT 'RASCUNHO'
                CHECK (status IN ('RASCUNHO', 'CALCULADA', 'DESPACHADA')),

    -- Resultados do cálculo
    peso_total_kg            NUMERIC(10,2),
    volume_ocupado_pct       NUMERIC(5,2),
    peso_eixo_dianteiro_kg   NUMERIC(10,2),
    peso_eixo_traseiro_kg    NUMERIC(10,2),

    criada_em   TIMESTAMP    NOT NULL DEFAULT NOW(),
    UNIQUE (plano_id, veiculo_id)      -- o mesmo caminhão não aparece duas vezes no plano
);
CREATE INDEX idx_carga_plano ON carga (plano_id);

CREATE TABLE item_carga (
    id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plano_id          BIGINT        NOT NULL REFERENCES plano_carregamento(id) ON DELETE CASCADE,
    carga_id          BIGINT        REFERENCES carga(id),   -- só preenchido quando o item é alocado a um caminhão
    descricao         VARCHAR(150)  NOT NULL,

    comprimento_mm    INTEGER       NOT NULL CHECK (comprimento_mm > 0),
    largura_mm        INTEGER       NOT NULL CHECK (largura_mm > 0),
    altura_mm         INTEGER       NOT NULL CHECK (altura_mm > 0),
    peso_kg           NUMERIC(10,2) NOT NULL CHECK (peso_kg > 0),
    empilhavel        BOOLEAN       NOT NULL DEFAULT TRUE,

    -- Resultado da alocação
    status_alocacao   VARCHAR(15)   NOT NULL DEFAULT 'PENDENTE'
                      CHECK (status_alocacao IN ('PENDENTE', 'ALOCADO', 'NAO_ALOCADO')),
    motivo_nao_alocado VARCHAR(255),

    -- Posição dentro do baú (canto inferior do item)
    pos_x_mm          INTEGER,
    pos_y_mm          INTEGER,
    pos_z_mm          INTEGER,
    rotacionado       BOOLEAN       NOT NULL DEFAULT FALSE,

    -- Um item tem carga se, e somente se, estiver ALOCADO
    CHECK ((status_alocacao = 'ALOCADO') = (carga_id IS NOT NULL))
);
CREATE INDEX idx_item_carga_plano ON item_carga (plano_id);
CREATE INDEX idx_item_carga_carga ON item_carga (carga_id);