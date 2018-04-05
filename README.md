# <center> **Piano tiles** <center> #
Lien vers les fichiers: https://github.com/chicheryj/piano_tiles

* [Présentation](#presentation)
* [Adaptation VHDL](#adaptaion_vhdl)
* [Programme C](#programme_c)

## Présentation ##

Le projet *piano tiles* a été créé dans le cadre de notre enseignement en *Systeme programmable sur puce reconfigurable*. Ce projet se programme sur la puce *FPGA Artic 7* et s'implémente sur une carte *NEXYS 4*. <br/>
Le programme implémenté est une adaptation du jeu **Piano Tiles**, développé pour smartphone. Le principe du jeu est d'appuyer sur les touches qui défilent avant quelle ne sortent vers le bas de l'écran.<p>
On peut voir un exemple sur le GIF suivant avec l'affiche du score en haut:



<center> <img src="https://media3.giphy.com/media/tuuf7xNzAhBdK/giphy.gif" /> <center>

Source: *giphy.com*
<p>

L'adaptation du jeu sur FPGA a été de se servir des 7-segments et des boutons. En utilisant la carte sur le côté, les 7-segments font défiler une suite de tirets soit à gauche, au centre ou à droite ou vide, puis lorsque le trait atteint le dernier afficheur, il suffit d'appuyer sur le bouton correspondant ou rien si le 7-segment est vide. Avec la carte sur le côté, le bouton bas devient gauche et le  bouton haut devient droite. Toutes les 20 réussites d'affilées, on augmente d'un niveau en accélérant le défilement des traits jusqu'à 7 niveaux.


<center> <img src="https://sm2.photorapide.com/membres/4403/photos/m16789.png" width="500" height="500" /> <center>


Au moindre échec, le jeu s'arrête, affiche **LOSE** et le score.


<center> <img src="https://sm2.photorapide.com/membres/4403/photos/lh8m7x.jpg" /> <center>



Lors du lancement du jeu des indications sont envoyées sur le port séries. On peut les lire en ouvrant un hyper terminal. Pour cela on peut utiliser la commande suivante dans un autre terminal afin d'ouvrir un nouveau terminal **minicom**: <br/>
```
minicom -s
```
<br/> Puis modifier le port série:<br/>
```
Port serie: /dev/ttyUSB1
```
<br/>Quitter le **minicom**, maintenant vous avez la fenêtre d'un hyper terminal. Appuyer ensuite sur le bouton **reset** de la carte *NEXYS 4*. On peut maintenant recevoir des données depuis la carte *NEXYS 4*.



<center> <img src="https://sm2.photorapide.com/membres/4403/photos/5djyzn.png" /> <center>


<hr>


## Adaptation VHDL ##


Le transcodeur fournit a dû être retoucher, puisqu'il ne servait qu'à afficher certaines lettres et les chiffres. Il a donc fallu rajouter les lettres manquantes et le code en 7-segment de chaque tiret. Puis, deux signaux ont été créé, un appelé "etat_jeu" correspondant à l'état du jeu, si on commence, si on joue ou si on a perdu, et le score qui va être affiché à la fin. Nopus nous servions des 32 bits de la manière suivante :

- les 16 premiers bits servent à l'affichage des 8 sept-segments. Regroupé par 2, si la valeur de deux bits correspondant à un afficheur vaut 0, le sept-segment affiche un vide, si il est à 1, le tiret est à gauche, si 2 le tiret est au centre, si 3 le tiret est à droite.
- les bits 17 et 18 déterminent l'état du jeu.
- les 12 bits de poids fort détiennent l'information du score.

<p>

- Si etat_jeu vaut 0, les sept-segment affiche **PUSH**, appuyer sur un bouton initialise le jeu et etat_jeu prend la valeur 1.
- Si etat_jeu vaut 1, les sept-segment prennent la valeur correspondant aux 16 premiers bits décrit plus haut.
- Si etat_jeu vaut 2, les sept-segment le jeu se termine, affiche **LOSE** et donne le **score**.<p>


La dernier modification correspond à un simple transcodeur où on donne les valeurs en hexadécimale des 12 derniers bits pour l'affichage du score final.


<center> <img src="https://sm2.photorapide.com/membres/4403/photos/hd/vaww6l.png" /> <center>


<hr>


## Programme C ##


Pour lancer le jeu, en langage C nous attendons tout d’abord l'appui d'un bouton, puis le jeu se lance pour plusieurs parties si on le souhaite, donc dans une boucle infinie.<br/>
En début de partie nous effectuons l’initialisation de plusieurs variables telles que: le score (`score`), la chaine des 8 tirets (`tiret_jeu`), le décompte avant le début d'incrémentation du score (`huit_premier_tour`), l'indication de l'état de jeu (`game`) et pour finir le LFSR (`lfsr`). Cette dernière variable est initialisée à l'aide du compteur d'horloge afin d'entrer un entier pseudo aléatoire dû à une fréquence d'horloge élevé (*50 MHz*). Nous utilisons ce LFSR pour générer de nouveaux tirets de façon pseudo aléatoire en relevant les bits 24 et 7.


Nous entrons ensuite dans la boucle de la partie. Dans cette boucle nous mettons à jour le LFSR en utilisant la fonction `my_lfsr()`, puis nous ajoutons un nouveau tiret dans la chaine des 8 tirets, ce dernier tiret est obtenue en relevant les bits 24 et 7 du LFSR. Cette nouvelle chaîne est envoyé ensuite au `ctrl_7seg` par l'adresse `SEVEN_SEGMENT_REG`.<br/>
On relève ensuite le temps de décalage des tirets avec la fonction `time_level`. Cette fonction retourne une durée en milliseconde en fonction du score. Plus le score augmente, plus la durée de décalage des tirets diminue, donc le jeu devient plus rapide et plus difficile. Cette fonction gère aussi l'affichage des LEDs pour indiquer le niveau dans lequel nous somme (niveau 1 à 8) ainsi que la LED numéro 5 qui indique si un bouton a déjà été appuyé durant le décalage actuel.<br/>
On entre alors dans une boucle qui attend le temps de décalage du niveau actuel, tout en mémorisant la valeur du premier appui de bouton, si l’on n’appuie pas la valeur reste à 0. Une fois le temps écoulé, on incrémente le score si l’on a déjà passé les 8 premiers tours de la partie  (avec `huit_premier_tour`) qui correspondent à la descente du tout premier tiret sur les 8 afficheurs 7 segments.


En fin de boucle de partie on utilise la fonction `butt_to_tiret()` pour convertir la valeur du bouton relevé durant ce tour afin de le comparer avec la valeur du tiret le plus anciens de la chaîne (donc le dernier segment). Si les valeurs correspondent, on continue la partie sinon on a perdu et l'on affiche le score sur l'hyper terminal ainsi qu’avec les afficheurs 7 segments de la carte *NEXYS 4*. Un chenillard miroité sur les LEDs se déclenchera lors de l'affichage du score.<br/>
On vérifie la valeur des boutons dans la boucle de ce chenillard afin de relancer une partie lorsque l'utilisateur le souhaite en appuyant sur n’importe quel bouton.
