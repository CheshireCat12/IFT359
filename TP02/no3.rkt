#lang racket

;Chea, Dany 17 133 040
;Gillioz, Anthony 17 133 031

(provide remove1)
(require (file "codedesdiapositives.rkt"))

(define remove1
  (λ (e lol)
    (cond
      [(null? lol) '()]
      [(atom? (car lol))
       (cond
         [(eq? e (car lol)) (cdr lol)]
         [else(cons (car lol)
                    (remove1 e (cdr lol)))])]
      [else(cond
             [(gt (occur e (car lol)) 0) (cons (remove1 e (car lol)) (cdr lol))]
             [else(cons (car lol) (remove1 e (cdr lol)))])])))
