-- ============================================================
--  JOUR 6 / 10 DAYS OF SQL — CASE WHEN
--  Concepts : CASE simple · CASE avec conditions · Pivot manuel
--             CASE dans GROUP BY · CASE dans ORDER BY
-- ============================================================

-- ── 1. CASE WHEN simple : créer une catégorie ───────────────
-- Classer les commandes par taille
SELECT
    client,
    montant,
    CASE
        WHEN montant < 500 THEN 'Petite'
        WHEN montant < 3000 THEN 'Moyenne'
        ELSE 'Grosse'
    END AS taille_commande
FROM commandes
ORDER BY montant DESC;


-- ── 2. CASE WHEN avec plusieurs conditions (AND/OR) ─────────
-- Segmenter par âge ET montant
SELECT
    client,
    age_client,
    montant,
    CASE
        WHEN age_client < 30 AND montant > 2000 THEN 'Jeune gros acheteur'
        WHEN age_client < 30 THEN 'Jeune'
        WHEN age_client >= 50 AND montant > 5000 THEN 'Senior premium'
        WHEN age_client >= 50 THEN 'Senior'
        ELSE 'Standard'
    END AS segment
FROM commandes
ORDER BY age_client;


-- ── 3. CASE WHEN dans une agrégation (COUNT conditionnel) ───
-- Compter les commandes par statut, en colonnes (pivot manuel)
SELECT
    client,
    COUNT(*) AS total_commandes,
    SUM(CASE WHEN statut = 'livree'  THEN 1 ELSE 0 END) AS nb_livrees,
    SUM(CASE WHEN statut = 'en_cours' THEN 1 ELSE 0 END) AS nb_en_cours,
    SUM(CASE WHEN statut = 'annulee' THEN 1 ELSE 0 END) AS nb_annulees
FROM commandes
GROUP BY client
ORDER BY total_commandes DESC;

-- Pattern "pivot manuel" : transforme des LIGNES (statuts) en COLONNES
-- Très utilisé pour des rapports type tableau croisé


-- ── 4. SUM(CASE WHEN ...) pour des totaux conditionnels ─────
-- Chiffre d'affaires livré vs en attente vs perdu
SELECT
    region,
    SUM(CASE WHEN statut = 'livree'   THEN montant ELSE 0 END) AS ca_livre,
    SUM(CASE WHEN statut = 'en_cours' THEN montant ELSE 0 END) AS ca_en_attente,
    SUM(CASE WHEN statut = 'annulee'  THEN montant ELSE 0 END) AS ca_perdu
FROM commandes
GROUP BY region
ORDER BY ca_livre DESC;


-- ── 5. CASE WHEN dans GROUP BY : grouper par catégorie calculée ─
-- Nombre de commandes par tranche de montant
SELECT
    CASE
        WHEN montant < 500 THEN '1. Petite (< 500€)'
        WHEN montant < 3000 THEN '2. Moyenne (500-3000€)'
        ELSE '3. Grosse (> 3000€)'
    END AS tranche,
    COUNT(*) AS nb_commandes,
    SUM(montant) AS ca_total
FROM commandes
GROUP BY tranche
ORDER BY tranche;

-- Astuce : préfixer les labels avec 1./2./3. force l'ordre alphabétique
-- à correspondre à l'ordre logique métier


-- ── 6. CASE WHEN dans ORDER BY : tri personnalisé ───────────
-- Trier par statut dans un ordre métier précis (pas alphabétique)
SELECT
    client,
    statut,
    montant
FROM commandes
ORDER BY
    CASE statut
        WHEN 'en_cours' THEN 1
        WHEN 'livree'   THEN 2
        WHEN 'annulee'  THEN 3
    END,
    montant DESC;

-- Sans ce CASE, ORDER BY statut trierait alphabétiquement :
-- annulee, en_cours, livree — pas l'ordre qu'on veut métier


-- ── 7. CASE WHEN imbriqué (nested) ──────────────────────────
-- Calcul de remise selon plusieurs règles imbriquées
SELECT
    client,
    montant,
    statut,
    CASE
        WHEN statut = 'annulee' THEN 0
        ELSE
            CASE
                WHEN montant > 10000 THEN montant * 0.15
                WHEN montant > 5000  THEN montant * 0.10
                WHEN montant > 1000  THEN montant * 0.05
                ELSE 0
            END
    END AS remise_calculee
FROM commandes
ORDER BY remise_calculee DESC;


-- ── 8. CASE WHEN avec valeurs NULL ──────────────────────────
-- Gérer les cas où une valeur pourrait être NULL
SELECT
    client,
    montant,
    CASE
        WHEN montant IS NULL THEN 'Non renseigné'
        WHEN montant = 0 THEN 'Gratuit'
        ELSE 'Payant : ' || montant || '€'
    END AS affichage_montant
FROM commandes;


-- ── 9. CASE WHEN pour transformer un format ──────────────────
-- Convertir le statut technique en libellé français lisible
SELECT
    client,
    statut AS statut_technique,
    CASE statut
        WHEN 'livree'   THEN '✓ Livrée'
        WHEN 'en_cours' THEN '⏳ En cours'
        WHEN 'annulee'  THEN '✗ Annulée'
        ELSE 'Statut inconnu'
    END AS statut_affiche
FROM commandes;

-- Cette forme CASE colonne WHEN valeur THEN résultat
-- est plus courte quand on compare UNE colonne à des valeurs exactes


-- ── 10. REQUÊTE COMPLÈTE — Rapport de segmentation client ───
WITH stats_client AS (
    SELECT
        client,
        COUNT(*) AS nb_commandes,
        SUM(montant) AS ca_total,
        AVG(montant) AS panier_moyen,
        SUM(CASE WHEN statut = 'annulee' THEN 1 ELSE 0 END) AS nb_annulations
    FROM commandes
    GROUP BY client
)
SELECT
    client,
    nb_commandes,
    ca_total,
    ROUND(panier_moyen, 0) AS panier_moyen,
    CASE
        WHEN ca_total > 10000 THEN 'VIP'
        WHEN ca_total > 3000  THEN 'Fidèle'
        WHEN nb_annulations > 0 AND ca_total < 1000 THEN 'À risque'
        ELSE 'Standard'
    END AS segment_client
FROM stats_client
ORDER BY ca_total DESC;
