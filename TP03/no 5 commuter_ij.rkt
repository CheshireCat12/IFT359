#lang racket
;Chea, Dany 17 133 040
;Gillioz, Anthony 17 133 031

(provide commuter_ij)


(define commuter_ij
  (λ (e i j)
    (define iter
      (λ(liste i j)
        (cond
          [(eq? i 0) (iter2 '() (cdr liste) (car liste) (sub1 j))]
          [else (cons (car liste) (iter (cdr liste) (sub1 i) (sub1 j)))])))
    (define iter2
      (λ(listBegin listEnd commut j)
        (cond
          [(eq? j 0) (list (car listEnd) (apply (λ(x)x) (reverse listBegin)) commut (apply (λ(x)x) (cdr listEnd)))]
          [else (displayln (cdr listEnd))
           (iter2 (cons (car listEnd) listBegin)(cdr listEnd) commut (sub1 j))])))
    (iter e i j)
    ))
