#lang typed/racket

(require typed/rackunit)

(define (opr? [op : Symbol]) : Boolean
  (set-member? (set '+ '- '* '/) op))

(define-type Rule (U InScope SubTerm SetTerms))
(struct InScope ([name : Symbol]))
(struct SubTerm ([expr : Exp]))
(struct SetTerms ([terms : (Listof Exp)]))

(define-type Exp (U Real Symbol ArithExp Rule))
(struct ArithExp ([left : Exp] [op : Symbol] [right : Exp]) #:transparent)

(define-type Stmt (U BlockStmt IfStmt ReturnStmt AssignStmt))
(struct BlockStmt ([block : (Listof Stmt)]) #:transparent)
(struct IfStmt ([test : Exp] [then : Stmt] [else : Stmt]) #:transparent)
(struct ReturnStmt ([expr : Exp]) #:transparent)
(struct AssignStmt ([name : Symbol] [value : Exp]) #:transparent)


(define (parse-exp [s : Sexp]) : Exp
  (match s
    [(or (? integer?) (? symbol?)) s]
    [`(,left ,(and opr (? symbol?)) ,right) (ArithExp (parse-exp left) opr (parse-exp right))]
    [_ (error 'parse "unrecognized expression")]))


(define (parse-prog [s : Sexp]) : Stmt
  (BlockStmt (cast (map parse-stmt (cast s (Listof Sexp))) (Listof Stmt))))


(define (parse-stmt [s : Sexp]) : Stmt
  (match s
    [`(if ,test ,then ,else) (IfStmt (parse-exp test) (parse-stmt then) (parse-stmt else))]
    [`(return ,expr) (ReturnStmt (parse-exp expr))]
    [`(,(and name (? symbol?)) = ,val) (AssignStmt name (parse-exp val))]
    [`(,block ...) (BlockStmt (map parse-stmt (cast block (Listof Sexp))))]))





(parse-exp '(1 + 2))

(parse-prog '(
    (x = (3 + 5))
    (y = (80 / 2))
    (return ((x * y) * 1))
))


