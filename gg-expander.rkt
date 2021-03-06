#lang br/quicklang
(require (for-syntax syntax/strip-context syntax/parse))
(require graph sugar)
(require "gen-graph-structs.rkt")

(define-macro (gg-module-begin (gg (nodes-section NODE-LINE ...) (edges-section EDGE-LINE ...)))
  (with-syntax ([REPLACED (replace-context caller-stx #'val)])
    (syntax/loc caller-stx
      (#%module-begin
       (nodes-section NODE-LINE ...)
       (define REPLACED (edges-section EDGE-LINE ...))
       (provide REPLACED)))))
(provide (rename-out [gg-module-begin #%module-begin]) #%top-interaction)

(define-macro (nodes-section NODE-LINE ...) (syntax/loc caller-stx (begin NODE-LINE ...)))
(provide nodes-section)

(define-macro-cases node-line
  [(_ NUMBER (selected-conjunct CONJUNCT) GEN-RANGE)
   (with-pattern ([NODE-NUM (prefix-id "node-" #'NUMBER)])
     (syntax/loc caller-stx
       (define NODE-NUM
         (gen-node CONJUNCT NUMBER GEN-RANGE #t #t))))]
  [(_ NUMBER (unselected-conjunct CONJUNCT) GEN-RANGE)
   (with-pattern ([NODE-NUM (prefix-id "node-" #'NUMBER)])
     (syntax/loc caller-stx
       (define NODE-NUM
         (gen-node CONJUNCT NUMBER GEN-RANGE #f #t))))]
  [(_ NUMBER (selected-conjunct CONJUNCT))
   (with-pattern ([NODE-NUM (prefix-id "node-" #'NUMBER)])
     (syntax/loc caller-stx
       (define NODE-NUM (gen-node CONJUNCT NUMBER #f #t #t))))]
  [(_ NUMBER (unselected-conjunct CONJUNCT))
   (with-pattern ([NODE-NUM (prefix-id "node-" #'NUMBER)])
     (syntax/loc caller-stx
       (define NODE-NUM (gen-node CONJUNCT NUMBER #f #f #t))))])
(provide node-line)

(define-macro-cases generation-range
  [(_ RDEPTH NUM) (syntax/loc caller-stx (gen RDEPTH NUM))]
  [(_ RDEPTH1 RDEPTH2 ASC? NUM) (syntax/loc caller-stx (gen-range RDEPTH1 RDEPTH2 NUM ASC?))])
(provide generation-range)

(define-syntax (recursion-depth stx)
  (syntax-parse stx
    [(_ num:number) (syntax/loc stx num)]
    [(_ sym:str) (syntax/loc stx (->symbol sym))]
    [(_ sym:str "+" num:number) (syntax/loc stx (symsum (->symbol sym) num))]
    [(_ sym:str "-" num:number) (syntax/loc stx (symsum (->symbol sym) (- num)))]))
(provide recursion-depth)

(define-macro (symbol-sum SYM NUM) (syntax/loc caller-stx (symsum SYM NUM)))
(provide symbol-sum)

(define-macro (edges-section EDGE-LINE ...)
  (syntax/loc caller-stx
    (unweighted-graph/directed (append EDGE-LINE ...))))
(provide edges-section)

(define-macro-cases edge-line
  [(_ START DEST)
   (with-pattern ([START-ID (prefix-id "node-" #'START)]
                  [DEST-ID (prefix-id "node-" #'DEST)])
     (syntax/loc caller-stx
       (list (list START-ID DEST-ID))))]
  [(_ START DEST0 DEST ...)
   (with-pattern ([START-ID (prefix-id "node-" #'START)]
                  [DEST0-ID (prefix-id "node-" #'DEST0)])
     (syntax/loc caller-stx
       (cons (list START-ID DEST0-ID)
             (edge-line START DEST ...))))])
(provide edge-line)

(require (only-in "at-expander.rkt" abstract-atom abstract-function abstract-g-variable abstract-a-variable abstract-list))
(provide abstract-atom abstract-function abstract-g-variable abstract-a-variable abstract-list)
(require (only-in "at-expander.rkt" multi-abstraction parameterized-abstract-conjunction
                  parameterized-abstract-atom parameterized-abstract-function
                  parameterized-abstract-a-variable parameterized-abstract-g-variable
                  parameterized-abstract-list init init-pair consecutive consecutive-pair
                  final final-pair))
(provide multi-abstraction parameterized-abstract-conjunction
         parameterized-abstract-atom parameterized-abstract-function
         parameterized-abstract-a-variable parameterized-abstract-g-variable
         parameterized-abstract-list init init-pair consecutive consecutive-pair
         final final-pair)