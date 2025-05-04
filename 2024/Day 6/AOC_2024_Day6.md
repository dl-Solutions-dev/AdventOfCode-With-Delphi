# Propositions

## <u>Partie 1</u>

On simule le déplacement du garde dans la matrice en appliquant le comportement
du garde lorsqu'il recontre un obstacle sur son chemin (il tourne pour prendre
la direction vers sa droite)

Résultat : 4826

---

## <u>Partie 2</u>

On refait la partie 1 en notant le chemin parcouru

puis on va parcourir le chemin et pour chaque pas :
- Copier le chemin
- Ajouter un obstacle à l'emplacement du chemin où on se trouve
- lancer le thread de la partie 1 avec cette nouvelle configuration
- si il se termine par une boucle, la méthode appelée du thread principal va
incrrémenter le nombre de boucles
- Si il sort normalement, on ne fait rien de spécial

#### Pour définir si le chemin boucle

A chaque fois qu'on rencontre un obstacle, on le note ainsi que le sens dans
lequel on va aller. Lorsqu'on retrouve ce couple (obstacle + même sens), alors
on considère qu'on est dans une boucle.

Entrée du thread : matrice de départ avec le nouvel obstacle en plus

Resultat : 1721

---