#lang racket

;Chea, Dany 17 133 040
;Gillioz, Anthony 17 133 031

(provide compte-unique)
(require (file "codedesdiapositives.rkt"))

(define compte-unique 
  (λ (arbre)
    (define iter 
      (λ (acc arbre)
        (cond
          [(null? arbre) acc]
          [(atom? (car arbre))
           (cond
             [(not (member (car arbre) acc)) (iter (cons (car arbre) acc) (cdr arbre))]
             [else(iter acc (cdr arbre))])]
          [else(iter (iter acc (car arbre)) (cdr arbre))])))
    (length (iter '() arbre))))
