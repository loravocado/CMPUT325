
% #Q1
% isMember(A, L): A is in list L
isMember(A, [A|_]).
isMember(A, [B|L]) :- A \== B, isMember(A, L).

% #setIntersect([a,b,c,d,e,g],[b,a,c,e,f,q],S).
setIntersect([], _, []).
setIntersect([A|L], L2, [A|L3]):- member(A, L2), setIntersect(L, L2, L3).
setIntersect([_|L], L2, L3):- setIntersect(L, L2, L3).

% #Q2
swap([], []).
swap([A, B | L], [B, A | R]) :- swap(L, R).
swap([A | L], [A | R]) :- swap(L, R).  

% #Q3

flatten([],[]).
flatten([A|L],[A|L1]) :- atomic(A), flatten(L,L1).
flatten([A|L],R) :- flatten(A,A1), flatten(L,L1), append(A1,L1,R).

filter(L, W, N, L1) :- flatten(L, L2), filter_list(L2, W, N, L1).

filter_list([], _, _, []).
filter_list([A | L], equal, N, [A | L1]) :- A == N, filter(L, equal, N, L1).
filter_list([A | L], greaterThan, N, [A | L1]) :- A > N, filter(L, greaterThan, N, L1).
filter_list([A | L], lessThan, N, [A | L1]) :- A < N, filter(L, lessThan, N, L1).

filter_list([_ | L], W, N, L1) :- filter(L, W, N, L1).

% #Q4
% some help from https://gist.github.com/Leonidas-from-XIV/4585246
sortByLetter([], []).
sortByLetter([Pair], [Pair]).
sortByLetter(List, Sorted) :-
  split(List, Left, Right),
  sortByLetter(Left, SortedLeft),
  sortByLetter(Right, SortedRight),
  merge(SortedLeft, SortedRight, Sorted).

% Split a list into two halves
split([], [], []).
split([X], [X], []).
split([X,Y|List], [X|Left], [Y|Right]) :- split(List, Left, Right).

% Merge two sorted lists of pairs by the first element (letter) in each pair
merge([], List, List).
merge(List, [], List).
merge([[A,X]|List1], [[B,Y]|List2], [[A,X]|Merged]) :- A @=< B, merge(List1, [[B,Y]|List2], Merged).
merge([[A,X]|List1], [[B,Y]|List2], [[B,Y]|Merged]) :- A @> B, merge([[A,X]|List1], List2, Merged).

appendList(A, [], [[A, 1]]).
appendList(A, [[A, Count] | L], [[A, B] | L]) :- B is Count + 1.
appendList(A, [[B, Count] | L], [[B, Count] | L1]) :- appendList(A, L, L1).

count([],[]).
count([A|L], N) :- count(L, N1), appendList(A, N1, N).

countAll([],[]).
countAll(L, N) :- count(L, N1), sortByLetter(N1, N).

% #Q5
% sub([a,[a,d],[e,a]],[[a,2]],L) 

%# findValue(match, array of replacements , value)
findValue(_, [], _).
findValue(A, [[A, Value] | _], Value) :- !.
findValue(A, [[_] | L], OldValue) :- findValue(A, L, OldValue).

sub([], _, []).
sub(A, L2, Value) :- findValue(A, L2, Value), number(Value).
sub(A, _, A) :- atom(A).
sub([A | L], L2, [B | L3]) :- sub(A, L2, B), sub(L, L2, L3).
sub([A | L], L2, [B | L3]) :- \+ atom(A), sub(A, L2, B), sub(L, L2, L3).


% #Q6
clique(L) :-
     findall(X,node(X),L1),
     subset(L1,L),
     allConnect(L).

subset([], []).
subset([H|T], [H|NT]) :-
    subset(T, NT).
subset([_|T], NT) :-
    subset(T, NT).

allConnect([]).
allConnect([H|T]):-
     connectToList(H, T),
     allConnect(T).Yay

connectToList(A, []).
connectToList(A, [B|L]):- node(A), connect(A, B), connectToList(A, L). 
connectToList(A, L):-false.

connect(A, B):-edge(B, A),!.
connect(A, B):-edge(A, B),!.

edge(a,b).
edge(c,a).
edge(b,c).

node(a).
node(b).
node(c).




