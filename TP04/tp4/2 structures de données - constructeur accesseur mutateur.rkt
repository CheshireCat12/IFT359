#lang racket

#|
   Ce fichier contient le code décrivant l'environnement d'exécution du méta-évaluateur.
   J'ai quand même conservé (sans raison valable) dans le méta-évaluateur, l'implémentation d'une sequence et du cond. 
|#
(require racket/trace
         (file "1 initialisation.rkt"))
;(provide (all-defined-out))
(provide empty-env?
         set-binding*!
         has-binding*?
         parent*
         set-modifié*!  ; pour l'affichage des environnements qui n'est pas fait
         global-env*
         no-env* ; seulement pour affichage et erreur
         datum   ; pour les expressions de type quoted ; retourne directement la valeur
         binding-id-value  ; retourne la valeur d'un identificateur dans un environnement mais sans chercher dans les parents
         set!-variable
         set!-value 
         define-variable 
         define-value 
         if-test
         if-then
         if-else
         begin-actions  ; les actions d'une expression 'begin
         procedure-parameters 
         procedure-body 
         procedure-env 
         cherche-identificateur  ; cherche dans la chaîne d'environnement* celui contenant l'identificateur et le retourne
         affiche-procedure
         user-proc-descr
         make-procedure
         extend-env*
         operator
         operands
         ; ce qui suit sont les prédicats qui retournent vrai si son argument est du bon type
         ; par exemple user-procedure? retourne vrai si c'est une λ définie dans le programme à exécuter
         user-procedure?
         primitive-procedure?
         primitive-implementation
         self-evaluating?
         variable?
         quoted?
         definition?
         assignment?
         if?
         and?
         begin?
         λ?
         or?
         let?
         letrec?
         cond?
         user-procedure?
         primitive-procedure?
         application?
         (all-from-out (file "1 initialisation.rkt")))
#| Idéalement le provide ne contient que les identificateurs de l'inteface que l'on veut offrir au client.
   Ceci nous laisse la liberté d'amiolorer l'implémentation.
   Beaucoup de code à la frontière entre le bas niveau et le méta-évaluateur
|#
#| Les env forment un arbre doublement chaîné, i.e. un noeud permet d'accéder à ses enfants et à son parent.
   Chaque chemin à partir d'une feuille dans l'arbre forme une liste se terminant par null.
   Un vecteur, nommé vect-env, permet d'accéder directement aux env à partir de leur numéro.
   La structure originale de Abelson et Sussman est beaucoup plus simple mais ne permet pas d'explorer
   facilement l'arbre des environnemts.

   Un env est une liste de 5 éléments :
   0) une table encodant les identificateurs avec leurs valeurs ;
   1) une liste des références sur ses enfants ;
   2) un booléen, nommé modifié qui indique si l'env a été modifié depuis son affichage ;
   3) no de l'env parent
   4) no ds le vecteur vecteur (utilisé uniquement pour vérifier la cohérence lors du débuggage).

  Un env* est une liste de env 
    Le suivant étant toujours le parent du précédent.
    Le dernier est empty-env. La racine de l'arbre.
|#

(define empty-env null)
(define nbre-max-env 30)
(define vect-env (make-vector nbre-max-env))
(define empty-env? null?)  ; interface
(define get-env* car)
(define parent* cdr)
(define bindings (curryr vector-ref 0))
(define bindings* (compose bindings car))

(define set-binding*! ; interface
  (λ (env* id val)
    (hash-set! (bindings* env*) id val)))

(define has-binding*?  ; interface
  (λ (env* id)
    (hash-has-key? (bindings* env*) id)))

(define binding-id-value   ; interface
  (λ (env* id)
    (hash-ref (bindings* env*) id)))

(define enfants (curryr vector-ref 1))
(define enfants* (compose enfants car))
(define add-enfant!
  (λ (env enfant)
    (let ([new-enfants (cons enfant (enfants env))])
      (vector-set! env 1 new-enfants))))
(define add-enfant*!
  (λ (env* enfant)
    (let ([new-enfants (cons enfant (enfants* env*))])
      (vector-set! (car env*) 1 new-enfants))))

(define no-parent (curryr vector-ref 3))
(define no-parent* (compose no-parent car))
(define no-env (curryr vector-ref 4))
(define no-env* (compose no-env car))   ; interface
; la section modifié est uniquement pour faciliter l'affichage des environnements
; pour le moment, je n'ai pas fait le module pour afficher l'environnement
(define modifié (curryr vector-ref 2))
(define modifié* (compose modifié car))
(define set-modifié! ; interface (mais seulement utile pour affichage)
  (λ (env valeur)
    (vector-set! env 2 valeur)))
(define set-modifié*!
  (λ (env* valeur)
    (vector-set! (car env*) 2 valeur)))

(define datum cadr) ; 

(define set!-variable cadr) ; interface
(define set!-value caddr)  ; interface

(define define-variable cadr)   ; interface
(define define-value caddr)  ; interface

(define if-test cadr)
(define if-then caddr)
(define if-else cadddr)

(define begin-actions cdr) ; interface

(define λ-parameters cadr) 
(define λ-body cddr) 
(define procedure-parameters cadr) ; interface
(define procedure-body caddr) ; interface
(define procedure-env cadddr) ; interface

(define operator car)
(define operands cdr)


(define make-env
  #| env == (binding, enfants, modifié, no-parent, no-env)
     binding   = une table encodant les identificateurs avec leurs valeurs ;
     enfants   = une liste des références sur ses enfants ;
     modifié   = un booléen, nommé modifié qui indique si l'env a été modifié depuis son affichage ;
     no-parent = no de l'env parent
     no-env    = no ds le vecteur vecteur (utilisé uniquement pour vérifier la cohérence lors du déverminage).

     input : une liste d'environnements
     output : une liste où un nouvel env vide est ajouté à l'input
  |#
  (let ([env-no 1])
    (λ (env*)
      (let* ([parent-no (no-env* env* )]
             [new-env (vector (make-hash) null #t parent-no env-no)])
        (add-enfant*! env* new-env)
        (vector-set! vect-env env-no new-env)
        (écrit "Création de env no ~a avec parent ~a~%"  env-no parent-no)
        (set! env-no (add1 env-no))
        (cons new-env env*)))))

(define cherche-identificateur ; interface
  ; utilisé pour eval-assignment
  ; À la frontière entre le bas niveau correspondant aux structures de données
  ; et les fonctinnalités propres à Racket
  ; il faudrait au moins déplacer dans le méta-évaluateur le code consistant à chercher dans parent
  
  (λ (id env*)
    (cond [(empty-env? env*) 
           env*]
          [(hash-has-key? (bindings* env*) id)
           (écrit "trouvé (~a --> ~a)~%" id (hash-ref (bindings* env*) id))
           env*]
          [else
           (let* ([parent (parent* env*)]
                  [no-parent (if (empty-env? parent) 'aucun (no-env* parent))])  ;;;;
             (écrit "cherche dans parent i.e. env ~a~%" no-parent)
             (cherche-identificateur id parent))])))

(define define-variable!
  (λ (var value env*)
    (if (hash-has-key? (bindings* env*) var) 
        (écrit "Variable ~a déja définie!\n"  var)
        (begin
          (hash-set! (bindings* env*) var value)
          (écrit "ajout, dans env ~a, du lien ~a --> ~a ~%"  (no-env* env*) var
                 (if (user-procedure? value)
                     (user-proc-descr value) value))
          (set-modifié*! env* #t)))))

(define user-proc-descr
  (λ (p)
    (let ([par-ls (procedure-parameters p)]
          [car-body (car (procedure-body p))]
          [n-env (no-env* (procedure-env p))])
      (format "(λ ~a ~a ...) env-no: ~a" par-ls car-body n-env))))

(define affiche-procedure
  (λ (parameters body env*)
    (écrit "--> procédure~%" )
    (écrit "       para : ~a ~%" parameters )
    (écrit "       body : ~a ~%" (car body) )
    (map (λ (x)(écrit "              ~a ~%"  x )) (cdr body))
    (écrit "       env  : ~a ~%"  (no-env* env*))))

(define make-procedure 
  (λ (exp env*)
    (affiche-procedure (λ-parameters exp) (λ-body exp) env*)
    (list 'procedure (λ-parameters exp) (λ-body exp) env*)))

(define extend-env*
  (λ (vars values env*)
    (let ([new-env* (make-env env*)])
      (écrit "Dans env ~a~%"(no-env* new-env*))
      (for-each (λ (var value) 
                  (define-variable! var value new-env*))
                vars values)
      new-env*)))

(define primitive-procedures
  (list (list '+ 'primitive +)
        (list '- 'primitive -)
        (list '* 'primitive *)
        (list '/ 'primitive /)
        (list '= 'primitive =)
        (list 'add1 'primitive add1)
        (list 'sub1 'primitive sub1)
        (list 'car 'primitive car)
        (list 'cdr 'primitive cdr)
        (list 'cons 'primitive cons)
        (list 'list 'primitive list)
        (list 'null? 'primitive null?)
        (list 'not 'primitive not)
        (list 'displayln 'primitive displayln)        
        ))

(define tagged-list?
  (λ (exp tag)
    (and (list? exp) (not (null? exp)) (eq? (car exp) tag))))

(define self-evaluating?
  (λ (exp)
    (or (number? exp) (char? exp) (boolean? exp) (string? exp))))

(define variable?
  (λ (exp) (symbol? exp)))

(define quoted?
  (λ (exp)
    (tagged-list? exp 'quote)))

(define definition?
  (λ (exp)
    (tagged-list? exp 'define)))

(define assignment?
  (λ (exp)
    (tagged-list? exp 'set!)))

(define if?
  (λ (exp)
    (tagged-list? exp  'if)))

(define and?
  (λ (exp)
    (tagged-list? exp 'and)))

(define begin?
  (λ (exp)
    (tagged-list? exp  'begin)))

(define λ?
  (λ (exp)
    (tagged-list? exp 'λ)))


(define or?
  (λ (exp)
    (tagged-list? exp 'or)))

(define let?
  (λ (exp)
    (tagged-list? exp 'let)))

(define letrec?
  (λ (exp)
    (tagged-list? exp 'letrec)))


(define cond? (λ (exp) (tagged-list? exp 'cond)))

(define user-procedure?
  (λ (exp) 
    (and (list? exp) (not (null? exp)) (eq? (car exp) 'procedure))))

(define primitive-procedure? 
  (λ (exp)
    (and (list? exp) (not (null? exp)) (eq? (car exp) 'primitive))))

(define application?
  (λ (exp)
    ; pair? n'est pas bon parce qu'on veut s'assurer 
    ; que c'est une liste propre
    (and (list? exp)
         (not (null? exp))
         ; idéalement il faudrait vérifier que le premier élément est une λ? (ou une procédure?),
         ; soit une liste (et ce récursivement) dont le premier élément est une λ? ou une procédure?
         ; et encore là il faudrait vérifier que si c'est une λ? que le résultat final est une procedure?
         ; bref, c'est une patche
         )))

(define primitive-implementation cadr)


(define global-env*
  (let* ([parent-no -1]
         [env-no 0]
         [new-env (vector (make-hash primitive-procedures) null #t parent-no env-no)])
    (vector-set! vect-env 0 new-env)     
    (cons new-env '())))

;(current-directory)




