#lang racket
(provide map-arbre)

;Chea, Dany 17 133 040
;Gillioz, Anthony 17 133 031

(require (file "codedesdiapositives.rkt"))

(define map-arbre
  (λ (proc arbre)
    (cond
      [(null? arbre) '()]
      [(atom? (car arbre)) (cons (proc (car arbre)) (map-arbre proc (cdr arbre)))]
      [else(cons (map-arbre proc (car arbre)) (map-arbre proc (cdr arbre)))])))

(map-arbre sqr '(1(2(3))()4 5))
(map-arbre number->string '(1(2(3))()4 5))