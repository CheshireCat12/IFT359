#lang racket

;Chea, Dany 17 133 040
;Gillioz, Anthony 17 133 031

(require (file "codedesdiapositives.rkt"))

(provide flatten1 flatten2)


(define flatten1
  ; flatten en utilisant append-map
  (λ (arbre)
    (define iter
      (λ(ls)
        (cond
          [(atom? ls) (list ls)]
          [else(append-map iter ls)])))
    (append-map iter arbre)))

(define flatten2
  ; flatten en utilisant foldr
  (λ (arbre)
    (define iter
      (λ(newLs oldLs)
        (cond
          [(atom? newLs) (cons newLs oldLs)]
          [else(foldr iter oldLs newLs)])))
    (foldr iter null arbre)))

(flatten1 '(1 3 5 (6 7 8)))
(flatten2 '(1 3 5 (6 7 8)))

