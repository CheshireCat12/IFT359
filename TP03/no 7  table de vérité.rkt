#lang racket

;Chea, Dany 17 133 040
;Gillioz, Anthony 17 133 031

(provide map-ajoute-à-la-fin liste-de-cas table-de-vérité)

(define map-ajoute-à-la-fin
  (λ (a b)
    (map (λ(x y) (flatten (append x y))) a b)
    ))



(define produit-cartésien 
  (λ ls
    (define iterOnList
      (λ(liste produit)
        (cond
          [(null? liste) '()]
          [else(cons (cons (car liste) produit)
                     (iterOnList (cdr liste) produit))])))
    
    (define iterOnProduit
      (λ(liste produits)
        (cond
          [(null? produits) '()]
          [else(append (iterOnList liste (car produits))
                       (iterOnProduit liste (cdr produits)))])))

    (define iter
      (λ(liste produitTemp)
        (cond
          [(null? liste)  (map reverse produitTemp)]
          [else(iter (cdr liste) (iterOnProduit (car liste) produitTemp))])))
    (if (not (null? ls))
        (iter (cdr ls)(iterOnList (car ls) '()))
        '())
    ))

(define liste-de-cas 
  (λ (n)
    (define iter
      (λ(number proc)
        (if (eq? number 1)
            (proc '(#t #f))
            (iter (sub1 number) (curry proc '(#t #f))))))
    (iter n produit-cartésien)))


(define table-de-vérité
  (λ (fn)
    (let ([ls-cas (liste-de-cas (procedure-arity fn))])
      (define iterOnList
        (λ (sub-list val-history)
          (cond
            [(null? sub-list) val-history]
            [else (let ([val (apply fn (car sub-list))])
                    (iterOnList (cdr sub-list) (append val-history (list val)))
                    )])))
      (let ([ls-results (iterOnList ls-cas (list))])
        (cond
          [(andmap (λ(x) (eq? #t x)) ls-results)
           (writeln 'tautologie)]
          [(ormap (λ(x)(eq? #t x)) ls-results)
           (writeln 'aucune-des-deux)]
          [else (writeln 'contradiction)])  
        (map-ajoute-à-la-fin ls-cas ls-results))
      )))


(define ¬ not)
(define ∧ (λ (a b)(and a b)))
(define ∨ (λ (a b)(or a b)))
(define →
  (λ (a b)
    (∨ (¬ a) b)))

(define ↔
  (λ (a b) (∧ (→ a b) (→ b a))))

(define resol
  (λ (a b c)
    (and (or a b) (or c (not b)))))

(define expr1
  (λ (a b c)
    (→ (resol a b c) (∨ a c))))



