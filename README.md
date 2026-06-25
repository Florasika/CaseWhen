# 🔀 Jour 6 / 10 — SQL : CASE WHEN & Logique Conditionnelle

> **Série : 10 Days of SQL** · Jour 6/10  
> Concepts : CASE WHEN simple · CASE imbriqué · Pivot manuel · CASE dans GROUP BY / ORDER BY

---

## 📁 Structure du projet

```
day-06-case-when/
│
├── 01_setup.sql        ← CREATE TABLE commandes + 25 lignes de données
├── 02_case_when.sql    ← 10 requêtes commentées
├── clients.db           ← Base SQLite prête à l'emploi
└── README.md
```

---

## 🚀 Installation & Lancement

```bash
# Cloner le repo
git clone https://github.com/ton-pseudo/10-days-sql.git
cd 10-days-sql/day-06-case-when

# Ouvrir la base directement (déjà créée)
sqlite3 clients.db

# OU recréer la base depuis zéro
sqlite3 clients.db < 01_setup.sql

# Exécuter toutes les requêtes
sqlite3 clients.db < 02_case_when.sql
```

---

## 📊 Le schéma — table `commandes`

| Colonne | Type | Description |
|---------|------|--------------|
| `id` | INTEGER | Clé primaire |
| `client` | TEXT | 9 entreprises clientes |
| `date_commande` | DATE | Format YYYY-MM-DD |
| `montant` | INTEGER | Montant en euros |
| `statut` | TEXT | 'livree', 'en_cours', 'annulee' |
| `region` | TEXT | Région du client |
| `age_client` | INTEGER | Âge du contact client |

25 commandes avec des montants très variés (19€ à 15 000€) — volontairement étalés pour bien illustrer la segmentation par tranches.

---

## 🔑 1. CASE WHEN simple — créer une catégorie

```sql
SELECT client, montant,
    CASE
        WHEN montant < 500 THEN 'Petite'
        WHEN montant < 3000 THEN 'Moyenne'
        ELSE 'Grosse'
    END AS taille_commande
FROM commandes;
```
`CASE` s'évalue **ligne par ligne**, de haut en bas. Dès qu'une condition `WHEN` est vraie, SQL prend ce résultat et ignore les conditions suivantes. `ELSE` couvre tout ce qui n'a matché aucune condition.

---

## 🔑 2. CASE WHEN avec conditions combinées (AND / OR)

```sql
CASE
    WHEN age_client < 30 AND montant > 2000 THEN 'Jeune gros acheteur'
    WHEN age_client < 30 THEN 'Jeune'
    WHEN age_client >= 50 AND montant > 5000 THEN 'Senior premium'
    ELSE 'Standard'
END AS segment
```
⚠️ **L'ordre des conditions compte.** Si on avait mis `WHEN age_client < 30 THEN 'Jeune'` en premier, la condition plus précise `'Jeune gros acheteur'` ne serait jamais atteinte — toujours mettre les conditions les plus spécifiques en premier.

---

## 🔑 3. Pivot manuel — transformer des lignes en colonnes

```sql
SELECT
    client,
    COUNT(*) AS total_commandes,
    SUM(CASE WHEN statut = 'livree'   THEN 1 ELSE 0 END) AS nb_livrees,
    SUM(CASE WHEN statut = 'en_cours' THEN 1 ELSE 0 END) AS nb_en_cours,
    SUM(CASE WHEN statut = 'annulee'  THEN 1 ELSE 0 END) AS nb_annulees
FROM commandes
GROUP BY client;
```
C'est **le** pattern à connaître pour créer des rapports type tableau croisé directement en SQL, sans Excel ni Power BI. Chaque `CASE` devient une colonne du pivot.

### Variante avec montant au lieu de comptage
```sql
SUM(CASE WHEN statut = 'livree' THEN montant ELSE 0 END) AS ca_livre
```

---

## 🔑 4. CASE WHEN dans GROUP BY

```sql
SELECT
    CASE
        WHEN montant < 500 THEN '1. Petite (< 500€)'
        WHEN montant < 3000 THEN '2. Moyenne (500-3000€)'
        ELSE '3. Grosse (> 3000€)'
    END AS tranche,
    COUNT(*) AS nb_commandes
FROM commandes
GROUP BY tranche;
```
On peut grouper directement sur le résultat d'un `CASE` — pratique pour créer des tranches/buckets à la volée sans colonne supplémentaire dans la table.

💡 **Astuce** : préfixer les libellés (`1.`, `2.`, `3.`) force l'ordre alphabétique du `GROUP BY` à correspondre à l'ordre logique métier.

---

## 🔑 5. CASE WHEN dans ORDER BY — tri personnalisé

```sql
ORDER BY
    CASE statut
        WHEN 'en_cours' THEN 1
        WHEN 'livree'   THEN 2
        WHEN 'annulee'  THEN 3
    END,
    montant DESC;
```
Sans ce `CASE`, `ORDER BY statut` trierait alphabétiquement (`annulee`, `en_cours`, `livree`). Avec le `CASE`, on impose **l'ordre métier** souhaité.

---

## 🔑 6. CASE WHEN imbriqué (nested)

```sql
CASE
    WHEN statut = 'annulee' THEN 0
    ELSE
        CASE
            WHEN montant > 10000 THEN montant * 0.15
            WHEN montant > 5000  THEN montant * 0.10
            ELSE 0
        END
END AS remise_calculee
```
On peut imbriquer un `CASE` dans le `ELSE` d'un autre `CASE` pour des règles métier à plusieurs niveaux.

---

## 🔑 7. Deux syntaxes de CASE

```sql
-- Forme "recherchée" : conditions complexes possibles
CASE
    WHEN colonne = valeur1 THEN resultat1
    WHEN colonne > valeur2 THEN resultat2
END

-- Forme "simple" : comparaison directe à une colonne
CASE colonne
    WHEN valeur1 THEN resultat1
    WHEN valeur2 THEN resultat2
END
```
La forme simple est plus courte mais limitée à des comparaisons d'égalité sur une seule colonne.

---

## 🧠 Quand utiliser CASE WHEN ?

| Besoin | Où l'utiliser |
|---|---|
| Créer une catégorie/segment | Dans le `SELECT` |
| Compter conditionnellement | `SUM(CASE WHEN ... THEN 1 ELSE 0 END)` |
| Sommer conditionnellement | `SUM(CASE WHEN ... THEN colonne ELSE 0 END)` |
| Pivoter des lignes en colonnes | Plusieurs `CASE` dans un `SELECT` + `GROUP BY` |
| Grouper par tranche calculée | `CASE` directement dans `GROUP BY` |
| Trier dans un ordre métier custom | `CASE` dans `ORDER BY` |

---

---

⭐ **Si ce projet t'aide, mets une étoile !**
