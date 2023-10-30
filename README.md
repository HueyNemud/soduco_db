# Paris directories: PostgreSQL database

This repository documents the design principles of the PostgreSQL database containing the data extracted from the Paris directories, and provides a set of SQL scripts for initializing and maintaining the database.


## Table of Contents
- [Design principles](#design-principles)
- [Getting Started](#getting-started)
- [Script Descriptions](#script-descriptions)
  - [Initialization Scripts](#initialization-scripts)
  - [Data Feed Scripts](#data-feed-scripts)
  - [Maintenance Scripts](#maintenance-scripts)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [Support](#support)
- [License](#license)

## Design principles

Les choix de design sont motivés par les caractéristiques des données à stocker :
1. Massivité. La livraison actuelle (septembre 2023) contient l'extraction de 192 annuaires, soit ~22.7M entrées et ~90M éléments de structure.
2. Scarce but large writes. Il s'agit de données froides, les données ne sont a priori plus modifiées une fois importées. En cas de nouvelle extraction d'un annuaire, l'ancienne version des données est entièrement remplacée.
3. Frequent and large reads.Les opérations de lectures nécessitent quant à elles d'accéder à des parties potentiellement importantes du corpus, de faire des filtrages, de la recherche plein texte et des croisements de données.
4. Granularity. Le corpus extrait s'organise en trois niveaux principaux: (a) la source (<=> annuaire ou liste), (b) l'élément (entrée ou structure) et (c) l'entité nommée.


NOTICE:  entries: 22743928
NOTICE:  page_structure: 1446989
NOTICE:  geocoded_address_gazetteer: 6816346
NOTICE:  persons: 23728378
NOTICE:  activities: 14663426
NOTICE:  titles: 2106808
NOTICE:  addresses: 27618637

## Dataset summary

### October 2023

| Table    | Count |Table size (Gb) |
| -------- | ------- |------- |
| Sources  | 455  | 344 kBs |
| Entries  | 22 743 928 | 23 GBs |
| Page structures | 0 (truncated as of oct. 30 2023) | 7680 kBs |
| Geocoding Gazetteer | 6816346 | 2729 MBs |
| Persons    | 23 728 378 | 3994 MBs |
| Titles    | 2 106 808 | 2628 MBs |
| Activities    | 14 663 426 | 2628 MBs |
| Addresses    | 27 618 637 | 11 Gbs |
