; MIT License
;
; Copyright (c) 2016-2018 Vincent Nys
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
; 
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
; 
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

#lang at-exp racket
(require racket/struct
         scribble/srcdoc)
(require (for-doc scribble/manual))

(module+ test (require rackunit))

(struct
  a (index)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'a)
           (λ (obj) (list (a-index obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (display (format "a~a" (a-index obj)) out)))]
  #:methods
  gen:equal+hash
  [(define (equal-proc a1 a2 equal?-recur)
     (equal?-recur (a-index a1) (a-index a2)))
   (define (hash-proc my-a hash-recur)
     (hash-recur (a-index my-a)))
   (define (hash2-proc my-a hash2-recur)
     (hash2-recur (a-index my-a)))])
(provide
 (struct*-doc
  a
  ([index exact-positive-integer?])
  @{An abstract "any" variable.}))

(struct
  a* (multi-id atom-index local-index)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'a*)
           (λ (obj) (list (a*-multi-id obj) (a*-atom-index obj) (a*-local-index obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (display (format "a_{~a,~a,~a}" (a*-multi-id obj) (a*-atom-index obj) (a*-local-index obj)) out)))]
  #:methods
  gen:equal+hash
  [(define (equal-proc a*1 a*2 equal?-recur)
     (and (equal?-recur (a*-multi-id a*1) (a*-multi-id a*2))
          (equal?-recur (a*-atom-index a*1) (a*-atom-index a*2))
          (equal?-recur (a*-local-index a*1) (a*-local-index a*2))))
   (define (hash-proc my-a* hash-recur)
     (+ (hash-recur (a*-multi-id my-a*))
        (hash-recur (a*-atom-index my-a*))
        (hash-recur (a*-local-index my-a*))))
   (define (hash2-proc my-a* hash2-recur)
     (+ (hash2-recur (a*-multi-id my-a*))
        (hash2-recur (a*-atom-index my-a*))
        (hash2-recur (a*-local-index my-a*))))])
(provide
 (struct*-doc
  a*
  ([multi-id exact-positive-integer?] [atom-index (or/c 1 'L 'i 'i+1)] [local-index exact-positive-integer?])
  @{A template for abstract "any" variables inside a multi abstraction.}))

(struct
  g (index)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'g)
           (λ (obj) (list (g-index obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (display (format "g~a" (g-index obj)) out)))]
  #:methods
  gen:equal+hash
  [(define (equal-proc g1 g2 equal?-recur)
     (equal?-recur (g-index g1) (g-index g2)))
   (define (hash-proc my-g hash-recur)
     (hash-recur (g-index my-g)))
   (define (hash2-proc my-g hash2-recur)
     (hash2-recur (g-index my-g)))])
(provide
 (struct*-doc
  g
  ([index exact-positive-integer?])
  @{An abstract "ground" variable.}))

(struct
  g* (multi-id atom-index local-index)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'g*)
           (λ (obj) (list (g*-multi-id obj) (g*-atom-index obj) (g*-local-index obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (display (format "g_{~a,~a,~a}" (g*-multi-id obj) (g*-atom-index obj) (g*-local-index obj)) out)))]
  #:methods
  gen:equal+hash
  [(define (equal-proc g*1 g*2 equal?-recur)
     (and (equal?-recur (g*-multi-id g*1) (g*-multi-id g*2))
          (equal?-recur (g*-atom-index g*1) (g*-atom-index g*2))
          (equal?-recur (g*-local-index g*1) (g*-local-index g*2))))
   (define (hash-proc my-g* hash-recur)
     (+ (hash-recur (g*-multi-id my-g*))
        (hash-recur (g*-atom-index my-g*))
        (hash-recur (g*-local-index my-g*))))
   (define (hash2-proc my-g* hash2-recur)
     (+ (hash2-recur (g*-multi-id my-g*))
        (hash2-recur (g*-atom-index my-g*))
        (hash2-recur (g*-local-index my-g*))))])
(provide
 (struct*-doc
  g*
  ([multi-id exact-positive-integer?] [atom-index (or/c 1 'L 'i 'i+1)] [local-index exact-positive-integer?])
  @{A template for abstract "ground" variables inside a multi abstraction.}))

(define (abstract-variable? v)
  (or (a? v) (g? v)))
(provide
 (proc-doc/names
  abstract-variable?
  (-> any/c boolean?)
  (val)
  @{Test whether @racket[val] is an abstract variable.}))

(define (abstract-variable*? v)
  (or (a*? v) (g*? v)))
(provide
 (proc-doc/names
  abstract-variable*?
  (-> any/c boolean?)
  (val)
  @{Test whether @racket[val] is a template for an abstract variable.}))

(define (abstract-variable*-multi-id v)
  (match v [(or (a* mid _ _) (g* mid _ _)) mid]))
(provide
 (proc-doc/names
  abstract-variable*-multi-id
  (-> abstract-variable*? exact-positive-integer?)
  (v)
  @{Extract the subscript referring to the multi abstraction from @racket[v].}))

(define (avar-index v)
  (match v
    [(a i) i]
    [(g i) i]))
(provide
 (proc-doc/names
  avar-index
  (-> abstract-variable? exact-positive-integer?)
  (var)
  @{Extract the index from @racket[var].}))

(define (printed-form obj)
  (define str (open-output-string))
  (print obj str)
  (get-output-string str))

(struct
  abstract-function (functor args)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'abstract-function)
           (λ (obj) (list (abstract-function-functor obj) (abstract-function-args obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (if (null? (abstract-function-args obj))
             (display (abstract-function-functor obj) out)
             (display (format "~a(~a)" (abstract-function-functor obj) (string-join (map printed-form (abstract-function-args obj)) ",")) out))))]
  #:methods
  gen:equal+hash
  [(define (equal-proc af1 af2 equal?-recur)
     (and (equal?-recur (abstract-function-functor af1) (abstract-function-functor af2))
          (equal?-recur (abstract-function-args af1) (abstract-function-args af2))))
   (define (hash-proc af hash-recur)
     (+ (hash-recur (abstract-function-functor af))
        (hash-recur (abstract-function-args af))))
   (define (hash2-proc af hash2-recur)
     (+ (hash2-recur (abstract-function-functor af))
        (hash2-recur (abstract-function-args af))))])
(provide
 (struct*-doc
  abstract-function
  ([functor symbol?] [args (listof abstract-term?)])
  @{Abstract counterpart of a function.}))

(struct
  abstract-function* (functor args)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'abstract-function*)
           (λ (obj) (list (abstract-function*-functor obj) (abstract-function*-args obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (if (null? (abstract-function*-args obj))
             (display (abstract-function*-functor obj) out)
             (display (format "~a(~a)" (abstract-function*-functor obj) (string-join (map printed-form (abstract-function*-args obj)) ",")) out))))]
  #:methods
  gen:equal+hash
  [(define (equal-proc af*1 af*2 equal?-recur)
     (and (equal?-recur (abstract-function*-functor af*1) (abstract-function*-functor af*2))
          (equal?-recur (abstract-function*-args af*1) (abstract-function*-args af*2))))
   (define (hash-proc af* hash-recur)
     (+ (hash-recur (abstract-function*-functor af*))
        (hash-recur (abstract-function*-args af*))))
   (define (hash2-proc af* hash2-recur)
     (+ (hash2-recur (abstract-function*-functor af*))
        (hash2-recur (abstract-function*-args af*))))])
(provide
 (struct*-doc
  abstract-function*
  ([functor symbol?] [args (listof abstract-term*?)])
  @{A template for abstract functions occurring inside a multi abstraction.}))

(struct
  abstract-atom (symbol args)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'abstract-atom)
           (λ (obj) (list (abstract-atom-symbol obj) (abstract-atom-args obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (if (null? (abstract-atom-args obj))
             (display (abstract-atom-symbol obj) out)
             (display (format "~a(~a)" (abstract-atom-symbol obj) (string-join (map printed-form (abstract-atom-args obj)) ",")) out))))]
  #:methods
  gen:equal+hash
  [(define (equal-proc aa1 aa2 equal?-recur)
     (and (equal?-recur (abstract-atom-symbol aa1) (abstract-atom-symbol aa2))
          (equal?-recur (abstract-atom-args aa1) (abstract-atom-args aa2))))
   (define (hash-proc aa hash-recur)
     (+ (hash-recur (abstract-atom-symbol aa))
        (hash-recur (abstract-atom-args aa))))
   (define (hash2-proc aa hash2-recur)
     (+ (hash2-recur (abstract-atom-symbol aa))
        (hash2-recur (abstract-atom-args aa))))])
(provide
 (struct*-doc
  abstract-atom
  ([symbol symbol?] [args (listof abstract-term?)])
  @{Abstract counterpart of an atom.}))

(struct
  abstract-atom* (symbol args)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'abstract-atom*)
           (λ (obj) (list (abstract-atom*-symbol obj) (abstract-atom*-args obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (if (null? (abstract-atom*-args obj))
             (display (abstract-atom*-symbol obj) out)
             (display (format "~a(~a)" (abstract-atom*-symbol obj) (string-join (map printed-form (abstract-atom*-args obj)) ",")) out))))]
  #:methods
  gen:equal+hash
  [(define (equal-proc aa*1 aa*2 equal?-recur)
     (and (equal?-recur (abstract-atom*-symbol aa*1) (abstract-atom*-symbol aa*2))
          (equal?-recur (abstract-atom*-args aa*1) (abstract-atom*-args aa*2))))
   (define (hash-proc aa* hash-recur)
     (+ (hash-recur (abstract-atom*-symbol aa*))
        (hash-recur (abstract-atom*-args aa*))))
   (define (hash2-proc aa* hash2-recur)
     (+ (hash2-recur (abstract-atom*-symbol aa*))
        (hash2-recur (abstract-atom*-args aa*))))])
(provide
 (struct*-doc
  abstract-atom*
  ([symbol symbol?] [args (listof abstract-term*?)])
  @{A template for abstract atoms occurring inside a multi abstraction.}))

(struct
  simple-multi (conjunction init consecutive final)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'simple-multi)
           (λ (obj) (list (simple-multi-conjunction obj)
                          (simple-multi-init obj)
                          (simple-multi-consecutive obj)
                          (simple-multi-final obj)))) obj out mode)
         ;; print-as-expression is not relevant in this application
         (display (format "simple-multi(~a,~v,~v,~v)" (string-join (map printed-form (simple-multi-conjunction obj)) "∧") (simple-multi-init obj) (simple-multi-consecutive obj) (simple-multi-final obj)) out)))]
  #:methods
  gen:equal+hash
  [(define (equal-proc m1 m2 equal?-recur)
     (and (equal?-recur (simple-multi-conjunction m1) (simple-multi-conjunction m2))
          (equal?-recur (simple-multi-init m1) (simple-multi-init m2))
          (equal?-recur (simple-multi-consecutive m1) (simple-multi-consecutive m2))
          (equal?-recur (simple-multi-final m1) (simple-multi-final m2))))
   (define (hash-proc m hash-recur)
     (+ (hash-recur (simple-multi-conjunction m))
        (hash-recur (simple-multi-init m))
        (hash-recur (simple-multi-consecutive m))
        (hash-recur (simple-multi-final m))))
   (define (hash2-proc m hash2-recur)
     (+ (hash2-recur (simple-multi-conjunction m))
        (hash2-recur (simple-multi-init m))
        (hash2-recur (simple-multi-consecutive m))
        (hash2-recur (simple-multi-final m))))])
(provide
 (struct*-doc
  simple-multi
  ([conjunction (listof abstract-atom*?)]
   [init (listof (cons/c abstract-variable*? abstract-term?))]
   [consecutive (listof (cons/c abstract-variable*? abstract-term*?))]
   [final (listof (cons/c abstract-variable*? abstract-term?))])
  @{The multi abstraction.}))

(struct
  multi/annotations (multi ascending? rta)
  #:methods
  gen:custom-write
  [(define (write-proc obj out mode)
     (if (boolean? mode)
         ((make-constructor-style-printer
           (λ (obj) 'multi/annotations)
           (λ (obj) (list (multi/annotations-multi obj)
                          (multi/annotations-ascending? obj)
                          (multi/annotations-rta obj)))) obj out mode)
         (display
          (format
           "multi(~a,~v,~v,~v,~v,~v)"
           (string-join (map printed-form (simple-multi-conjunction (multi/annotations-multi obj))) "∧")
           (multi/annotations-ascending? obj)
           (simple-multi-init (multi/annotations-multi obj))
           (simple-multi-consecutive (multi/annotations-multi obj))
           (simple-multi-final (multi/annotations-multi obj))
           (multi/annotations-rta obj))
          out)))]
  #:methods
  gen:equal+hash
  [(define (equal-proc m1 m2 equal?-recur)
     (and (equal?-recur (multi/annotations-multi m1) (multi/annotations-multi m2))
          (equal?-recur (multi/annotations-ascending? m1) (multi/annotations-ascending? m2))
          (equal?-recur (multi/annotations-rta m1) (multi/annotations-rta m2))))
   (define (hash-proc m hash-recur)
     (+ (hash-recur (multi/annotations-multi m))
        (hash-recur (multi/annotations-ascending? m))
        (hash-recur (multi/annotations-rta m))))
   (define (hash2-proc m hash2-recur)
     (+ (hash2-recur (multi/annotations-multi m))
        (hash2-recur (multi/annotations-ascending? m))
        (hash2-recur (multi/annotations-rta m))))])
(provide
 (struct*-doc
  multi/annotations
  ([multi simple-multi?]
   [ascending? boolean?]
   [rta exact-nonnegative-integer?])
  @{The multi abstraction with required annotations for automated generalization.}))

(define (multi? m)
  (or (simple-multi? m)
      (multi/annotations? m)))
(provide multi?)

(define (multi-conjunction m)
  (match m
    [(or (simple-multi c _ _ _)
         (multi/annotations (simple-multi c _ _ _) _ _))
     c]))
(provide multi-conjunction)

(define (multi-init m)
  (match m
    [(or (simple-multi _ i _ _)
         (multi/annotations (simple-multi _ i _ _) _ _))
     i]))
(provide multi-init)

(define (multi-consecutive m)
  (match m
    [(or (simple-multi _ _ c _)
         (multi/annotations (simple-multi _ _ c _) _ _))
     c]))
(provide multi-consecutive)

(define (multi-final m)
  (match m
    [(or (simple-multi _ _ _ f)
         (multi/annotations (simple-multi _ _ _ f) _ _))
     f]))
(provide multi-final)

(define (abstract-term? elem)
  (or (abstract-variable? elem) (abstract-function? elem)))
(provide
 (proc-doc/names
  abstract-term?
  (-> any/c boolean?)
  (val)
  @{Test whether @racket[val] is an abstract term.}))

(define (abstract-conjunct? elem)
  (or (abstract-atom? elem) (multi? elem)))
(provide
 (proc-doc/names
  abstract-conjunct?
  (-> any/c boolean?)
  (val)
  @{Test whether @racket[val] is an abstract conjunct.}))

(define (abstract-term*? elem)
  (or (abstract-variable*? elem) (abstract-function*? elem)))
(provide
 (proc-doc/names
  abstract-term*?
  (-> any/c boolean?)
  (val)
  @{Test whether @racket[val] is a template for an abstract term.}))

; TODO: consider including multi abstraction, maybe its component parts as well
(define (abstract-domain-elem? elem)
  (or (abstract-atom? elem)
      (abstract-term? elem)
      ((listof abstract-atom?) elem)))
(provide
 (proc-doc/names
  abstract-domain-elem?
  (-> any/c boolean?)
  (val)
  @{Test whether @racket[val] is an element of the abstract domain.}))

(define (abstract-domain-elem*? elem)
  (or (abstract-domain-elem? elem)
      (multi? elem)
      ((listof abstract-conjunct?) elem)))
(provide
 (proc-doc/names
  abstract-domain-elem*?
  (-> any/c boolean?)
  (val)
  @{Test whether @racket[val] is an element of the abstract multi domain.}))

(define (avar*-local-index v)
  (match v
    [(a* _ _ i) i]
    [(g* _ _ i) i]))
(provide
 (proc-doc/names
  avar*-local-index
  (-> abstract-variable*? exact-positive-integer?)
  (v)
  @{Extract the final subscript from a parameterized abstract variable.}))