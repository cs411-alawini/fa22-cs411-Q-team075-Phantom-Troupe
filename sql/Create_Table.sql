CREATE TABLE UserInfo(
UserID INT NOT NULL,
UserFirstName VARCHAR(50),
UserLastName VARCHAR(50),
PRIMARY KEY (UserID));

CREATE TABLE Courses(
CRN INT NOT NULL,
Year_Term VARCHAR(15),
Department VARCHAR(15),
CourseNumber VARCHAR(10),
CourseName VARCHAR(100),
PRIMARY KEY (CRN));

CREATE TABLE Professors(
ProfessorID INT NOT NULL,
ProfessorName VARCHAR(50),
Rate VARCHAR(10),
Deparment VARCHAR(15),
PRIMARY KEY (ProfessorID));

CREATE TABLE Grades(
GradeLevel DECIMAL(6,2) NOT NULL,
AvgGPA DECIMAL(3,2),
A INT,
B INT,
C INT,
D INT,
F INT,
W INT,
PRIMARY KEY (GradeLevel));

CREATE TABLE Difficulty(
DifficultyLevel INT,
Exams INT,
Discussions INT,
Labs_Mps INT,
Homework INT,
PRIMARY KEY (DifficultyLevel));

CREATE TABLE Search(
CRN INT references Courses(CRN) ON DELETE SET NULL,
UserID INT references UserInfo(UserID) ON DELETE SET NULL,
PRIMARY KEY (CRN,UserID));

CREATE TABLE DifficultyOfCourses(
CRN INT references Courses(CRN) ON DELETE SET NULL,
DifficultyLevel INT references Difficulty(DifficultyLevel) ON DELETE SET NULL,
PRIMARY KEY (CRN,DifficultyLevel));

CREATE TABLE CoursesHasGrades(
CRN INT references Courses(CRN) ON DELETE SET NULL,
GradeLevel DECIMAL(6,2) references Grades(GradeLevel) ON DELETE SET NULL,
PRIMARY KEY (CRN,GradeLevel));

CREATE TABLE Teach(
CRN INT references Courses(CRN) ON DELETE SET NULL,
ProfessorID INT references Professors(ProfessorID) ON DELETE SET NULL,
PRIMARY KEY (CRN,ProfessorID));