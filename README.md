Programmeerproject-Assembly-Arkenoid
====================================

1 Goal
Design and write a working program in 8086 assembly language (MASM syntax), that runs inside the DOSBox
environment. The project must be written in groups of two persons.
2 Project Proposals
Every group is allowed to choose what kind of program they will create, but this choice must be approved by Prof.
Schelkens beforehand. Below is a list of examples of possible projects:
 A small game with graphical output and keyboard/mouse input.
e.g. Tetris, Minesweeper, Space Invaders, Pacman, Snake, Break-out, ...
 Image encoder and decoder (higher complexity encodings, e.g. NOT BMP or PGM) with some editing functions.
E.g. a small painting app with save as JPG or PNG..
Please make groups and formulate a project at latest on October 25rd 2012 (earlier if possible). Email proposals
and names to tim.bruylants@vub.ac.be and bob.andries@vub.ac.be.
3 Deliverables
By the end of the semester, you will have to deliver the following:
 A full report, describing:
{ What the program does.
{ All features/commands/functionalities (like a users guide).
{ The (high level and abstract) design (i.e. data model behind the code).
{ List of specic problems encountered during development, along with the implemented solutions.
{ Do NOT make an overview of written functions, and do NOT append the source code as part of the report.
 Source code with working Makele.
Everything should be uploaded to the PointCarre dropbox before the Januari 6th 2014 as a single ZIP le (that
contains everything).
4 Evaluation
 Quality of the source code (i.e. clean, ecient, well documented code).
{ Programming in assembly language is no excuse for producing unstructured spaghetti code. Use of functions
for support of modularity and code-reuse is mandatory! Use macros only for small repeating fragments of
code (smaller than 10-15 lines) that cannot be put in a function. Functions must use stack-based arguments
with correct stack-frame design (as given in previous excersises) and may only return a value via register
AX.
{ Assembly language can be hard to decipher/read. So, provide useful and meaningful comments, preferably
for each instruction line.
1  MASM's built-in macros (.IF, .FOR, ...) may NOT be used.
{ Use of Makele is mandatory (NMAKE command in DOS).
{ Correct usage of EQU constants, global variables and local variables.
{ Only 8086/8087 assembler. Do not use .386, .486, ...
 Correct operation of the program (no crashes, works as described).
 User-friendlyness of the program (this includes GUI layout).
 Quality and content of the report.
 Your defense (takes place during the exam period).
{ Presentation of the project.
{ Demo of the program.
{ Questions/answers about code and design (know every part of the project, no excuses about not writing or
understanding a specic part of the code, ...).
 It is allowed to use "the internet"for inspiration, but copying entire fragments of code is NOT allowed! Applying
existing ideas is allowed, but always understand what you are using. Be able to explain! (Detailed questions will
be asked at the defense.)
 The project counts for 40% of the score for this course. Start today and nish sooner than later (think about
your X-mas holidays).