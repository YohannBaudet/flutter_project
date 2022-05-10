> Allard Noé 
> Baudet Yohann
> Descamps Matysse
> Fromenteau Jérémy

# Projet de carte Yu-Gi-Oh!

Ce projet utilise l'API fournit par le site :
[API Yu-Gi-Oh!](https://db.ygoprodeck.com/api-guide/)

# But de l'application

Yu-Gi-Oh! est un jeu de cartes en tour par tour où 2 adversaires s'affrontent (ils possèdent chacun un deck de cartes).
Les 2 joueurs commencent le match avec 8 000 points de vie et le premier qui descend à 0 perd la partie.
Notre application permet de :
 - rechercher une carte en fonction de son nom
 - afficher les informations d'une carte sélectionnée (description, liste de sets, rareté, prix)
 - créer des decks/supprimer decks
 - ajouter/supprimer des cartes dans les decks
 - afficher le prix total d'un deck

L'intérêt de l'application est de pouvoir créer ses propres deck et de connaître le prix que l'utilisateur aurait à payer pour s'acheter ses cartes.
Ce prix provient du site cardmarket.
Une spécificité est que pour chaque carte, on peut choisir le set de la carte.
C'est-à-dire que chaque carte existent dans plusieurs raretés (commune, rare, ultra rare (brillante)) et sont sorti à différentes dates, souvent plus elles sont vieilles plus elles coûtent cher.
Il y a donc également un intérêt pour les collectionneurs qui veulent connaître le prix de cartes rares ou tout simplement un jour qui veut jouer avec des cartes "plus belles".

# Scénarios d'utilisation

Dans cette section nous allons voir comment utiliser notre application 

## Page Mes Decks(Page d’accueil)
 Dans cette Page vous avez un bouton + en haut a droite de l'écran,ce bouton permet d'ajouter
de créer un nouveau deck de carte vide.
Si vous cliquer sur ce bouton vous verrez apparaitre une nouveau deck.Il y a un petit icon de
stylo.Ce dernier vous permet de changer le nom de votre deck mais aussi de pouvoir supprimer
ce dernier.
 
 Sur cette page vous avez en bas a droite un loupe qui vous permettra d'aller dans la page 
 de recherche de carte.

## Page Recherche
Sur cette page vous avez une barre de recherche qui vous permet de trouver la carte que vous
chercher grâce a son nom même si vous n'en avez qu'une partie.Une fois votre carte trouvez
cliquer dessus et vous arriverez sur la page de la carte .

## Page de la carte
Ici vous retrouverez un visuel de la carte(fourni en anglais dans l'API),une description ainsi que les différents prix de la carte.Vous pouvez aussi ajouter cette carte a un deck préalablement créer.

Après avoir ajouter une carte dans un deck vous pouvez retourner sur la page des decks et cliquer sur votre deck vous arriverez sur le détail du deck.

## Page de détails d'un deck
Sur cette page vous avez l'ensemble des cartes de votre deck ,vous pouvez cliquer dessus pour aller a la page de la carte mais aussi la retirer grâce a menu déroulant dessus,un bouton "Ajouter Carte" qui envoie vers la page de recherche et en haut de la page vous avez le prix de votre deck.