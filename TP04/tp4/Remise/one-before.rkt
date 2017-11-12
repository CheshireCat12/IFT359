#lang racket
(require (for-syntax (file "..\\stx-list-accessor.rkt")
                     racket/list))

(provide one-before)
(displayln "nom1, prénom1")
(displayln "nom2, prénom2")


(define-syntax one-before
  (λ (stx)
    (datum->syntax stx "vous devez supprimer cette ligne et ajouter votre code")))

;'(one-before)
;
;(one-before)
;
;'---------------
;(newline)
;'(one-before (+ 2 3))
;
;(one-before (+ 2 3))
;
;'---------------
;(newline)
;'(one-before (displayln "ligne 1")
;             (displayln "ligne 2")
;             (displayln "ligne 3")
;             (list 1 2 3 'but-last)
;             (displayln "last"))
;
;(one-before (displayln "ligne 1")
;            (displayln "ligne 2")
;            (displayln "ligne 3")
;            (list 1 2 3 'but-last)
;            (displayln "last"))
;'---------------
;(newline)
;'(one-before '(list 1 2 3 'but-last)
;             (displayln "last"))
;
;(one-before (list 1 2 3 'but-last)
;            (displayln "last"))
