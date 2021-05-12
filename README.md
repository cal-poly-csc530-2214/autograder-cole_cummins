## Autograder 

The autograder above can parse either an sexpression as defined by the following syntax
```
Prog = BlockStmt

Stmt = BlockStmt | v = Exp | return Exp | if Exp Stmt Stmt

Exp = v | Number | a opr b
```
And parse rules with the following syntax
```
InBounds = ? Symbol
SetTerms = { Rules ... }
```
A further addition to the project would be applying rules to a Program,
changing mpy to mpy tilda
