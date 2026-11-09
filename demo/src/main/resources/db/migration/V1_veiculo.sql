CREATE TABLE veiculo (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    placa                       VARCHAR(8)     NOT NULL UNIQUE,
    marca                       VARCHAR(60)    NOT NULL,
    modelo                      VARCHAR(60)    NOT NULL,
    ano                         INTEGER        NOT NULL,

    -- Dimensões internas do baú (mm): base do cálculo de volume e de encaixe
    bau_comprimento_mm          INTEGER        NOT NULL CHECK (bau_comprimento_mm > 0),
    bau_largura_mm              INTEGER        NOT NULL CHECK (bau_largura_mm > 0),
    bau_altura_mm               INTEGER        NOT NULL CHECK (bau_altura_mm > 0),

    -- Pesos (kg)
    peso_vazio_kg               NUMERIC(10,2)  NOT NULL CHECK (peso_vazio_kg > 0),
    capacidade_carga_kg         NUMERIC(10,2)  NOT NULL CHECK (capacidade_carga_kg > 0),

    -- Cálculo de peso por eixo
    limite_eixo_dianteiro_kg    NUMERIC(10,2)  NOT NULL CHECK (limite_eixo_dianteiro_kg > 0),
    limite_eixo_traseiro_kg     NUMERIC(10,2)  NOT NULL CHECK (limite_eixo_traseiro_kg > 0),
    tara_eixo_dianteiro_kg      NUMERIC(10,2)  NOT NULL CHECK (tara_eixo_dianteiro_kg >= 0), -- peso do caminhão vazio sobre o eixo dianteiro
    tara_eixo_traseiro_kg       NUMERIC(10,2)  NOT NULL CHECK (tara_eixo_traseiro_kg >= 0),  -- idem, eixo traseiro
    distancia_entre_eixos_mm    INTEGER        NOT NULL CHECK (distancia_entre_eixos_mm > 0),
    bau_inicio_apos_eixo_dianteiro_mm INTEGER  NOT NULL DEFAULT 0,  -- distância do eixo dianteiro até o início do baú

    -- Consumo e estado atual (usados nas rotas e, depois, na manutenção)
    consumo_medio_km_l          NUMERIC(5,2)   NOT NULL CHECK (consumo_medio_km_l > 0),
    odometro_km                 NUMERIC(12,1)  NOT NULL DEFAULT 0,
    horas_motor                 NUMERIC(10,1)  NOT NULL DEFAULT 0,
    ativo                       BOOLEAN        NOT NULL DEFAULT TRUE
);