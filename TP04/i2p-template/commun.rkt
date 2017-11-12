#lang racket
(require racket/trace)
(provide constant? atom? variable? element?  unaire? binaire? n-aire? operator? sym->fn ¬ ∧ ∨ → ← ☀ pr)

#|Je vous rappelle que votre code ne doit pas dépendre de la façon dont sont implémentés les fonctions.
  Vous serez tester avec les mêmes fonctions (même interface) mais avec une implémentation différentes. |#

(define constant?
  (λ (e) (or (eq? e #t) (eq? e #f))))

(define atom?
  (λ (e) (or (constant? e) (symbol? e))))

(define operator? 
  (λ (x) (member x '(¬ ∧ ∨ → ← ☀))))

(define variable? 
  (λ (x) (and (symbol? x) (not (operator? x)))))

(define element?
  (λ (e) (or (constant? e) (variable? e))))

(define unaire? 
  (λ (e)
    (eq? e '¬)))

(define binaire?
  (λ (e)
    (or (eq? e '→)(eq? e '☀) (eq? e '←))))
(trace binaire?)

(define n-aire?
  (λ (e)
    (and (operator? e) (not (unaire? e)) (not (binaire? e)))))

(define sym->fn
  ;; on peut assumer que ¬ a toujours la priorité la plus basse
  (λ (symb)
    (case symb
      [(¬) ¬]
      [(∧) ∧]
      [(∨) ∨]
      [(→) →]
      [(←) ←]
      [(☀) ☀])))

(define  ¬
  (λ (e)
    (not e)))

(define  ∧
  (λ e
    (if (null? e)
        #t
        (and (car e) (apply ∧ (cdr e))))))

(define  ∨
  (λ e
    (cond [(null? e)
           #f]
          [(car e) 
           #t]
          [else
           (apply ∨ (cdr e))])))

(define →
  (λ e (∨ (¬ (car e)) 
          (cadr e))))
(define ←
  (λ e (∨ (car e)
          (¬ (cadr e)))))

(define ☀ ; ou exclusif (prendre 8891 ⊻)
  (λ e (∨ (∧ (car e) (¬ (cadr e))) (∧ (¬ (car e)) (cadr e)))))

(define pr
  ;; "on peut assumer que ¬ a toujours la priorité la plus haute"
  ;; la fonction priorité est antimonotone
  (λ (op)
    (case op
      [(¬) 1]
      [(∧) 2]
      [(∨) 3]
      [(☀) 3]
      [(→) 4]
      [(←) 5]
      [else
       (printf "~a n'est pas un op~%" op)])))

