# Day 8

## <u>Partie 1</u>

On parcours la matrice. Pour chaque antenne trouv�e (case diff�rente de ".")

- on reparcours la matrice � la recherche d'une autre antenne de m�me fr�quence (m�me symbole)
- On calcul la diff�rence entre les 2 points correspondants
- On applique la m�me diff�rence en amont du point le plus haut
    - si on est pas sorti de la matrice on met un "#" (antinode)
    - sinon on ne met rien
- On fait pareil pour le point le plus bas

Ensuite on reparcours la matrice pour compter le "#"
<br/><br/>
<u>R�sultat :</u> 276

---

## <u>partie 2</u>

Maintenant il faut prendre en compte la r�sonnace. Concr�tement lorsqu'on a trouv� un
alignement, au lieu de placer un "#" en amont et en aval des 2 antennes, on en place :

- � la place de celle-ci
- on poursuit la ligne tant qu'on n sort pas de la matrice, ceci dans les deux sens

<u>R�sultat :</u> 991

---