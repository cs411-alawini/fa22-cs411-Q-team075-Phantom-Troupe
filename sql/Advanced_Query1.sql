-- Calculate the average GPA and average DifficultyLevel of all the ECE course
-- select the ECE course that both have higher GPA and lower DifficultyLevel 
-- Also print out the professor that teach the course
-- Order by CourseNumber
EXPLAIN ANALYZE
SELECT Courses.Department, Courses.CourseNumber, Professors.ProfessorName
FROM Courses JOIN DifficultyOfCourses USING (CRN) JOIN Difficulty USING (DifficultyLevel)
JOIN CoursesHasGrades USING (CRN) JOIN Grades USING (GradeLevel) JOIN Teach USING (CRN) JOIN Professors USING (ProfessorID) JOIN

(SELECT AVG(d.DifficultyLevel) AS AvgDifECE
FROM Courses c JOIN DifficultyOfCourses USING (CRN) JOIN Difficulty d USING (DifficultyLevel)
GROUP BY c.Department
HAVING c.Department='ECE') AvgDif JOIN

(SELECT AVG(g.AvgGPA) AS AvgGPAECE
FROM Courses c1 JOIN CoursesHasGrades USING (CRN) JOIN Grades g USING (GradeLevel)
GROUP BY c1.Department
HAVING c1.Department='ECE') TAvgGPA 
WHERE Courses.Department='ECE' AND Grades.AvgGPA > TAvgGPA.AvgGPAECE AND Difficulty.DifficultyLevel < AvgDif.AvgDifECE
ORDER BY Courses.CourseNumber
LIMIT 15

CREATE INDEX department_idx ON Courses(Department)
DROP INDEX department_idx ON Courses

CREATE INDEX AvgGPA_idx ON Grades(AvgGPA)
DROP INDEX AvgGPA_idx ON Grades