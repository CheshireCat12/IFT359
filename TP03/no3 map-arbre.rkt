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
)