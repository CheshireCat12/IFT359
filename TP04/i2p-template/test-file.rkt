#lang racket
(require racket/match
         racket/trace)
(require (file "i2p.rkt")
         (file "block.rkt"))

(define test
  (λ (exp rep)
   (let ([xx (i->p exp)]) 
    (printf "~a~n~a~n~a~n~a~n ~n"
            exp
            xx
            rep
            (equal? xx rep))
     )))

(setxx#f)

(displayln "test de l'associativité à gauche simple")
(test '(a ∨ b)
      '(∨ a b))
(test '(a ∨ b ∨ c )
      '(∨ a b c))
(test '(a ∨ b ∨ c ∨ d)
      '(∨ a b c d))

(displayln "test de l'associativité à droite")
(test '(a ∨ b ∧ c )
      '(∨ a (∧ b c)))
(test '(a ∨ b ∧ c ∨ d)
      '(∨ a (∧ b c) d))
(test '(a ∨ b ☀ c )
      '(∨ a (☀ b c)))
(test '(a ∨ b ☀ c ∨ d)
      '(∨ a (☀ b c) d))
(test '(a ∧ b ☀ c ∧ d)
      '(☀ (∧ a b) (∧ c d)))

(displayln "test avec expression parenthésée")
(test '((a → b) ∧ c)
      '(∧ (→ a b) c))
(test '(a ∧ (b → c) ∧ d)
      '(∧ a (→ b c) d))

(test '(a ∧ (b ∨ (c → d)) ∧ e)
      '(∧ a (∨ b (→ c d)) e))


(displayln "test avec unaire")
(test '(¬ a ∨ b)
      '(∨ (¬ a) b))
(test '(¬ a ∨ b ∧ d)
      '(∨(¬ a) (∧ b d)))
(test '(¬ (a ∨ b) ∧ d)
      '(∧ (¬ (∨ a b)) d))
(test '(c ∧ ¬ ¬ ¬ d)
      '(∧ c (¬ (¬ (¬ d)))))


(displayln "test de l'associativité à droite + ")
(displayln "avec même opérateur non binaire")
(test '(a ∨ b ∧ c ∧ d ∨ e)
      '(∨ a (∧ b c d) e))
(test '(a ∨ b ∨ c ∧ d ∧ e ∨ f)
      '(∨ a b (∧ c d e) f))
(test '(a → b ∨ c ∨ d → e)
      '(→ (→ a (∨ b c d)) e))

(displayln "test de l'associativité à droite + ")
(displayln "avec même opérateur binaire")
(test '(a → b ☀ c ☀ d → e)
      '(→ (→ a (☀ (☀ b c) d)) e))

(displayln "test du cas général ")
(test '(a → b → ¬ ¬ d)
      '(→ (→ a b) (¬ (¬ d))))
(test '(a → b ∨ c ∨ ¬ ¬ d)
      '(→ a (∨ b c (¬ (¬ d)))))
(test '(a → b ∨ c → d)
      '(→ (→ a (∨ b c)) d))

(test '(a ∨ ¬ ¬ b ∨ ¬ c ☀ d)
      '(∨ a (¬ (¬ b)) (☀ (¬ c) d)))

(test '((a → b) ∨ (c → d) ∧ e ∧ f ∨ g)
      '(∨ (→ a b) (∧ (→ c d) e f) g))
(test '((a → b) ∨ ((c → d) ∧ e ∧ f) ∨ g)
      '(∨ (→ a b) (∧ (→ c d) e f) g))
(test '(((a → b) ∨ (c → d)) ∧ e ∧ f ∨ g)
      '(∨ (∧ (∨ (→ a b) (→ c d)) e f) g))

(test '((a ∨ b) ☀ c )
      '(☀ (∨ a b) c))
