Welcome to DrRacket, version 6.10.1 [3m].
Language: racket, with debugging; memory limit: 256 MB.
No 1
Définir la fonction reverse-tout qui inverse une liste et récursivement 
les listes qui y sont imbriquées. 
Utilisez dans votre réponse que les primitives qui vous ont
été présentées dans les diapositives. N'utilisez pas reverse ou append.

Les éléments des listes sont soit des paires, la liste vide ou
des constantes de n'importe quels types de Racket.

Je vous suggère de créer une fonction récursive (nommée ici iter) qui fera
tout le travail. iter prend deux arguments input la partie de la liste non traitée
et output la partie traitée.

Voici une trace qui illustre l'intuition derrière cet algorithme
>(reverse-tout '(a (b () c) d))
>(iter '(a (b () c) d) '())
>(iter '((b () c) d) '(a))
> (iter '(b () c) '())
> (iter '(() c) '(b))
> (iter '(c) '(() b))
> (iter '() '(c () b))
< '(c () b)
>(iter '(d) '((c () b) a))
>(iter '() '(d (c () b) a))
<'(d (c () b) a)
'(d (c () b) a)
   
   
Voici des exemples d'exécution :
'(reverse-tout null)
'()

'(reverse-tout '(a))
'(a)

'(reverse-tout '(a b c d))
'(d c b a)

'(reverse-tout '(a "bxyz" c d))
'(d c "bxyz" a)

'(reverse-tout '(a (b c) d))
'(d (c b) a)

'(reverse-tout '(a b (1 b () 4 ()) c))
'(c (() 4 () b 1) b a)

'(reverse-tout '(1 2 (a (x #(1 2 3) z) b) 3 4))
'(4 3 (b (z #(1 2 3) x) a) 2 1)

'(reverse-tout '(1 (#\λ 3) () ((4 5) 6) 7))
'(7 (6 (5 4)) () (3 #\λ) 1)

No 2
Définir en Racket la fonction intersection3 qui prend trois listes ordonnées 
de nombre entier (sans répétition) et qui, en les traversant qu'une fois, 
retourne l'intersection de ces trois listes. 
Attention aux fonctions que vous utilisez par exemple 
1) append traverse tout son premier argument  
2) reverse traverse son argument
3) member traverse au moins une partie de la liste donnée en argument. 
Je vous suggère de vous limiter aux primitives suivantes :
cons car cdr define λ if cond or null? = < <= > >= let 

Voici des exemples d'exécution :
'(intersection3 '(1 5 8 12) '(1 2 5 8) '(1 8))
'(1 8)

'(intersection3 '(2 5 8 12) '(1 2 5 9) '(1 8))
'()


No 3
Définir la fonction remove1 dont la signature est (remove1 e lol).
remove1 enlève le premier e et seulement le premier élément e de lol
qu'il rencontre en traversanl lol, une liste de liste.

Voici des exemples d'exécution :
'(remove1 5 '(()))
'(())

'(remove1 5 '(5 2 5))
'(2 5)

'(remove1 5 '((a () b) (a (((a b 5))) b c) 2 5))
'((a () b) (a (((a b))) b c) 2 5)

'(remove1 5 '((a () b) (a (((a b 5))) b c) 2 5))
'((a () b) (a (((a b))) b c) 2 5)

'(remove1 5 '((a () b) (a (((a b 45))) b c) 2 2))
'((a () b) (a (((a b 45))) b c) 2 2)

No 4
Dans le contexte des s-expressions, modifier et étendre la fonction eval-exp
pour ajouter des expressions contenant la multiplication ('*).
Pour ce numéro, vous ne pouvez pas utiliser les opérateurs numériques + - * /
c'est-à-dire que vous devez utiliser les fonctions add1 sub1 plus et mult vu en classe.

Voici une trace d'exécution d'un algorithme possible de eval-exp
>(eval-exp '(+ (* 3 4) 5 7 2))
> (eval-exp '(* 3 4))
> >(eval-exp 3)
< <3
> >(eval-exp '(* 4))
> > (eval-exp 4)
< < 4
> > (eval-exp '(*))
< < 1
< <4
< 12
> (eval-exp '(+ 5 7 2))
> >(eval-exp 5)
< <5
> >(eval-exp '(+ 7 2))
> > (eval-exp 7)
< < 7
> > (eval-exp '(+ 2))
> > >(eval-exp 2)
< < <2
> > >(eval-exp '(+))
< < <0
< < 2
< <9
< 14
<26
26
> (+ (* 3 4) 5 7 2)
26


Voici des exemples d'exécution :
'(eval-exp '3)
3

'(eval-exp '(+ 3 4 5 2))
14

'(eval-exp '(* 3 4 10))
120

'(eval-exp '(+ (* 3 4) 5 7 2))
26

'(eval-exp '(+ (* 3 4) (+ (* 2 5) 7) 5))
34

'(eval-exp '(+ (* 3 2 1 10) 4 (* 5 2)))
74

No 5
Définir en Racket la fonction compte-unique.
Voici sa signature (compte-unique lol) où lol est une liste de listes.
compte-unique retourne le nombre d’atome sans compter les duplicats ;
par exemple (compte-unique '(1 2 (2 1 (3 4 2) 3 1))) retourne 4. 
Pour définir cette fonction, n’utilisez que les primitives suivantes :
cons car cdr caar cadr ... append reverse member let let* letrec
cond if list + - ... < > = ... null? list? pair? length.
Cependant, si vous croyez qu’une autre primitive est utile,
vous pouvez la redéfinir.
Comme pour les numéros précédents, il peut y avoir plusieurs solutions.
Je vous suggère d'utiliser une fonction auxiliaire nommé iter dans
la trace qui suit.
>(compte-unique '(f (ag (f acc efg 3))))
> (iter '() '(f (ag (f acc efg 3))))
> >(iter '() 'f)
< <'(f)
> (iter '(f) '((ag (f acc efg 3))))
> >(iter '(f) '(ag (f acc efg 3)))
> > (iter '(f) 'ag)
< < '(ag f)
> >(iter '(ag f) '((f acc efg 3)))
> > (iter '(ag f) '(f acc efg 3))
> > >(iter '(ag f) 'f)
< < <'(ag f)
> > (iter '(ag f) '(acc efg 3))
> > >(iter '(ag f) 'acc)
< < <'(acc ag f)
> > (iter '(acc ag f) '(efg 3))
> > >(iter '(acc ag f) 'efg)
< < <'(efg acc ag f)
> > (iter '(efg acc ag f) '(3))
> > >(iter '(efg acc ag f) 3)
< < <'(3 efg acc ag f)
> > (iter '(3 efg acc ag f) '())
< < '(3 efg acc ag f)
> >(iter '(3 efg acc ag f) '())
< <'(3 efg acc ag f)
> (iter '(3 efg acc ag f) '())
< '(3 efg acc ag f)
<5

Comme vous le constatez iter a deux arguments :
le premier est la liste des éléments rencontrés sans duplicats
le second est l'élément qu'il traite.



Voici des exemples d'exécution :
'(compte-unique '())
0

'(compte-unique '(a b (b a ('abc 17 b) 'abc a)))
5

'(compte-unique '(a b (() b) #\a ('abc 17 #\a b) 'abc a))
6

> 