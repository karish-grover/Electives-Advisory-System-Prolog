%Knowledge Base - Defining Electives for different streams.
elective(cse,
	d{'Theory of Computation':['DM'],
	'Big Data Analytics':['DBMS'],
	'Data Mining':['DBMS','IP','PS','M1'],
	'Machine Learning' :['IP','PS','M1', 'M3'],
	'Mobile Computing':['IP'],
	'Security and Privacy':[],
	'Computer Organization':['DC']}).

elective(ece,
	d{'Communication Networks' :['PS'],
	'Digital Signal Processing':['SNS'],
	'Internet of Things' :[],
	'Machine Learning' :['IP','PS','M1', 'M3'],
	'Economics':[],
	'Digital Hardware Design':['ELD'],
	'Theories of Deep Learning':['M1','M3','ML','SML'],
	'Radar Systems':['SNS']}).

elective(csam,
	d{'Number Theory':[],
	'Advanced Programming':['IP', 'DSA'],
	'Signals and Systems':['M1'],
	'Numerical Methods':['M1', 'M4']}).

elective(csd,
	d{'Computer graphics':['IP'],
	'Digital Image processing':['M1', 'PS'],
	'Computer vision':['M1'],
	'Machine learning':['IP','PS','M1', 'M3']}).

elective(csss,
	d{'Deep Learning':[],
	'Machine Learning':['IP','PS','M1', 'M3'],
	'Big Data Analytics':['DBMS'],
	'Digital Image Processing':['M1', 'PS']}).

elective(csb,
	d{'Machine learning in Bio medical Applications':[],
	'Big data mining in healthcare':[],
	'Introduction to mathematical biology':['M1'],
	'Datascience in genomics':[]}).

% Interview specific courses i.e. courses very important to crack technical rounds of interviews.
elective(interview,
	d{'CN':['OS','ADA','IP'],
	'OS':['DSA'], 'DBMS':['DSA'],
	'DSA':['IP'], 'AP':['DSA', 'IP'],
	'ADA':['DSA','IP','AP']}).

% Main execution function
intro:-
    nl,nl,write("ELECTIVES PREDICTION SYSTEM !!!!!"),nl,nl,
    write("Please enter your name :- "),nl,nl,read(Name),nl,nl,write("Which year are you currently studying in?"),nl,nl,read(Year),nl,nl,
    branchName(Branch), assert(branch(Branch)),
    write("Which of the following courses have you already done (Enter in form of a list):- "),nl,nl,
    courses(Branch, Done), write(Done),nl,nl, read(Choice), assert(done(Choice)), nl,nl,
		eligible(Branch, Choice, Eleg), assert(ele(Eleg)), nl,nl,
    write("You are eligible for the following Electives:- "), nl,nl, write(Eleg), nl, nl,
    get_BTP,
		get_GPA,
		get_Projects,
		interest,
		specificInterest,
		honors.

	% Custom predicates to find union of two lists.
	union([], L, L).
	union([H|T1], L2, L3) :- member(H, L2), ! , union(T1, L2, L3).
	union([H|T1], L2, [H|T3]) :- union(T1, L2, T3).

	% Custom predicates to find intersection of two lists.
	intersect([], _, []).
	intersect([H|T1], L2, L3) :- member(H, L2), !, L3 = [H|T3], intersect(T1, L2, T3).
	intersect([_|T1], L2, L3) :- intersect(T1, L2, L3).

	% Custom predicates to flatten a list i.e. convert to 1D list.
	flat(L, F) :- flat(L, F, []).
	flat([], R, R) :- !.
	flat([H|T], R, C) :- !, flat(H, R, C1), flat(T, C1, C).
	flat(H0, [H0|C], C).

% Find out the stream of the student.
branchName(Course):- write("Which stream are you enrolled in ? (cse/csam/csb/csd/csss/ece)"), nl,nl,read(Course).

% Finding the electives for which the student is eligible depending on the prereqs he has already done.
courses(Branch, S):- elective(Branch, Elec), dict_pairs(Elec,_,P), pairs_values(P, Q), flat(Q, R), sort(R, S).
eligible(Branch, Choice, Out):- elective(Branch, A), dict_pairs(A,_,P), findall(K,(member(K-X,P),subset(X, Choice)),Out).

% Check if the student did a BTP.
get_BTP:- write('Have you done a BTP? (y/n)'), nl,nl,read(Y),
nl,nl, (Y == y -> assert(btp("True"));(assert(btp("False")))).

% Check if the student did some projects other than the BTP.
get_Projects:- write('Have you done some other Projects? (y/n)'), nl,nl, read(Y),
nl,nl, (Y == y -> assert(projects("True"));(assert(projects("False")))).

% Find out the GPA of the student.
get_GPA:- write('What is your GPA till date?'), nl,nl, read(Y),
nl,nl, (Y < 7 -> assert(gpa("Low")); assert(gpa("High"))).

% Finding the topic of the BTP done.
get_BTP_topic([]):- btp("False").
get_BTP_topic(Topic):- btp("True"), write("Which of the following domains are the closest to your BTP topic:- "),nl,nl,
branch(Branch), elective(Branch, A), dict_pairs(A,_,P), dict_keys(P,K), write(K),nl,nl, read(Topic),nl,nl.

% Finding the topics of the projects done.
get_Project_topic([]):- projects("False").
get_Project_topic(Topic):- projects("True"), write("Which of the following domains are the closest to your Projects topics:- "), nl,nl,
branch(Branch), elective(Branch, A), dict_pairs(A,_,P), dict_keys(P,K), write(K), nl,nl, read(Topic),nl,nl.

% Finding career interest of the student :- What they want to do after graduation.
interest:-
	write("Which one of the following would you like to pursue after graduation? "),nl,nl,
	write("1. Enginnering/Tech Jobs (a)"),nl,nl,
	write("2. Research Profile/Job (b)"),nl,nl,
	write("3. Higher Education (c)"),nl,nl,
	read(Interest),nl,nl,
	(Interest = a -> interestA; ((Interest=b -> interestB); interestC)).

% Interest A i.e. Engineering/Tech Jobs
interestA:-
	write("Which of the following courses have you already done (Enter in form of a list):- "),nl,nl,
	courses(interview, Done),
	write(Done),nl,nl,
	read(Choice), nl,nl,
	write("You should take the following courses to assist you better with interview preparation:- "), nl,nl,
	elective(interview, A), dict_pairs(A,_,P), findall(K,(member(K-X,P),not(member(K, Choice))),Out),
	write(Out),nl,nl,
	interestB,
	gpa("Low")->(write("You have a low GPA which may not be enough to be eligible for OA rounds of all companies. You are
    		adivsed to work hard a bit, and keep going!"), nl,nl); (write("You must maintain this high GPA."), nl,nl).

% Interest B i.e. Research Profile
interestB:-
	branch(Branch),
	elective(Branch, A),
	dict_pairs(A,_,P),
	dict_keys(P,K),
	get_BTP_topic(B),
	get_Project_topic(PT),
	union(B, PT, U),
	intersect(U, K, I),
	help(I).

% Helper function for Interest B
help(I):-
	write("Based on your past projects, the following electives match your interests and are recommended to sharpen your skills:- "),
nl,nl, write(I), nl,nl,
remaining(I), gpa("Low")->(write("Despite your interests your low GPA shows scope for improvement, and it is advised to go over the basics before proceeding with projects/research."),
 nl,nl);(write("Your high GPA shows that by working in these domains you can achieve great heights."), nl,nl).

% Predicate which takes in two lists A1 and A2, and returns a list of elements of A1 which are not present in A2.
obtain_elements(A1, A2, R):- findall(X,(member(X,A1), not(member(X,A2))),R).

% Predicate to handle the case where there is the need of a course in Project/BTP, but student is still not elligible because of prereqs.
remaining(I):-
	done(C),  ele(E), not(subset(I, E)),
	obtain_elements(I, E, L), branch(Branch), elective(Branch, Elec),
	dict_pairs(Elec,_,P),
	findall(X,(member(K-X,P),member(K, L)),Out),
	flat(Out, R), sort(R, S), nl,nl,
	obtain_elements(S, C, Final),!,
	write("However, since you don't have the required prereqs for "),
	write(L), nl, nl,
	write("Thus, you are advised to take the following prereq courses:- "), nl,nl, write(Final), nl,nl.

% Interest C i.e. Higher Educatiion
interestC:-
	write("For getting placed at a top university for higher education you must have a strong project/research background"), nl,
interestB.

% If the student wants to get an honors degree from IIITD.
honors:-
	write("Do you wish to obtain an Honors Degree from IIITD? (y/n)"), nl,nl, read(A),nl,nl,
	(A=y-> (write("In that case you must do 12 extra credits. You could do that either from the above recommended electives or you could also consider electives from other branches. Do you wish to explore such electives? (y/n)"), nl, nl,
	read(B),nl,nl,(B = y -> nonBranchElectives; write("")));write("")).

% Considering the case where sometimes student wish to explore electives from other branches as well.
nonBranchElectives:-
	write("Which of the following streams would you like to explore? (cse/csb/csd/csam/csss/ece)"), nl,nl, read(Branch),
	write("Which of the following courses have you already done (Enter in form of a list):- "),nl,nl,
	courses(Branch, Done), write(Done), nl,nl, read(Choice),nl,nl,
	eligible(Branch, Choice, Eleg), nl,nl,
	write("You are eligible for the following Electives:- "), nl,nl, write(Eleg), nl,nl.

% Finding courses or electives for the student based on his interest of fields he hasn't explored yet.
specificInterest:-
	write("Choose your interest areas which you are yet to explore:- "), nl,nl,
	branch(Branch), elective(Branch, A), dict_pairs(A,_,P), dict_keys(P,K), nl,nl, write(K), nl,nl, read(Choice),nl,nl,
	findall(_X,(member(_K-_X,P),member(_K, Choice)),Out),
	flat(Out, R), sort(R, S), write("Which of the following course have you done already:- "), nl,nl, write(S), nl,nl, read(T),nl,nl,
	findall(K2,(member(K2-X2,P),subset(X2, T)),Out2),
	write("You are eligible to opt for the following courses of your interest:- "), nl,nl, write(Out2), nl,nl,
	write("However you can also opt for the following prereqs to be elegible for others too:-"), nl,nl,
	obtain_elements(S, T, Ans), write(Ans), nl, nl.
