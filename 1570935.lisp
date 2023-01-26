#| Lora Ma
ID: 1570935
CMPUT 325 LEC B1
Assignment 1
|#

#| QUESTION 1

What the function does: It counts the amount of times E occurs in a L

How it works: It first checks if L is an atom. If it is an atom, it then checks if L is the element E we are looking for. If it is, we return 1, otherwise, we return 0. If L is not an atom, we recursively check the first element of L. Then we sum up the 0's and 1's that are returned recursively to get the sum of how many times E occurs in L

Testcases:
>(occurs 'a '(a (a b) ((c) a)))
3

>(occurs 'a '(a (a (b)) b))
2

>(occurs 'a '(d (nil (b)) b))
0
|#

(defun occurs (E L)
    (if (atom L)
        (if (eq E L) 1 0)
        ;add up the 1's and 0's that result from recursively calling the list
        (+ (occurs E (car L)) (occurs E (cdr L)))))


#| QUESTION 2

What the function does: It flattens the list so that a list of atoms is returned with all atoms that are in x appearing in the result and in the same order.

How it works: Base case: when x is null (at the end of a list). It checks if the first item in x is an atom. If it is, it puts it into a list with the element that returns from recursively calling the rest of xflatten x. Basically this results in a chain of cons such that xflatten '(A (B) C) results in (cons A (cons B (cons C '()))) which equals (A B C). If the first element of x is not an atom, we can assume it is a list and then recursively call this function on the first element of the list and the rest of the elements from the list.

Testcases: 
 >(xflatten '(a (b c) d))
 (a b c d)

 >(xflatten '((((a))))) 
 (a)

 >(xflatten '(a (b c) (d ((e)) f)))
 (a b c d e f)

 >(xflatten '(a (b nil c) nil (d ((e)) f)))
 (a b nil c nil d e f)
|#

(defun xflatten (x)
    (if (null x)
        '()
        (if (atom (car x))
            ;if it is an atom, add it to the list and recursively call the rest of the list
            (cons (car x) (xflatten (cdr x)))
            ;append the first element of list flattened with the rest of the list flattened
            (append (xflatten (car x)) (xflatten (cdr x))))))


#| QUESTION 3

What the function does: It removes duplicates from the list and returns the rest of the list without duplicates

How it works: It checks if the first element of x exists in the rest of the elements of x. If it does, then it calles remove-duplicate with the rest of the elements in x without the first element. This is how we remove a duplicate element. Otherwise if it doesn't exist in the rest of x, we just move on to check the next element.

Testcases:
 >(remove-duplicate '(a b c a d b))
 (a b c d)
 or
 (c a d b)
|#

(defun remove-duplicate (x) 
    (if (null x)
        x
        (if (eq 0 (occurs (car x) (cdr x)))
            ;if not in list just add to resulting list and recursively call rest of list
            (cons (car x) (remove-duplicate(cdr x)))
            ;otherwise skip the item and recursively call rest of the list
            (remove-duplicate(cdr x)))))


#| QUESTION 4A

What the function does: It returns one list that has the elements from L2 and L1 combined but alternating -- L1 = '(A B C) and L2 = '(D E F), mix(L1 L2) = '(D A E B F C)

How it works: If there are no elements left in L1, it returns L2 and if no elements are left in L2, it returns L1. If both lists contain items, it recursively calls the first element of L2 to be combined with the first element of L1 until either lists run out of items

Testcases:
 >(mix '(a b c) '(d e f))
 (d a e b f c)

 >(mix '(1 2 3) '(a))
 (a 1 2 3)

 >(mix '((a) (b c)) '(d e f g h)) 
 (d (a) e (b c) f g h)

 >(mix '(1 2 3) nil)
 (1 2 3)

 >(mix '(1 2 3) '(nil))
 (nil 1 2 3)
|#

(defun mix (L1 L2)
    (if (null L1) 
        L2
        (if (null L2) 
            L1
            ;cons the first element from second list with first item of first list and recursively calls mix with the rest of the two functions
            (cons (car L2) (cons (car L1) (mix (cdr L1) (cdr L2)))))))


#| QUESTION 4B

What the function does: It creates a list with two lists. The first sublist contains all the even elements from L and the second sublist contains all the odd elements from L

How it works: It calls the helper functions get_even for the even list and the helper function get_odd for the odd list

 >(split '(1 2 3 4 5 6))
 ((2 4 6) (1 3 5))

 >(split '((a) (b c) (d e f) g h)) 
 (((b c) g) ((a) (d e f) h))

 >(split '())
 (nil nil)
|#

(defun split (L)
    (list (get_even L) (get_odd L)))

#| Helper function

What the function does: It returns a list with all the even elements from L

How it works: It creates a list with the second element of L and with the result from recursively calling the function and passing in a list from the third element to the end of the list.
|#

(defun get_even (L)
    (if (and (car (cdr L)))
        (cons (car (cdr L)) (get_even (cdr (cdr L))))))

#| Helper function

What the function does: It returns a list with all the odd elements from L

How it works: It creates a list with the first element of L and with the result from recursively calling the function and passing in a list from the third element to the end of the list.
|#

(defun get_odd (L)
    (if (and (car L))
        (cons (car L) (get_odd (cdr (cdr L))))))


#| QUESTION 5

What the function does: Generates all the subsets of L with no repeats

How it works: It appends the subsets generated by gen-subsets using the first item of the list with the subsets that are generated by recursively calling the rest of the list

Testcases:
 >(allsubsets nil)
 > (nil)

 >(allsubsets '(a))
 >(nil (a)) 

 >(allsubsets '(a b))
 >(nil (a) (b) (a b))
|#

(defun allsubsets (L)
    (if L
        ;append subsets for first item of the list and subsets for the rest of list together
        (append (gen-subsets (car L) (allsubsets (cdr L))) (allsubsets (cdr L)))
        '(())
    )
)

#| Helper function

What the function does: Creates subsets by putting A in every sublist in B

How it works: It creates a list of lists that each contain a subset. It puts A in each sublist in B.

Testcases:
 > (gen-subsets 'A '(B))
 > (((A . B)))

 > (gen-subsets 'A '((B C) (B) (C) NIL))
 > ((A B C) (A B) (A C) (A))
|#

(defun gen-subsets (A L)
    (if L
        (cons (cons A (car L)) (gen-subsets A (cdr L))
        )
        '()
    )
)

#| QUESTION 6

What the function does: Replaces each occurrence of atom A in the list L with the expression E. 

How it works: When the first element of L is an atom and equal to A, we add E to the list and recursively call this function with the rest of L. When the first element of L is an atom but not equal to A, we just add whatever was the first element to the list and continue recursively calling the rest of the list. If the first element of the list is not an atom, we call recursievely call this function and pass in the inner list.

Testcases:
 > (substitute0 'a 'b '(a (a 2) (1 2 a)))
 (b (b 2) (1 2 b))

 > (substitute0 'a 'b '(1 2 3))
 (1 2 3)

 > (substitute0 'a '(1 2) '(a (b a) (c e) (a)))
 ((1 2) (B (1 2)) (C E) ((1 2)))
|#

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

#| QUESTION 7A

What the function does: If a website A contains a link to another website B, it is represented by (A B). Given a list of links L, this function returns a list of web pages that can be reached from x

How it works: It calls iterate list with an empty list, the original x that was passed in, a temporary storage of the current x, current L, and the original L

Test cases:
> (reached 'google '( (google shopify) (google aircanada) (amazon aircanada)))
(SHOPIFY AIRCANADA)

> (reached 'google '( (google shopify) (shopify amazon) (amazon google) ) )
(SHOPIFY AMAZON)

> (reached 'google '( (google shopify) (shopify amazon) (amazon indigo)  ))
(SHOPIFY AMAZON INDIGO)

> (reached 'google '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) )) 
(SHOPIFY AIRCANADA DELTA)
|#

(defun reached (x L)
    (iterate-list '() x x L L)
)

#| Helper function
What the function does: It generates all the connections
How it works: Checks if x has a connection in L and adds to L1 if it does
|#

(defun gen-connections (L1 x original-x L original-L)
    (if (null L)
        L1
        ;Checks if the first element of L is the same as current x
        (let ((c (checker x (car L))))
            ;If checker returned an element, checker returned an element that's different from x, and current x and the returned element are not the same
            (if (and (not (eq original-x c)) (and c (not (eq c x))))
                ;Append L1 (our accumulator) with c the connection we found and recursively call the rest of the list with all the original information passed in. This is then appended with what is returned from rechecking the list for any new connections with the c connection we just found
                (append (gen-connections (append L1 (list c)) x original-x (cdr L) original-L) (gen-connections '() c original-x original-L original-L))
                ;otherwise it is not a connection and we should continue recursively calling with the rest of the list
                (gen-connections L1 x original-x (cdr L) original-L)
            )
        )
    )
)

#| Helper function
What it does: It checks if a particular list has a connection with a certain element
How it works: Checks if the passed in current x is the same as the first element of L. So if L is '(A B), it will check A. If these two are the same, it will return the second element.
|#

(defun checker (a L)
    (if (eq a (car L))
        (car (cdr L))
    )
)

#| QUESTION 7B
What the function does: It returns a sorted list from the most important web page to the least important web page 

How it works: It follows the following steps:
 1. First we generate a list of empty subsets for each of the passed in values in the list S. If S is '(A B C), it will return '((A) (B) (C)).
 2. Then, we count how many references (and ommitting the values such as '(A A) and repeating values) for each of the atoms in S and append them to the generated subsets. So if A = 1, B = 2, C = 4, we will get '((A 1) (B 2) (C 4)).
 3. Then we sort that list from greatest to smallest. Looking at the previous step, if we sort that result, we get '((C 4) (B 2) (A 1)).
 4. Lastly we construct a list with only the elements without the number, so (C B A) 

Test cases:
> (rank '(google shopify aircanada amazon) '((google shopify) (google aircanada) (amazon aircanada)))
(AIRCANADA SHOPIFY GOOGLE AMAZON)

> (rank '(google shopify amazon) '((google shopify) (shopify amazon) (amazon google)))
(GOOGLE SHOPIFY AMAZON)

> (rank '(google shopify amazon indigo) '((google shopify) (shopify amazon) (amazon indigo)))
(SHOPIFY AMAZON INDIGO GOOGLE)

> (rank '(google shopify aircanada amazon delta) '((google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google)))
(AIRCANADA SHOPIFY DELTA GOOGLE AMAZON)
|#

(defun rank (S L)
    (get-sorted-list(mySort (insert-reference-count (create-empty-subsets S) (remove-unwanted-elements L))))
)

#| Helper function
How it works: It constructs a new list with only the elements and omits the number
|#

(defun get-sorted-list (L)
    (if L
        (cons (car (car L)) (get-sorted-list (cdr L)))
    )
)   

#| Helper function
How it works: It sorts by biggest to smallest values (was taken from eclass)
|#

(defun mySort (L)
    (sort L 'greaterThan))

#| Helper function for mySort
How it works: Compares the value of the second element of the L1 and L2 to see which is greater
|#

(defun greaterThan (L1 L2)
    (> (cadr L1) (cadr L2)))

#| Helper function
How it works: It inserts the amount of times it is referenced into the list generated by create-empty-subsets. It does this by counting how many times it occurs using the count-occurence helper function and inserts it into the list.
|#

(defun insert-reference-count (A L)
    (if (car A)
        (cons (append (car A) (list(count-occurrence A L))) (insert-reference-count (cdr A) L))
    )
)

#| Helper function
How it works: It goes through all of the element in S and creates a new list where each element in S is in its own sublist
|#

(defun create-empty-subsets (S)
    (if S
        (cons (list (car S)) (create-empty-subsets (cdr S)))
    )
)

#| Helper function
How it works: It flattens the given list L and creates a list with only the even values (the second elements of all the sublists in L). Then, it returns how many times it occurs in L
|#

(defun count-occurrence (A L)
    (if A 
        (occurs (car (car A)) (get_even(xflatten L)))
    )
)

#| Helper function
How it works: It counts how many links that are of E are in L. It uses similar logic to that in the function occurs. It iterates through the list until it finds a value where E is the same as the value in L and then returns one. Otherwise it returns 0. At the end it adds up all the 1's and 0's
|#

(defun count-links (E L)
    (if (null L)
        0
        (if (and (eq (car (cdr E)) (cadar L)) (eq (car E) (car (car L))))
            (+ 1 (count-links E (cdr L)))
            (count-links E (cdr L))
        )
    )
)

#| Helper function
How it works: It removes elements that we don't want to consider from L. It removes elements like '(A A) where both of the atoms in the list are the same. It also removes duplicates so '((A B) (A B)) will become '((A B)).
|#

(defun remove-unwanted-elements (L)
    (if L
        ;Checks if both atoms in a list are the same ex: '(A A) and removes them
        (if (eq (car (car L)) (car (cdr (car L))))
            (remove-unwanted-elements (cdr L))
            ;Checks if there are duplicate elements and removes one
            (if (< 0 (count-links (car L) (cdr L)))
                (remove-unwanted-elements (cdr L))
                ;Otherwise recursively checks the rest of the elements in the list
                (cons (car L) (remove-unwanted-elements (cdr L)))
            )
        )
    )
)