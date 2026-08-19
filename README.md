# mini-fw

Petit script bash pour gérer un pare-feu Linux (nftables) sans avoir à retenir toute la syntaxe à chaque fois.

## Pourquoi ce projet

En recherche d'alternance Admin Sys / Réseaux, je voulais un projet concret pour pratiquer le filtrage réseau sous Linux plutôt que de juste lire de la théorie. nftables a une syntaxe assez lourde à taper à la main, donc j'ai fait un wrapper avec des commandes simples : bloquer une IP, la débloquer, voir les règles actives.

## Comment ça marche

Le script crée une table nftables et une chaîne branchée sur le trafic entrant (`hook input`), avec une politique "accept" par défaut. On bloque ensuite explicitement ce qu'on ne veut pas laisser passer (une IP, un port).

```
table mini_fw
 └── chaîne input_filter (hook input, policy accept)
      ├── règle : bloquer une IP
      └── règle : bloquer un port
```

## Prérequis

nftables doit être installé, et il faut être root pour manipuler les règles.

```bash
sudo apt install nftables
```

## Installation

```bash
git clone https://github.com/A-Sajith/Mini-Firewall.git
cd Mini-Firewall
chmod +x mini-fw.sh
```

## Utilisation

```bash
sudo ./mini-fw.sh init                    # à faire une seule fois
sudo ./mini-fw.sh block-ip 203.0.113.42
sudo ./mini-fw.sh unblock-ip 203.0.113.42
sudo ./mini-fw.sh list
```

## Exemple concret

Testé en bloquant 8.8.8.8 puis en vérifiant avec un ping que le trafic était bien coupé :

```bash
$ sudo ./mini-fw.sh block-ip 8.8.8.8
IP 8.8.8.8 bloquée.

$ ping -c 4 8.8.8.8
4 packets transmitted, 0 received, 100% packet loss

$ sudo ./mini-fw.sh unblock-ip 8.8.8.8
IP 8.8.8.8 débloquée.

$ ping -c 4 8.8.8.8
4 packets transmitted, 4 received, 0% packet loss
```

## Ce que ça m'a fait travailler

- Le fonctionnement de nftables : tables, chaînes, hooks, handles
- Le filtrage de trafic entrant par IP
- Du scripting bash un peu plus poussé que d'habitude (parsing avec grep/regex pour retrouver le handle d'une règle avant de la supprimer)

## À faire

- `block-port` / `unblock-port` (même logique que pour les IP, pas encore fait)
- Sauvegarde/restauration de la config
- Log des tentatives bloquées

## Auteur

Sajith, en Master Réseaux, Systèmes et Cloud Computing à l'ESGI, en recherche d'alternance Admin Sys & Réseaux / DevOps.
