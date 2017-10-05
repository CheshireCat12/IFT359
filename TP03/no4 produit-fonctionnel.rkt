#lang racket
(provide produit-fonctionnel-a produit-fonctionnel-b)

;Chea, Dany 17 133 040
;Gillioz, Anthony 17 133 03

(define produit-fonctionnel-a
      (curry foldr compose (λ(x) x)))

(define produit-fonctionnel-b
  (λ func
    (foldr compose (λ(x) x) func)))

((produit-fonctionnel-a (list add1 sqr (curry * 2))) 1)
((produit-fonctionnel-b add1 sqr (curry * 2)) 1)


