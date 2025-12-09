# Cours : Développement de Systèmes d’Exploitation

## Description
Ce cours enseigne les bases du développement d’un système d’exploitation moderne, depuis le bootloader jusqu’au kernel multitâche.
Objectif : comprendre et implémenter chaque couche — du matériel à l’espace utilisateur.

## Contenu
- **Bootloader (MBR)** — initialisation et passage en mode protégé.
- **GDT / IDT / ISR / PIC** — gestion bas-niveau du processeur et des interruptions.
- **Mémoire (PMM / VMM / Paging)** — allocation physique, virtuelle et mappages.
- **Gestion des tâches** — context switch, scheduler, multitâche préemptif.
- **Système de fichiers (FAT16)** — lecture/écriture basique.
- **Syscalls & Userland** — interface entre noyau et programmes utilisateurs.

## Progression

- [~] Bootloader
- [x] GDT
- [ ] IDT
- [ ] ISR
- [ ] PIC
- [ ] PMM
- [ ] VMM
- [ ] Paging
- [ ] Tasks
- [ ] Scheduler
- [ ] FS
- [ ] VFS
- [ ] Syscalls
- [ ] Userland

## Mises à jour

### 09/12 Commit: b3ae4b7c0d6b7f950995f0871c1755ac4a084c0e
Après avoir montré comment faire un bootloader basique, nous utiliserons Limine pour la suite afin d'alléger notre charge de travail.

### 9/12 Commit: 994cfeec30d6e436a1b7b39869f02627c825a84a
Intégration de la GDT, override de celle proposée par Limine (structure à faire pour éventuel rewrite lors de transition vers Usrland).

