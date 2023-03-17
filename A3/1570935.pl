% Lora Ma
% ID: 1570935
% CMPUT 325 LEC B1
% Assignment 3

% Question 1

% setIntersect(+S1,+S2,-S3) - Main function
% What the function does: It returns in S3 the intersection of the two lists provided in S1 and S2.

% How it works: If the first element of list 1 is in list 2, we recursively call setIntersect with the rest of list 1, list 2, and list 3 while appending to the output list. Otherwise, it will recursively call setIntersect with the rest of L, L2, and L3 (skipping the first element of the first list).

% Testcase:
% ?- setIntersect([a,b,c,d,e,g],[b,a,c,e,f,q],S).
% S=[a,b,c,e]

setIntersect([], _, []).
setIntersect([A|L], L2, [A|L3]):- member(A, L2), setIntersect(L, L2, L3).
setIntersect([_|L], L2, L3):- setIntersect(L, L2, L3).

% isMember(+A, -L) - Helper function
% What the function does: It checks if an atom exists within a list. It returns true if the atom does exist and false if it does not exist within the list.

% How it works: If the first item of the list is the same as the atom, the program returns true. Otherwise, if the first item of the list is not the same as the atom, we recursively call this function with the rest of the list

% Testcases:
% ?- isMember(a, [c, d, a, f]).
% true

isMember(A, [A|_]).
isMember(A, [B|L]) :- A \== B, isMember(A, L).

% Question 2

% swap(+L, -R) - Main function
% What the function does: It returns in the output list R every two elements swapped

% How it works: it takes the first two elements in the list and swaps them and inserts them into the output array. Then swap is recursively called with the rest of the the list (minus the two items that were swapped).

% Testcases:
% ?- swap([a,1,b,2], W).
% W = [1,a,2,b].

% swap([a,1,b], W).
% W = [1,a,b].

% swap([], W).
% W = [].

swap([], []).
swap([A, B|L], [B, A|R]) :- swap(L, R).
swap([A|L], [A|R]) :- swap(L, R).  

% Question 3

%  filter(+L,+OP,+N,-L1) - Main function
% What the function does: L1 is a flat list containing all the numbers in L such that the condition specified by OP and N is satisfied

% How it works: We first flatten the list and then filter that list using filter_list to remove items that do not satisfy the condition

% Testcases:
% ?- filter([3,4,[5,2],[1,7,3]],greaterThan,3,W).
% W= [4,5,7]

% ?- filter([3,4,[5,2],[1,7,3]],equal,3,W).
% W= [3,3]

% ?- filter([3,4,[5,2],[1,7,3]],lessThan,3,W).
% W= [2,1]

filter(L, W, N, L1) :- flatten(L, L2), filter_list(L2, W, N, L1).

% flatten(+L1, -L2) - Helper function
% What the function does: It flattens the list so there are no nested elements

% How it works: If the element is an atom, we add it to the output array, if it is not an atom, we recursively call flatten with the contents of the list and append those results to the result list

% Testcases:
% ?- flatten([3,4,[5,2],[1,7,3]], L2).
% L2 = [3, 4, 5, 2, 1, 7, 3]

flatten([],[]).
flatten([A|L],[A|L1]) :- atomic(A), flatten(L,L1).
flatten([A|L],R) :- flatten(A,A1), flatten(L,L1), append(A1,L1,R).

% filter_list(+L1, +A, +B, -L2) - Helper function
% What the function does: It filters the list depenging on the OP

% How it works: if OP is equal, we check if the first element of the list is equal to B and if it is, we filter the rest of the list. The same applies to greatherThan and lessThan 

% Testcases:
% ?- filter([3,4,5,2,1,7,3], greaterThan, 3, W).
% W= [4,5,7]

% ?- filter([3,4,5,2,1,7,3], equal, 3, W).
% W= [3,3]

% ?- filter([3,4,5,2,1,7,3], lessThan, 3, W).
% W= [2,1]

filter_list([], _, _, []).
filter_list([A|L], equal, N, [A|L1]) :- A == N, filter(L, equal, N, L1).
filter_list([A|L], greaterThan, N, [A|L1]) :- A > N, filter(L, greaterThan, N, L1).
filter_list([A|L], lessThan, N, [A|L1]) :- A < N, filter(L, lessThan, N, L1).
filter_list([_|L], W, N, L1) :- filter(L, W, N, L1).

% Question 4

% countAll(+L,-N) - Main function
% What the function does: returns a flat list L of atoms wherethe number of occurrences of every atom is counted. Thus, N should be a list of pairs [a,n] representing that atom a occurs in L n times. 

% How it works: First we count the occurences for each letter and then we sort the lists by letters

% Testcases:
% ?- countAll([a,b,e,c,c,b],N).
% N = [[e, 1], [a, 1], [b, 2], [c, 2]]

countAll([],[]).
countAll(L, N) :- count(L, N1), mergeSortPairs(N1, N).

% count(+L1, -L2) - Helper function
% What the function does: counts all of the elements and their occurences 

% How it works: For each element in the list, we run appendList

% Testcases:
% ?- count([a,b,e,c,c,b],N).
% N = [[b, 2], [c, 2], [e, 1], [a, 1]]

count([],[]).
count([A|L], N) :- count(L, N1), appendList(A, N1, N).

% appendList(+A, +L1, -L2) - Helper function
% What the function does: It increments the occurence of an element

% How it works: If atom A has not been encountered, we add [atom, 1] to the list for that atom. If it has been encountered, we increase the count by 1 and if it is not a match, we recuresively call appendList with the rest of the list

% Testcases:
% ?- appendList(a, [[a,0]], N).
% N = [[a, 1]]

appendList(A, [], [[A, 1]]).
appendList(A, [[A, Count]|L], [[A, B]|L]) :- B is Count + 1.
appendList(A, [[B, Count]|L], [[B, Count]|L1]) :- appendList(A, L, L1).

% mergeSortPairs(+L1, -L2), mergePairs(+L3, +L4, -L5), splitPairs(L+6, +L7, -L8) - Helper functions for merge sort
% What the function does: It uses merge sort to sort by letters

% How it works: https://gist.github.com/Leonidas-from-XIV/4585246

% Testcases:
% ?- sortByLetter([[b, 2], [c, 2], [e, 1], [a, 1]],N).
% N = [[a, 1], [b, 2], [c, 2], [e, 1]]

% Merge two sorted lists of pairs based on the second element of each pair
mergePairs([], L, L).
mergePairs(L, [], L).
mergePairs([[A, N1] | L1], [[B, N2] | L2], [[A, N1] | L3]) :- N1 =< N2, mergePairs(L1, [[B, N2] | L2], L3).
mergePairs([[A, N1] | L1], [[B, N2] | L2], [[B, N2] | L3]) :- N1 > N2, mergePairs([[A, N1] | L1], L2, L3).

% Split a list into two halves
splitPairs([], [], []).
splitPairs([X], [X], []).
splitPairs([X, Y | L], [X | L1], [Y | L2]) :- splitPairs(L, L1, L2).

% Sort a list of pairs in ascending order based on the second element of each pair using merge sort
mergeSortPairs([], []).
mergeSortPairs([X], [X]).
mergeSortPairs(List, Sorted) :- List = [_ | _], splitPairs(List, L1, L2), mergeSortPairs(L1, Sorted1), mergeSortPairs(L2, Sorted2), mergePairs(Sorted1, Sorted2, Sorted).

% Question 5

%  sub(+L,+S,-L1) - Main function
% What the function does: L is a possibly nested list of atoms, S is a list of pairs in the form [[x1,e1],...,[xn,en]], and L1 is the same as L except that any occurrence of xi is replaced by ei.

% How it works: we first find the value that is associated with the current atom to see if it needs to be substituted. If it is a list, we recursively call sub for the inner lists. If it is not a list and there is a replacement required, we replace that value and move on to the next atom in the list 

% Testcases:
% ?- sub([a,[a,d],[e,a]],[[a,2]],L).
% L= [2,[2,d],[e,2]].

sub([], _, []).
sub(A, L2, Value) :- findValue(A, L2, Value), number(Value).
sub(A, _, A) :- atom(A).
sub([A|L], L2, [B|L3]) :- sub(A, L2, B), sub(L, L2, L3).
sub([A|L], L2, [B|L3]) :- \+ atom(A), sub(A, L2, B), sub(L, L2, L3).

% findValue(+A, +L1, -B) - Helper function
% What the function does: It finds the corresponding replacement value of A

% How it works: It goes through the replacement list and finds if any of the nested pairs have the atom A. If it is in a pair, we can return the replacement value as B

% Testcases:
% ?- findValue(a, [[a,0]], B).
% B= 0.
findValue(_, [], _).
findValue(A, [[A, Value]|_], Value) :- !.
findValue(A, [[_]|L], OldValue) :- findValue(A, L, OldValue).

% Question 6

%  clique(+L) - Main function
% What the function does: a predicate clique(?L) such that findall(L, clique(L), Cliques) will unify Cliques with a list containing all cliques. L should contain a single clique. 

% How it works: We first use findall to unify cliques with a list containsing all cliques, then we call subset and then allConnect

% Testcases:
% ?- edge(a,b).
% ?- edge(b,c).
% ?- edge(c,a).
% ?- node(a).
% ?- node(b).
% ?- node(c).
% ?- clique(L)
% L = [a, b, c] ;
% L = [a, b] ;
% L = [a, c] ;
% L = [a] ;
% L = [b, c] ;
% L = [b] ;
% L = [c] ;
% L = [].

% edge(a,b).
% edge(b,c).
% edge(c,a).
% node(a).
% node(b).
% node(c).

clique(L) :- findall(A, node(A), L1), subset(L1,L), isConnected(L).

% subset(+L1, -L2)- Helper function
% What the function does: checks whether the first argument is a subset of the second argument. 

% How it works: If the first list is not empty and the first element of the first list is also the first element of the second list, then the first list is a subset of the second list if the rest of the first list is a subset of the rest of the second list. If the first list is not empty and the first element of the first list is not in the second list, then the first list is a subset of the second list if the rest of the first list is a subset of the second list.

subset([], []).
subset([H|T], [H|NT]) :- subset(T, NT).
subset([_|T], NT) :- subset(T, NT).

% isConnected(+L) - Helper function
% What the function does:  used to check if all the elements in a given list are connected to each other, 

% How it works: It states that a non-empty list is connected if the first element H is connected to all the other elements in the list T and the rest of the list T is also connected to each other. It does this by checking if H is connected to all the other elements in T using the connection predicate, and then recursively calling isConnected with the rest of the list T.

isConnected([]).
isConnected([H|T]):- connection(H, T), isConnected(T).

% connection(+L, -L2) - Helper function
% What the function does: is used to define how two elements are connected to each other.

% How it works:  It states that an element A is connected to another element B and any other elements in the list L if A is a node and there is a connection between A and B. It then recursively checks if A is connected to the rest of the elements in the list L.

connection(_, []).
connection(A, [B|L]):- node(A), connects(A, B), connection(A, L). 

% connects(A, L) - helper
% What the function does: determines if there is a connection between two nodes A and B.

% How it works:  The first rule connect(A, B):-edge(B, A),!. states that there is a connection between A and B if there is an edge from B to A. The second rule connect(A, B):-edge(A, B),!. states that there is a connection between A and B if there is an edge from A to B.

connects(A, L) :- forall(isMember(Y,L), (edge(A,Y); edge(Y,A))).

% Question 7



