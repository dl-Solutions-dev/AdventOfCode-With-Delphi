# Day 8

## <u>Partie 1</u>

On parcours la matrice. Pour chaque antenne trouvée (case différente de ".")

- on reparcours la matrice à la recherche d'une autre antenne de même fréquence (même symbole)
- On calcul la différence entre les 2 points correspondants
- On applique la même différence en amont du point le plus haut
    - si on est pas sorti de la matrice on met un "#" (antinode)
    - sinon on ne met rien
- On fait pareil pour le point le plus bas

Ensuite on reparcours la matrice pour compter le "#"
<br/><br/>
<u>Résultat :</u> 276

---

## <u>partie 2</u>

Maintenant il faut prendre en compte la résonnace. Concrètement lorsqu'on a trouvé un
alignement, au lieu de placer un "#" en amont et en aval des 2 antennes, on en place :

- à la place de celle-ci
- on poursuit la ligne tant qu'on n sort pas de la matrice, ceci dans les deux sens

<u>Résultat :</u> 991

---