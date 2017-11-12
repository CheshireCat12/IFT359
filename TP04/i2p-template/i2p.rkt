#lang racket

(displayln "André Mayers")
(displayln "Diane Laroche")

(require (file ".\\commun.rkt")
         (file ".\\block.rkt")
         )
(require racket/match)
(require racket/trace)
(provide i->p setxx#t setxx#f)

(define xx #f)
(define setxx#t
  (λ ()
    (set! xx #t)))

(define setxx#f
  (λ ()
    (set! xx #f)))

(define i2p
  ;; le résultat contient des sous-expressions taguées block
  ;; il faut faire une passe sur le résultat pour enlever ces tags
  ;; mon implémentation contient 4 clauses
  (λ (e)
    (match e
      [_
       "votre code"])))

(define traiter-unaire
  (λ (e)
    (match e
      ;; par exemple (traiter-unaire '(¬ ¬ ¬ (a ∧ b) ∨ c ∧ d))
      ;; retourne deux valeurs (values (1) (2))
      ;; (1) l'expression correspondant à la partie unaire i.e. (¬ (¬ (¬ (∧ a b))))
      ;; (2) le reste non traité de l'expression i.e. (∨ c ∧ d)
  
      ;; mon implémentation contient 3 clauses : a) (¬ elt) ; b) (¬ ¬ expr)  ; c) (¬ expr)
      [_
       "votre code"])))


(define traiter-n-aire
  (λ (argg op argd reste)
    (define make-result
      (λ (template)
        (if (null? reste)
            template
            (traiter-n-aire template
                            (car reste)
                            (cadr reste)
                            (cddr reste)))))
    (match* (argg op argd reste)
      ;; si l'expression est (a → b ∨ c → d) alors (traiter-n-aire a → b (∨ c → d))
      
      ;; si l'expression est '(¬ ¬ a ∨ ¬ ¬ b) alors (traiter-n-aire '(¬ (¬ a)) '∨ '¬ '(¬ b))
      ;;; remarquer que argg est déjà traité (utilisation de traiter-unaire)
      
      ;; si l'expression est '((a ∨ b) ∧ c) alors (traiter-n-aire (block185816 ∨ a b) ∧ c ())
      ;;;  remarquer que argg est déjà traité (utilisation de (make-block (i->p (a ∨ b)))

      ;; mon implémentation contient 6 clauses
      
      ; (unaire? argd)_
       [(_ _ _ _)
       "votre code"])))

(define i->p
  (compose map-remove-block i2p))

(when xx (trace i2p traiter-n-aire))