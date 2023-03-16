;QUESTION 1

;What the function does: It counts the amount of times E occurs in a L

;How it works: It first checks if L is an atom. If it is an atom, it then checks if L is the element E we are looking for. If it is, we return 1, otherwise, we return 0. If L is not an atom, we recursively check the first element of L. Then we sum up the 0's and 1's that are returned recursively to get the sum of how many times E occurs in L

;Testcases:
;>(occurs 'a '(a (a b) ((c) a)))
;3

;>(occurs 'a '(a (a (b)) b))
;2

;>(occurs 'a '(d (nil (b)) b))
;0

(defun occurs (E L)
    (if (atom L)
        (if (eq E L) 1 0)
        ;add up the 1's and 0's that result from recursively calling the list
        (+ (occurs E (car L)) (occurs E (cdr L)))))


;QUESTION 2

;What the function does: It flattens the list so that a list of atoms is returned with all atoms that are in x appearing in the result and in the same order.

;How it works: Base case: when x is null (at the end of a list). It checks if the first item in x is an atom. If it is, it puts it into a list with the element that returns from recursively calling the rest of xflatten x. Basically this results in a chain of cons such that xflatten '(A (B) C) results in (cons A (cons B (cons C '()))) which equals (A B C). If the first element of x is not an atom, we can assume it is a list and then recursively call this function on the first element of the list and the rest of the elements from the list.

;Testcases: 
; >(xflatten '(a (b c) d))
; (a b c d)

; >(xflatten '((((a))))) 
; (a)

; >(xflatten '(a (b c) (d ((e)) f)))
; (a b c d e f)

; >(xflatten '(a (b nil c) nil (d ((e)) f)))
; (a b nil c nil d e f)

(defun xflatten (x)
    (if (null x)
        '()
        (if (atom (car x))
            ;if it is an atom, add it to the list and recursively call the rest of the list
            (cons (car x) (xflatten (cdr x)))
            ;append the first element of list flattened with the rest of the list flattened
            (append (xflatten (car x)) (xflatten (cdr x))))))


;QUESTION 3

;What the function does: It removes duplicates from the list and returns the rest of the list without duplicates

;How it works: It checks if the first element of x exists in the rest of the elements of x. If it does, then it calles remove-duplicate with the rest of the elements in x without the first element. This is how we remove a duplicate element. Otherwise if it doesn't exist in the rest of x, we just move on to check the next element.

;Testcases:
; >(remove-duplicate '(a b c a d b))
; (a b c d)
; or
; (c a d b)

(defun remove-duplicate (x) 
    (if (null x)
        x
        (if (eq 0 (occurs (car x) (cdr x)))
            ;if not in list just add to resulting list and recursively call rest of list
            (cons (car x) (remove-duplicate(cdr x)))
            ;otherwise skip the item and recursively call rest of the list
            (remove-duplicate(cdr x)))))


;QUESTION 4A

;What the function does: It returns one list that has the elements from L2 and L1 combined but alternating -- L1 = '(A B C) and L2 = '(D E F), mix(L1 L2) = '(D A E B F C)

;How it works: If there are no elements left in L1, it returns L2 and if no elements are left in L2, it returns L1. If both lists contain items, it recursively calls the first element of L2 to be combined with the first element of L1 until either lists run out of items

;Testcases:
; >(mix '(a b c) '(d e f))
; (d a e b f c)

; >(mix '(1 2 3) '(a))
; (a 1 2 3)

; >(mix '((a) (b c)) '(d e f g h)) 
; (d (a) e (b c) f g h)

; >(mix '(1 2 3) nil)
; (1 2 3)

; >(mix '(1 2 3) '(nil))
; (nil 1 2 3)

(defun mix (L1 L2)
    (if (null L1) 
        L2
        (if (null L2) 
            L1
            ;cons the first element from second list with first item of first list and recursively calls mix with the rest of the two functions
            (cons (car L2) (cons (car L1) (mix (cdr L1) (cdr L2)))))))


;QUESTION 4B

;What the function does: It creates a list with two lists. The first sublist contains all the even elements from L and the second sublist contains all the odd elements from L

;How it works: It calls the helper functions get_even for the even list and the helper function get_odd for the odd list

; >(split '(1 2 3 4 5 6))
; ((2 4 6) (1 3 5))

; >(split '((a) (b c) (d e f) g h)) 
; (((b c) g) ((a) (d e f) h))

; >(split '())
; (nil nil)

(defun split (L)
    (list (get_even L) (get_odd L)))

;Helper function

;What the function does: It returns a list with all the even elements from L

;How it works: It creates a list with the second element of L and with the result from recursively calling the function and passing in a list from the third element to the end of the list.

(defun get_even (L)
    (if (and (car (cdr L)))
        (cons (car (cdr L)) (get_even (cdr (cdr L))))))

;Helper function

;What the function does: It returns a list with all the odd elements from L

;How it works: It creates a list with the first element of L and with the result from recursively calling the function and passing in a list from the third element to the end of the list.

(defun get_odd (L)
    (if (and (car L))
        (cons (car L) (get_odd (cdr (cdr L))))))


;QUESTION 5

;What the function does: Generates all the subsets of L with no repeats

;How it works: It appends the subsets generated by gen-subsets using the first item of the list with the subsets that are generated by recursively calling the rest of the list

;Testcases:
; >(allsubsets nil)
; > (nil)

; >(allsubsets '(a))
; >(nil (a)) 

; >(allsubsets '(a b))
; >(nil (a) (b) (a b))

(defun allsubsets (L)
    (if L
        ;append subsets for first item of the list and subsets for the rest of list together
        (append (gen-subsets (car L) (allsubsets (cdr L))) (allsubsets (cdr L)))
        '(())
    )
)

;Helper function

;What the function does: Creates subsets by putting A in every sublist in B

;How it works: It creates a list of lists that each contain a subset. It puts A in each sublist in B.

;Testcases:
; > (gen-subsets 'A '(B))
; > (((A . B)))
;
; > (gen-subsets 'A '((B C) (B) (C) NIL))
; > ((A B C) (A B) (A C) (A))

(defun gen-subsets (A L)
    (if L
        (cons (cons A (car L)) (gen-subsets A (cdr L))
        )
        '()
    )
)


;QUESTION 6

;What the function does: Replaces each occurrence of atom A in the list L with the expression E. 

;How it works: When the first element of L is an atom and equal to A, we add E to the list and recursively call this function with the rest of L. When the first element of L is an atom but not equal to A, we just add whatever was the first element to the list and continue recursively calling the rest of the list. If the first element of the list is not an atom, we call recursievely call this function and pass in the inner list.

;Testcases:
; > (substitute0 'a 'b '(a (a 2) (1 2 a)))
; (b (b 2) (1 2 b))

; > (substitute0 'a 'b '(1 2 3))
; (1 2 3)

; > (substitute0 'a '(1 2) '(a (b a) (c e) (a)))
; ((1 2) (B (1 2)) (C E) ((1 2)))

(defun substitute0 (A E L)
    (if L 
        (cond
            ;If first item of L an atom and equal to A, cons E and recursively call rest of list
            ((and (atom (car L)) (eq A (car L))) (cons E (substitute0 A E (cdr L))))
            ;If first item of L an atom and NOT equal to A, cons first item and recursively call rest of list
            ((atom (car L)) (cons (car L) (substitute0 A E (cdr L))))
            ;If first item of L is a list, pass that list into the function and recursively call rest of list
            (t (cons (substitute0 A E (car L)) (substitute0 A E (cdr L))))
        )
    )
)

;QUESTION 7A

(defun checker (a L)
    (if (eq a (car L))
        (car (cdr L))
    )
)


;Checks if x has a connection in L and adds to L1 if it does
(defun iterate-list (L1 a x L original-L)
    (if (null L)
        L1
        (let ((c (checker a (car L))))
            (if (and (not (eq x c)) (and c (not (eq c a))))
                (append (iterate-list (append L1 (list c)) a x (cdr L) original-L) (iterate-list '() c x original-L original-L))
                (iterate-list L1 a x (cdr L) original-L)
            )
        )
    )
)

(defun reached (x L)
    (iterate-list '() x x L L)
)

;QUESTION 7B

(defun create-empty-subsets (S)
    (if S
        (cons (list (car S) nil) (create-empty-subsets (cdr S)))
    )
)

(defun count-occurrence (A L)
    (if A 
        (occurs (car (car A)) (get_even(xflatten L)))
    )
)

(defun count-duplicates (E L B)
    (if (and L B)
        (if (equal E L) 1 0)
        ;add up the 1's and 0's that result from recursively calling the list
        (+ (count-duplicates E (car L) t) (count-duplicates E (cdr L) NIL))))

(defun remove-unwanted-elements (L)
    (if L
        (if (eq (car (car L)) ((car (cdr (car L)))))
            (remove-unwanted-elements (cdr L))
            (if (< 0 (get-count-of-link (car L) (cdr L)))
                (remove-duplicate-links (cdr L))
                (cons (car L) (remove-unwanted-elements (cdr L)))
            )
        )
    )
)

(defun mySort (L)
    (sort L 'greaterThan))

(defun greaterThan (L1 L2)
    (> (cadr L1) (cadr L2)))

(defun insert-reference-count (A L)
    (if (car A)
        (cons (append (car A) (list(count-occurrence A L))) (insert-reference-count (cdr A) L))
    )
)

;; (defun )

( defun rank (S L))

(print(create-empty-subsets '(A B C)))
(print (insert-reference-count '((A) (B) (C)) '((a b) (a a) (B A))))
(print (occurs ))
;; (print (rank '(google shopify aircanada amazon) '((google shopify) (google aircanada) (amazon aircanada))))
