#lang racket

(require (for-syntax (file "..\\stx-list-accessor.rkt")
                     racket/list))

(provide apply)
(displayln "nom1, prénom1")
(displayln "nom2, prénom2")

(define-syntax apply
  (λ (stx)
    (datum->syntax stx "vous devez supprimer cette ligne et ajouter votre code")))

;'(apply + 1 2 3 '(4 5))
;(apply + 1 2 3 '(4 5))
;'(apply + '(4 5))
;(apply + '(4 5))