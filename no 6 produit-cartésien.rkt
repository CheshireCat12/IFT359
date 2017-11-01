#lang racket

(displayln "André Mayers")
(displayln "Diane Laroche")

(provide produit-cartésien)

(define produit-cartésien 
  (λ ls
    (displayln (length ls))))

(produit-cartésien)

(produit-cartésien '(X Y Z))
