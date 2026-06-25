-- ============================================================
--  JOUR 6 / 10 DAYS OF SQL — Setup : CASE WHEN
--  Table : clients (commandes clients avec montants variés)
-- ============================================================

DROP TABLE IF EXISTS commandes;

CREATE TABLE commandes (
    id              INTEGER PRIMARY KEY,
    client          TEXT NOT NULL,
    date_commande   DATE NOT NULL,
    montant         INTEGER NOT NULL,
    statut          TEXT NOT NULL,     -- 'livree', 'en_cours', 'annulee'
    region          TEXT NOT NULL,
    age_client      INTEGER NOT NULL
);

INSERT INTO commandes (id, client, date_commande, montant, statut, region, age_client) VALUES
(1,  'Dupont SA',      '2024-01-05',  3600, 'livree',   'Île-de-France', 45),
(2,  'Martin Co',      '2024-01-07',   850, 'livree',   'PACA',          29),
(3,  'TechStart',      '2024-01-10',   120, 'annulee',  'Grand Est',     34),
(4,  'Innovation Lab', '2024-01-12',  7200, 'livree',   'Île-de-France', 52),
(5,  'DataCorp',       '2024-01-15',  2400, 'en_cours', 'Auvergne',      38),
(6,  'NovaTech',       '2024-01-18',   45,  'livree',   'Grand Est',     22),
(7,  'Digital Hub',    '2024-01-20',  5800, 'livree',   'PACA',          61),
(8,  'SmartSol',       '2024-02-02',  1900, 'annulee',  'Occitanie',     27),
(9,  'WebAgency',      '2024-02-05',   320, 'livree',   'Hauts-de-France', 19),
(10, 'Dupont SA',      '2024-02-08', 12000, 'livree',   'Île-de-France', 45),
(11, 'Martin Co',      '2024-02-10',   680, 'en_cours', 'PACA',          29),
(12, 'TechStart',      '2024-02-13',  3200, 'livree',   'Grand Est',     34),
(13, 'Innovation Lab', '2024-02-15',   95,  'livree',   'Île-de-France', 52),
(14, 'DataCorp',       '2024-02-20',  4500, 'livree',   'Auvergne',      38),
(15, 'NovaTech',       '2024-03-01',  8900, 'livree',   'Grand Est',     22),
(16, 'Digital Hub',    '2024-03-04',   210, 'annulee',  'PACA',          61),
(17, 'SmartSol',       '2024-03-07',  1500, 'en_cours', 'Occitanie',     27),
(18, 'WebAgency',      '2024-03-12',  6700, 'livree',   'Hauts-de-France', 19),
(19, 'Dupont SA',      '2024-03-15',   380, 'livree',   'Île-de-France', 45),
(20, 'Martin Co',      '2024-03-18',  2100, 'livree',   'PACA',          29),
(21, 'TechStart',      '2024-04-02',  9500, 'livree',   'Grand Est',     34),
(22, 'Innovation Lab', '2024-04-05',   150, 'annulee',  'Île-de-France', 52),
(23, 'DataCorp',       '2024-04-10',  3300, 'livree',   'Auvergne',      38),
(24, 'NovaTech',       '2024-04-15',   720, 'en_cours', 'Grand Est',     22),
(25, 'Digital Hub',    '2024-04-18', 15000, 'livree',   'PACA',          61);
