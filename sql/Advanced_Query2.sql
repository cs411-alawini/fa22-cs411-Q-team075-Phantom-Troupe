-- find the CS courses with high rated profs
SELECT DISTINCT Courses.Department, Courses.CourseNumber,Courses.CourseName, Professors.ProfessorName,Professors.Rate
FROM Courses JOIN Teach USING (CRN) JOIN Professors USING (ProfessorID)
WHERE Courses.Department='CS' AND Professors.Rate > (SELECT avg(p.Rate) as AvgProfRate
                                                    FROM Professors p)
ORDER BY Professors.Rate DESC, Courses.CourseNumber ASC