#lang racket

(displayln "André Mayers")
(displayln "Diane Laroche")

(provide produit-cartésien)



(define produit-cartésien 
  (λ ls
    (define iterOnList
      (λ(liste produit)
        (cond
          [(null? liste) '()]
          [else(cons (cons (car liste) produit)
                     (iterOnList (cdr liste) produit))])))
    
    (define iterOnProduit
      (λ(liste produits)
        (cond
          [(null? produits) '()]
          [else(append (iterOnList liste (car produits))
                     (iterOnProduit liste (cdr produits)))])))

    (define iter
      (λ(liste produitTemp)
        (cond
          [(null? liste)  (map reverse produitTemp)]
          [else(iter (cdr liste) (iterOnProduit (car liste) produitTemp))])))
    (if (not (null? ls))
        (iter (cdr ls)(iterOnList (car ls) '()))
        '())
    ))

(produit-cartésien )

(produit-cartésien '(X Y Z))

(produit-cartésien '(* - +) '(1 2 3))

(produit-cartésien '((Aa)(Bb)(Cc)) '(1 2 3))

(produit-cartésien '(X Y Z) '(1 2 3) '(a b c))
