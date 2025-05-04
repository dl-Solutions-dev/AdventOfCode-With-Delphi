# Propositions

## <u>Partie 1</u>

On simule le d�placement du garde dans la matrice en appliquant le comportement
du garde lorsqu'il recontre un obstacle sur son chemin (il tourne pour prendre
la direction vers sa droite)

R�sultat : 4826

---

## <u>Partie 2</u>

On refait la partie 1 en notant le chemin parcouru

puis on va parcourir le chemin et pour chaque pas :
- Copier le chemin
- Ajouter un obstacle � l'emplacement du chemin o� on se trouve
- lancer le thread de la partie 1 avec cette nouvelle configuration
- si il se termine par une boucle, la m�thode appel�e du thread principal va
incrr�menter le nombre de boucles
- Si il sort normalement, on ne fait rien de sp�cial

#### Pour d�finir si le chemin boucle

A chaque fois qu'on rencontre un obstacle, on le note ainsi que le sens dans
lequel on va aller. Lorsqu'on retrouve ce couple (obstacle + m�me sens), alors
on consid�re qu'on est dans une boucle.

Entr�e du thread : matrice de d�part avec le nouvel obstacle en plus

Resultat : 1721

---