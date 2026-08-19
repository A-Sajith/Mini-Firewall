# mini-fw

Wrapper bash simplifié pour la gestion d'un pare-feu Linux avec **nftables**.

Permet de bloquer/débloquer des IP et des ports via des commandes simples, sans avoir à mémoriser la syntaxe complète de nftables.

## Contexte

Projet réalisé dans le cadre de ma recherche d'alternance en administration systèmes & réseaux, pour mettre en pratique la gestion du filtrage réseau sous Linux.

## Fonctionnement

Le script crée une table nftables (`mini_fw`) et une chaîne accrochée au hook `input` (trafic entrant), avec une politique par défaut `accept`. Les règles ajoutées bloquent explicitement le trafic indésirable (modèle blacklist).

```
table (inet mini_fw)
 └── chaîne (input_filter, hook=input, policy=accept)
      ├── règle : bloquer IP X
      └── règle : bloquer port Y
```

## Prérequis

- Linux avec `nftables` installé
- Droits root (le script manipule les règles du noyau)

```bash
sudo apt install nftables
```

## Installation

```bash
git clone https://github.com/<ton-user>/mini-fw.git
cd mini-fw
chmod +x mini-fw.sh
```

## Utilisation

```bash
# Initialise la table et la chaîne (à faire une seule fois)
sudo ./mini-fw.sh init

# Bloquer une IP
sudo ./mini-fw.sh block-ip 203.0.113.42

# Débloquer une IP
sudo ./mini-fw.sh unblock-ip 203.0.113.42

# Afficher les règles actives
sudo ./mini-fw.sh list
```

## Exemple

```bash
$ sudo ./mini-fw.sh init
Firewall initialisé.

$ sudo ./mini-fw.sh block-ip 8.8.8.8
IP 8.8.8.8 bloquée.

$ sudo ./mini-fw.sh list
table inet mini_fw {
    chain input_filter {
        type filter hook input priority filter; policy accept;
        ip saddr 8.8.8.8 drop
    }
}

$ sudo ./mini-fw.sh unblock-ip 8.8.8.8
IP 8.8.8.8 débloquée.
```

## Ce que le projet démontre

- Compréhension du fonctionnement de nftables (tables, chaînes, hooks, handles)
- Filtrage de trafic réseau entrant par IP
- Scripting bash (arguments, parsing de sortie avec `grep`/regex, gestion de cas)
- Tests réels de blocage/déblocage (validés avec `ping`)

## Limites connues / améliorations possibles

- Pas encore de gestion des ports (`block-port` / `unblock-port`)
- Pas de sauvegarde/restauration de configuration
- Pas de journalisation des tentatives bloquées

## Auteur

Sajith — étudiant en Master Réseaux, Systèmes et Cloud Computing (ESGI Paris), à la recherche d'une alternance Admin Sys & Réseaux / DevOps.
