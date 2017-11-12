#lang racket
(require racket/trace
         (file "2 structures de données - constructeur accesseur mutateur.rkt"))
(require racket/undefined)
(provide (all-defined-out)
         (all-from-out (file "2 structures de données - constructeur accesseur mutateur.rkt")))

(displayln "nom1, prénom1")
(displayln "nom2, prénom2")

#|
  Ce module contient le code immédiat permettant de simuler l'évaluation par environnement.
  Le fichier "2 structures de données - constructeur accesseur mutateur.rkt" contient
  l'implémentation des environnements et de plusieurs types d'expressions par exemple les procédures.
  Le TP3 consistant à ajouter le let-rec, j'ai voulu donner des exemples pour implémenter les accesseurs
  de plusieurs types d'expressions. Pour cette raison, j'ai conservé ici les accesseurs
  pour les expressions de type let, sequence, cond ...  
|#

(define eval 
  (λ (exp env*)
    ; il faudrait ajouter le cas où exp est "exit" ou "stop"
    (écrit "Évaluation de ~a~%"  exp)
    (cond [(self-evaluating? exp)
           (écrit "--> ~a~%"  exp)
           exp]
          [(variable? exp) 
           (lookup-variable-value exp env*)]
          [(quoted? exp) 
           (écrit "--> ~a~%"  exp)
           (datum exp)]
          [(definition? exp)
           (eval-definition exp env*)]
          [(assignment? exp) 
           (eval-assignment exp env*)]
          [(if? exp) 
           (eval-if exp env*)]
          [(and? exp) 
           (eval-and exp env*)]
          [(cond? exp) 
           (eval (cond->if exp) env*)]
          [(begin? exp) 
           (eval-sequence (begin-actions exp) env*)]
          [(λ? exp)
           (make-procedure exp env*)]
          [(or? exp) 
           (eval-or exp env*)]
          
          [(let? exp)
           (eval (let->application exp) env*)]
          
          [(letrec? exp)
           (eval-letrec exp env*)]
          
          [(application? exp)
           (+indent)  ; la description de l'exécution d'une application est mise en relief par l'indentation         
           (let ([val (apply* (eval (operator exp) env*) 
                              (list-of-values (operands exp) env*))])
             (écrit "Retour à env ~a~%" (no-env* env*))
             (-indent)
             val)]
          [else
           (écrit "expression inconnue :~a!\n"  exp)])))

(define eval-letrec
  (λ (exp env*)
    '-àfaire-))


(define lookup-variable-value
  ; à la frontière entre le bas niveau correspondant aux structures de données
  ; et les fonctinnalités propres à Racket
  ; il faudrait au moins déplacer les hash-ref hash-has-key ...
  (λ (var env*)
    (when (empty-env? env*)
      (erreur 'lookup-variable-value "~a absent de env* "  var))
    (écrit "cherche l'identificateur \"~a\" dans env ~a :~%"  var (no-env* env*))
    (cond 
      [(has-binding*? env* var) 
       (let ([val (binding-id-value env* var)])
         (cond
           [(eq? undefined val)
            (erreur 'lookup-variable-value "~a = undefined dans env no ~a"  var (no-env* env*))]
           [(user-procedure? val)
            (affiche-procedure
             (procedure-parameters val)
             (procedure-body val)
             (procedure-env val))]
           [else
            (écrit " --> ~a~%"  val)])
         val)]
      [else
       (+indent)
       (écrit "cherche dans parent ~%" )
       (let ([val (lookup-variable-value var (parent* env*))])
         (-indent)
         val
         )])))

(define eval-assignment 
  (λ (exp env*)
    (let* ([var (set!-variable exp)]
           ; il faut vérifier si on ne regarde pas avant si var existe dans env*
           [valeur (eval (set!-value exp) env*)]
           [env-trouvé (begin
                         (écrit "cherche l'identificateur \"~a\" dans env ~a :~%"  (set!-variable exp) (no-env* env*))
                         (cherche-identificateur (set!-variable exp) env*))])
      (when (empty-env? env-trouvé)
        (erreur 'eval-assignment "~a non trouvé à partir de env* no ~a"  var (no-env* env*)))
      (set-binding*! env-trouvé (set!-value exp) valeur)
      (écrit "modification, dans env ~a, du lien, maintenant ~a --> ~a ~%"  (no-env* env*) var
             (if (user-procedure? valeur) "procédure qui vient d'être retournée" valeur)
             )
      (set-modifié*! env* #t))))

(define ajout-identificateur-env
  (λ (id env*)
    (cond [(has-binding*? env* id)
           (erreur 'ajout-identificateur-env "erreur, ~a déja présent dans env ~a"  id (no-env* env*))]
          [else
           ; (displayln id)
           (set-binding*! env* id undefined)
           (écrit "ajout, dans env ~a, du lien ~a --> undefined ~%"  (no-env* env*) id)
           (set-modifié*! env* #t)])))

(define eval-definition
  (λ (exp env*)
    (let ([var (define-variable exp)])
      (cond
        [(not (has-binding*? env* var))
         ;; Comme notre simulation est pour un module et non les énonces un par un du REPL,
         ;; tous les id d'un bloc lexical sont ajoutés avant dans l'env.
         ;; Par contre je n'ai pas vérifié si les définitions étaient permises ;
         ;; par exmple, certaines devaient être au début du bloc lexical
         (erreur 'eval-definition " ~a _ erreur, ~a n'a pas été auparavant ajouté à env no ~a"  exp var (no-env* env*))]
        [(not (eq? (binding-id-value env* var) undefined))
         (erreur 'eval-definition " ~a _ erreur, ~a déja présent dans env ~a"  exp var (no-env* env*))] 
        [else
         (+indent)
         (define-variable! 
           var
           (eval (define-value exp) env*) 
           env*)
         (-indent)
         ; comme le retour de define-variable est toujours #<void> alors la ligne suivante est un raccourci
         (écrit "--> #<void>~%" )]))))

(define define-variable!
  (λ (var value env*)
    (set-binding*! env* var value)
    (écrit "complétion, dans env ~a, du lien ~a --> ~a ~%"  (no-env* env*) var
           (if (user-procedure? value)  ;; pour ne pas surcharger l'affichage
               "procédure qui vient d'être retournée"
               value))
    (set-modifié*! env* #t)))

(define eval-if 
  (λ (exp env*)
    (if (eval (if-test exp) env*)
        (eval (if-then exp) env*)
        (eval (if-else exp) env*))))

(define eval-and
  (λ (exp env*)
    (let iter ([res #t]
               [reste (cdr exp)])
      (if (null? reste) 
          res
          (let ([val (eval (car reste) env*)])
            (if val (iter val (cdr reste))
                #f))))))

(define eval-sequence
  (λ (seq env*)
    (for-each (λ (in)
                (when (eq? (car in) 'define)
                  (ajout-identificateur-env (define-variable in) env*)))
              seq)
    (let loop ([seq seq])
      (cond [(null? (cdr seq)) 
             (eval (car seq) env*)]
            [else (eval (car seq) env*) 
                  (loop (cdr seq))]))))

(define list-of-values 
  ; pour évaluer les opérandes dans une application
  (λ (exps env*)
    (map (λ (e) 
           (eval e env*)) 
         exps)))

(define apply* 
  (λ (procedure arguments)
    (cond [(primitive-procedure? procedure) 
           (apply-primitive-procedure procedure arguments)]
          [(user-procedure? procedure)
           (let ([n-env (extend-env* (procedure-parameters procedure) 
                                     arguments 
                                     (procedure-env procedure))])
             (eval-sequence
              (procedure-body procedure)
              n-env))]
          [else
           (erreur 'apply* "(~a ~a) ~a n'est pas une procédure" procedure arguments procedure)])))

(define apply-primitive-procedure
  (λ (pp args)
    (let ([val (apply (primitive-implementation pp) args)])
      (écrit "Dans env-global~%")
      (écrit "Évaluation de ~a ~%"(cons pp args))
      (écrit "--> ~a~%" val)
      val)))

(define cond->if
  (λ (exp) (expand-clauses (cond-clauses exp))))

(define cond-clauses cdr)
(define cond-predicate car)
(define cond-actions cdr)

(define cond-else-clause? 
  (λ (clause)
    (eq? (cond-predicate clause) 'else)))

(define expand-clauses 
  (λ (clauses)
    (if (null? clauses)
        #f      
        (let ([first (car clauses)]
              [rest (cdr clauses)])
          (if (cond-else-clause? first)
              (if (null? rest)
                  (sequence->exp (cond-actions first))
                  (écrit "ELSE clause isn't last"))
              (make-if (cond-predicate first)
                       (sequence->exp (cond-actions first))
                       (expand-clauses rest)))))))
(define var-let 
  (λ (exp)
    (map car (cadr exp))))

(define val-let 
  (λ (exp)
    (map cadr (cadr exp))))

(define body-let cddr)


(define make-if 
  (λ (test then else)
    (list 'if test then else)))

(define (sequence->exp seq)
  (cond  [(null? seq) seq]
         [(null? (cdr seq)) (car seq)]
         [else (make-begin seq)]))

(define make-begin 
  (λ (seq) (cons 'begin seq)))

(define let->application
  (λ (exp)
    (écrit "Ré-écriture du let sous forme ((λ (...) ...)...)~%" )
    (cons (cons 'λ (cons (var-let exp) 
                         (body-let exp) )) 
          (val-let exp)))) 

(define eval-or
  (λ (exp env*)
    (let iter ([reste (cdr exp)])
      (if (null? reste) 
          #f
          (let ([val (eval (car reste) env*)])
            (if val val
                (iter (cdr reste))))))))

;(current-directory)

