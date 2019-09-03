#lang at-exp racket
(require graph
         cclp-common-data/abstract-multi-domain
         cclp-common-data/concrete-domain
         cclp-common-data/concrete-knowledge
         cclp-common/preprior-graph)

(require scribble/srcdoc)
(require (for-doc scribble/manual))

;(define primes-clauses
;  (map interpret-concrete-rule
;       (string-split
;        #<<HERE
;primes(N,Primes) :- integers(2,I),sift(I,Primes),length(Primes,N)
;integers(N,[])
;integers(N,[N|I]) :- plus(N,1,M),integers(M,I)
;sift([N|Ints],[N|Primes]) :- filter(N,Ints,F),sift(F,Primes)
;sift([],[])
;filter(N,[M|I],F) :- divides(N,M), filter(N,I,F)
;filter(N,[M|I],[M|F]) :- does_not_divide(N,M), filter(N,I,F)
;filter(N,[],[])
;length([],0)
;length([H|T],N) :- minus(N,1,M),length(T,M)
;HERE
;        "\n")))
;(provide primes-clauses)
;
;(define primes-full-evals
;  (interpret-full-eval-section
;   #<<HERE
;plus(g1,g2,a1) -> a1/g3.
;minus(g1,g2,a1) -> a1/g3.
;divides(g1,g2).
;does_not_divide(g1,g2).
;HERE
;   ))
;(provide primes-full-evals)
;
;(define primes-consts (list (function 'nil (list))))
;(provide primes-consts)
;
;(define permsort-clauses
;  (map interpret-concrete-rule
;       (string-split
;        #<<HERE
;sort(X,Y) :- perm(X,Y),ord(Y)
;perm([],[])
;perm([X|Y],[U|V]) :- del(U,[X|Y],W),perm(W,V)
;ord([])
;ord([X])
;ord([X,Y|Z]) :- lte(X,Y),ord([Y|Z])
;HERE
;        "\n")))
;(provide permsort-clauses)
;
;(define permsort-full-evals
;  (interpret-full-eval-section
;   #<<HERE
;lte(g1,g2).
;del(a1,[g1|g2],a2) -> a1/g3,a2/g4.
;HERE
;   ))
;(provide permsort-full-evals)
;
;(define permsort-consts (list (function 'nil (list))))
;(provide permsort-consts)
;
;(define permsort-prior (mk-preprior-graph)) ; TODO
;(provide permsort-prior)