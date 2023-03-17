#| Lora Ma
ID: 1570935
CMPUT 325 LEC B1
Assignment 2 - Programming portion
|#

; Interpreter implemented to the assignment specifications.
; For my implementation, I have a n-v-map to implement context.
(defun fl-interp (E P)
    ; Context starts empty
    (interp-acc E P '())
)

; Accumulator to store name-value map for current context
; E is the expression, P is the user program,
; and n-v-map maps names to values.
(defun interp-acc (E P n-v-map)
    (cond
        ((atom E) (if (is-in-n-v-map E n-v-map)
            (xassoc E n-v-map)
            E
        ))
        (t
            (let* 
                (
                    (operator (car E)) ; operator
                    (args (cdr E)) ; list of arguments
                    (arity (get-arity args)) ; arity (number of arguments)
                    (a1 (car args)) ; first argument
                    (a2 (cadr args)) ; second argument
                )
                (cond
                    ; handle built-in functions
                    ((eq operator 'if) (if (interp-acc a1 P n-v-map) 
                        (interp-acc a2 P n-v-map)
                        (interp-acc (caddr args) P n-v-map)
                    ))
                    ((eq operator 'null) (null (interp-acc a1 P n-v-map)))
                    ((eq operator 'atom) (atom (interp-acc a1 P n-v-map)))
                    ((eq operator 'eq) (eq (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator 'first) (car (interp-acc a1 P n-v-map)))
                    ((eq operator 'rest) (cdr (interp-acc a1 P n-v-map)))
                    ((eq operator 'cons) (cons (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator 'equal) (equal (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator 'car) (car (interp-acc a1 P n-v-map)))
                    ((eq operator 'cdr) (cdr (interp-acc a1 P n-v-map)))
                    ((eq operator 'number) (numberp (interp-acc a1 P n-v-map)))
                    ((eq operator '+) (+ (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator '-) (- (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator '*) (* (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator '>) (> (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator '<) (< (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator '=) (= (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator 'and) (and (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator 'or) (or (interp-acc a1 P n-v-map) (interp-acc a2 P n-v-map)))
                    ((eq operator 'not) (not (interp-acc a1 P n-v-map)))

                    ; if operator is a user-defined function,
                    ;    then evaluate the arguments 
                    ;         and apply operator to the evaluated arguments 
                    ;             (applicative order reduction) 
                    ; check if operator is a user-defined function or a name in the n-v-map
                    ((or (is-user-fun operator P) (is-in-n-v-map operator n-v-map))
                        (let* 
                            (
                                (fun-name (xassoc operator n-v-map))
                                (fun (get-fun-recursive fun-name arity P))
                                (body (cadddr fun))
                                (new-n-v-map (build-n-v-map (cadr fun) args P n-v-map))
                            )
                            ; Recursion happens here. We evaluate the body of the functions
                            ; with the new context.
                            (interp-acc body P new-n-v-map)
                        )
                    )

                    ; otherwise operator is undefined (not intended to be a function),
                    ; the E is returned, as if it is quoted in lisp 
                    (t E)
                )
            )
        )
    )
)

; Substitute var with its value in the n-v-map if possible. Strategy:
; Check if var is really a variable. If it is in the n-v-map, it means
; it is a variable. If this is the case, we return the value from the name
; of the variable. Otherwise, it is not a variable and we just return var.
; Remember that a n-v-map is of the form ((X . 1) (Z . 3) ...).
(defun xassoc (var n-v-map)
    (if (null n-v-map)
        var
        (if (eq var (caar n-v-map))
            (cdar n-v-map)
            (xassoc var (cdr n-v-map))
        )
    )
)

; Evaluate arguments. Similar to evlis function in the example interpreter, but
; with user-defined functions P added
(defun evlis (args P n-v-map)
    (if (null args)
        nil
        (cons (interp-acc (car args) P n-v-map) (evlis (cdr args) P n-v-map))
    )
)

; Get arity. Basically just count the number of elements in the given list
(defun get-arity (args)
    (if (null args)
        0
        (+ 1 (get-arity (cdr args)))
    )
)

; Map names list to values list
; i.e. (X -> 1, Z -> 3) would be implemented as
; ((X . 1) (Z . 3))
(defun custom-map (names values)
    (if (null names)
        nil
        (cons (cons (car names) (car values)) (custom-map (cdr names) (cdr values)))
    )
)

; Build the name-value map required for the new context.
; Example context: (X -> 1, Z -> 3) would be implemented as
; ((X . 1) (Z . 3))
(defun build-n-v-map (names args P n-v-map)
    (custom-map
        names
        (evlis args P n-v-map)
    )
)

; Find if an operator is a name in the n-v-map.
; Simply recursively go through the n-v-map to see if there is a match.
(defun is-in-n-v-map (operator n-v-map)
    (if (null n-v-map)
        nil
        (let ((first-name (caar n-v-map)))
            (if (eq operator first-name)
                t
                (is-in-n-v-map operator (cdr n-v-map))
            )
        )
    )
)

; Find if an operator is a user-defined function in P.
; Simply recursively go through user-defined functions to see if there is a match.
(defun is-user-fun (operator P)
    (if (null P)
        nil
        (let ((first-name (caar P)))
            (if (eq operator first-name)
                t
                (is-user-fun operator (cdr P))
            )
        )
    )
)

; Recursively go through P to find the matching
; user-defined function. We check the name of the user-defined function
; and the arity.
(defun get-fun-recursive (fun-name fun-arity P)
    (if (null P)
        nil
        (let* 
            (
                (candidate (car P))
                (candidate-name (car candidate))
                (candidate-arity (get-arity (cadr candidate)))
            )
            (if (and (eq fun-name candidate-name) (eq fun-arity candidate-arity))
                candidate
                (get-fun-recursive fun-name fun-arity (cdr P))
            )
        )
    )
)
