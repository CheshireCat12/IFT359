#lang racket
(require (for-syntax (file "..\\stx-list-accessor.rkt")
                     racket/list))

(provide  ~~)
(displayln "nom1, prénom1")
(displayln "nom2, prénom2")


(define-syntax ~~
  (λ (stx)
    (datum->syntax stx "vous devez supprimer cette ligne et ajouter votre code")))


;'(define b 'b-symbol)
;(define b 'b-symbol)
;'(define c 'c-symbol)
;(define c 'c-symbol)
;'(define trois 3)
;(define trois 3)
;'(define ls (list '+ '* '&))
;(define ls (list '+ '* '&))
;
;'---------------
;(newline)
;'(~~ bb)
;(~~ bb)
;
;'---------------
;(newline)
;'(~~ ~ trois)
;(~~ ~ trois)
;
;'---------------
;(newline)
;'(~~ a b (+ 1 2))
;(~~ a b (+ 1 2))
;
;'---------------
;(newline)
;'(~~ ~@ ls)
;(~~ ~@ ls)
;
;'---------------
;(newline)
;'(~~ ~ b ~ c (a b c))
;(~~ ~ b ~ c (a b c))
;'---------------
;(newline)
;'(~~ ~@ ls ~ b ~ c 1)
;(~~ ~@ ls ~ b ~ c 1)
;
;'---------------
;(newline)
;'(~~ x b ~ b y ~ (+ trois 5))
;(~~ x b ~ b y ~ (+ trois 5))
;'---------------
;(newline)
;'(~~ 3 ~@ ls ~@ (range 5) 12)
;(~~ 3 ~@ ls ~@ (range 5) 12)
