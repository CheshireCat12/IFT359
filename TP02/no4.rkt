#lang racket

; Chea, Dany 17 133 040
; Gillioz, Anthony 17 133 031

(provide eval-exp)
(require (file "codedesdiapositives.rkt"))

(define eval-exp
  (λ (a)
    (cond
      [(null? a) 0]
      [(atom? a) a]
      [(and (eq? (car a) '+) (null? (cdr a)) 0) ]
      [(and (eq? (car a) '*) (null? (cdr a)) 1) ]
      [(eq? (car a) '+)
       (plus (eval-exp (cadr a))
             (eval-exp (cons (car a) (cddr a))))]
      [(eq? (car a) '*)
       (mult (eval-exp (cadr a))
             (eval-exp (cons (car a) (cddr a))))]
      [else 'exp-invalide])))