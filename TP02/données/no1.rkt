#lang racket

; nom1
; nom2

(provide reverse-tout)
(require (file "codedesdiapositives.rkt"))

Vous pouvez choisir entre l'un des gabarits suivants.
Supprimez celui que vous n'utilisez pas.


(define reverse-tout
  (λ (ls)
    (define iter
      (λ (in out)
        (cond
          [(null? in) out]
          [(atom? (car in)) (cons out a)]
          [else(cons )])))
    
    (iter ls '())))

(define reverse-tout
  (λ (ls)
    "votre code"))
