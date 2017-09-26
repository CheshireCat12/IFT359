#lang racket

;Chea, Dany 17 133 040
;Gillioz, Anthony 17 133 031

(provide reverse-tout)
(require (file "codedesdiapositives.rkt"))

;Vous pouvez choisir entre l'un des gabarits suivants.
;Supprimez celui que vous n'utilisez pas.


(define reverse-tout
  (λ (ls)
    (define iter
      (λ (in out)
        (cond
          [(null? in) out]
          [(pair? (car in)) (iter (cdr in) (cons (iter (car in) '()) out))]
          [else(iter (cdr in) (cons (car in) out))])))
    (iter ls '())))
