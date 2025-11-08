# GESTION DE VENTE ULTRA - Squelette Flutter

Contenu:
- Un projet Flutter minimal contenant:
  - Dashboard avec statistiques de base
  - Gestion des produits (CRUD basique)
  - Enregistrement des ventes et mise à jour du stock
  - Historique et export JSON (partage de fichier)
  - Base de données locale SQLite via sqflite

Comment utiliser:
1. Copier le dossier 'gestion_vente_ultra' dans ton téléphone ou ordinateur.
2. Ouvrir le projet avec Android Studio / VS Code (Flutter doit être installé).
3. Lancer `flutter pub get` puis exécuter sur un appareil ou émulateur.

Remarques:
- Ce squelette contient les fonctionnalités essentielles. Pour ajouter:
  - Génération PDF: utiliser le package 'pdf' et 'printing'
  - Authentification locale: utiliser 'local_auth' pour empreinte digitale
  - Sauvegarde cloud: intégrer Google Drive API ou Firebase
  - Traductions: utiliser 'flutter_localizations' et intl
