# Minecraft Backup vers AWS S3

## Objectif

Mettre en place un système de sauvegarde automatique pour un monde Minecraft Java (vanilla via Prism Launcher) avec :

- Script PowerShell local
- Amazon S3
- Versioning activé
- Lifecycle Management
- IAM avec principe du moindre privilège

Le but est d’obtenir :

- Sauvegarde cohérente
- Historique versionné
- Coût maîtrisé
- Restauration simple
- Aucune corruption

---

## Pourquoi backup uniquement à la fermeture ?

Minecraft écrit en continu dans :

- `region/*.mca`
- `level.dat`
- `playerdata/`

Un backup pendant l’écriture pourrait capturer un fichier partiellement écrit.

Solution retenue :

- Surveiller le process `javaw.exe`
- Attendre la fermeture du jeu
- Créer un snapshot ZIP complet
- Upload vers S3

Cela garantit un état cohérent équivalent à “Save & Quit”.

