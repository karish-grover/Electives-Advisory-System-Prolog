# Electives Advisory System Prolog

This repository implements an interactive elective advisory system in **Prolog**, from scratch. The user shall be recommended different electives along the course of this interactive prolog program.

## Working

- The program would first prompt the user for his name, year of study, and branch (`cse`/`csd`/`csss`/`csam`/`ece`/`csb`).
- The prolog program has predefined knowledge base with about 5-8 electives for every stream. The user would initially have to choose electives from his stream. Below is an example of a fact from the code:-

```prolog
elective(csd,
	d{'Computer graphics':['IP'],
	'Digital Image processing':['M1','PS'],
	'Computer vision':['M1'],
	'Machine learning':['IP','PS','M1','M3']}).
```
	
- Here elective is a fact, and the different electives from csd are listed in the form of a dictionary where different courses are the keys and their prerequisites are the values. 
- Now, once the user inputs his branch, he would be asked if he has done the prerequisites for all the electives from his stream. 
Based on the completed list of prerequisites entered by the student, he would be given a list of electives (elegible and recommended).

- Now, next, the student will be asked his choice of career after graduation i.e. 
	* Research Profile
	* Higher Education
	* Job - Engineering/Tech

Depending on what the user chooses he would be taken to three different pipelines with specific queries for each.

### Research Profile
- The user will be first asked if he has done any BTP and/or other projects.
- Now, for both of these he will be asked the closest topic to the project/BTP from all the electives of his course. This clearly shows his interest. 
- From the chosen topics, if he is eligible for any elective depending on the prerequisites, he will be advised to take it because it would help him sharpen his skills.
- Now, it is possible that he is ineligible for a course but he has done a project on it which shows that he is interested in that, so in this case he will be advised to take whichever prerequisites he has not taken. 
- All these courses will be listed.
- If his GPA is less than 7, he will further be advised to work more efficiently to reach his goal, since research profiles required more academic oriented candidates usually.

### Tech/Engineering jobs
- Here, cracking interviews is the key to tech jobs and hence a few interview specific electives are more important for such a candidate.
- Thus, in the knowledge base the following fact deals with this situation:

```prolog
elective(interview,
	d{'CN':['OS','ADA','IP'],
	'OS':['DSA'], 'DBMS':['DSA'],
	'DSA':['IP'], 'AP':['DSA', 'IP'],
	'ADA':['DSA','IP','AP']}).
```
- The electives like ADA, CN, OS, DBMS are the most important for interview preparation. Thus the user is asked which all prerequisites he has not done from the above courses.
- Depending on that, he is recommended to take the other courses/prerequisites for his interview preparation.
- If GPA is low he is advised to work more seriously as he may not be eligible for the OA rounds for some companies if GPA is very less. 
- Also, since companies also prefer candidates with project experience, this pipeline is now linked with the Research Profile pipeline. Because same things are important.

### Higher Education
This redirects to Research Profile too, as for getting placed at a top university for higher education one must have a strong project/research background.
Once, these pipelines are over, there come a few functionalities common to all the career choices.

### Specific Interest
- Sometimes we have not explored a particular course or topic, and yet we feel excited to take such a course. This functionality would enable a user to choose electives from his stream which he has not explored.
- If he is not eligible he will be recommended to do the prereq courses corresponding to this course. 


### Honors Degree
- If a student wishes to obtain the honors degree from IIITD, he needs to do 3 different electives. In order to do that he may want to choose electives from some other custom branch of his choice. 

### Other Branch Electives 
- He will be given an option to choose electives from the stream of his choice.
- He will be queried about the prereqs, and hence he will be recommended electives from other branches as well.


### A few complex functionalities:-

A few of the complex functionalities have been used using recursion, backtracking and cuts. Like:-

#### Find union of two lists.

```prolog
union([], L, L).
union([H|T1], L2, L3) :- member(H, L2), ! , union(T1, L2, L3).
union([H|T1], L2, [H|T3]) :- union(T1, L2, T3).
```

#### Find intersection of two lists.
```prolog
intersect([], _, []).
intersect([H|T1], L2, L3) :- member(H, L2), !, L3 = [H|T3], intersect(T1, L2, T3).
intersect([_|T1], L2, L3) :- intersect(T1, L2, L3).
```

#### Flatten a list i.e. convert to 1D list.
```prolog
flat(L, F) :- flat(L, F, []).
flat([], R, R) :- !.
flat([H|T], R, C) :- !, flat(H, R, C1), flat(T, C1, C).
flat(H0, [H0|C], C).
```

#### Predicate which takes in two lists A1 and A2, and returns a list of elements of A1 which are not present in A2.
```prolog 
obtain_elements(A1, A2, R):- findall(X,(member(X,A1), not(member(X,A2))),R).
```

## Running the program

Screenshots for sample runs of the program have been shown in the [file](https://github.com/karish-grover/Electives-Advisory-System-Prolog/blob/274c35ae83d5dd3b7f604b05cb4765af4b997a98/Sample%20Runs.pdf).

Run the code in the Prolog shell as follows:

```prolog 
?- consult("career.pl").
?- intro.
```

This is calling the `intro` function from the Prolog program.

## Issues

In case of any issues in running the code or if you wish to understand the workflow of the code, feel free to contact me or open an issue.
