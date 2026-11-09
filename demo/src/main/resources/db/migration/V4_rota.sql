CREATE TABLE rota (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    veiculo_id              BIGINT        NOT NULL REFERENCES veiculo(id),
    motorista_id            BIGINT        REFERENCES motorista(id),
    carga_id                BIGINT        UNIQUE REFERENCES carga(id),   -- no máximo uma rota por carga
    data_planejada          DATE          NOT NULL,
    status                  VARCHAR(20)   NOT NULL DEFAULT 'PLANEJADA'
                            CHECK (status IN ('PLANEJADA', 'EM_ANDAMENTO', 'CONCLUIDA')),
    distancia_total_km      NUMERIC(10,2),
    duracao_total_min       INTEGER,
    combustivel_estimado_l  NUMERIC(10,2),
    criada_em               TIMESTAMP     NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_rota_veiculo ON rota (veiculo_id);
CREATE INDEX idx_rota_data ON rota (data_planejada);