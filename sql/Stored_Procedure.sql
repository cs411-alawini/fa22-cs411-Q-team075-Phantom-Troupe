DELIMITER $$
CREATE PROCEDURE Result()
BEGIN
DECLARE varCRN INT;
DECLARE varDiffLevel INT;
DECLARE varAvgGPA DECIMAL(3,2);
DECLARE varRecommendLevel VARCHAR(20);
DECLARE varCourseDepartment VARCHAR(15);
DECLARE varCourseNumber VARCHAR(10);
DECLARE varCourseName VARCHAR(100);
DECLARE exit_ok BOOLEAN DEFAULT FALSE;
DECLARE cusCur CURSOR FOR (SELECT c.CRN,c.Department,c.CourseNumber,c.CourseName
                            FROM Courses c JOIN DifficultyOfCourses USING (CRN) JOIN Difficulty USING (DifficultyLevel) JOIN CoursesHasGrades USING (CRN) JOIN Grades USING (GradeLevel)
                            WHERE DifficultyLevel < (SELECT AVG(DifficultyLevel)
                                                     FROM Difficulty)
                            AND AvgGPA > (SELECT Avg(AvgGPA)
                                          FROM Grades));
DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_ok = TRUE;
DROP TABLE IF EXISTS FinalTable;
CREATE TABLE FinalTable(
CRN INT PRIMARY KEY,Department VARCHAR(15),CourseNumber VARCHAR(10),CourseName VARCHAR(100),RecoLevel VARCHAR(20),Diff INT,GPA DECIMAL(3,2));

OPEN cusCur;
NICELOOP: LOOP
    FETCH cusCur INTO varCRN,varCourseDepartment,varCourseNumber,varCourseName;
    IF(exit_ok) THEN
        LEAVE NICELOOP;
    END IF;
    
    SET varDiffLevel=(SELECT DifficultyLevel
                            FROM Courses JOIN DifficultyOfCourses USING (CRN) JOIN Difficulty USING (DifficultyLevel)
                            WHERE Courses.CRN = varCRN AND DifficultyLevel < (SELECT AVG(DifficultyLevel)
                                                                              FROM Difficulty)
                            );
    SET varAvgGPA=(SELECT AvgGPA
                    FROM Courses JOIN CoursesHasGrades USING (CRN) JOIN Grades USING (GradeLevel)
                    WHERE Courses.CRN = varCRN AND AvgGPA > (SELECT Avg(AvgGPA)
                                                             FROM Grades)
                    );
                                                        
    IF (varDiffLevel < 2500 AND varAvgGPA >= 3.6) OR (varDiffLevel >= 2500 AND varDiffLevel <= 3500 AND varAvgGPA > 3.8) THEN
        SET varRecommendLevel = "Highly Recommended";
    END IF;
    
    IF (varDiffLevel < 2500 AND varAvgGPA < 3.6) OR (varDiffLevel >= 2500 AND varDiffLevel <= 3500 AND varAvgGPA <= 3.8 AND varAvgGPA >= 3.6) OR (varDiffLevel >3500 AND varAvgGPA > 3.8) THEN
        SET varRecommendLevel = "Recommended";
    END IF;
    
    IF (varDiffLevel >= 2500 AND varDiffLevel <= 3500 AND varAvgGPA <3.6) OR (varDiffLevel > 3500 AND varAvgGPA <= 3.8) THEN
        SET varRecommendLevel = "Not Recommended";
    END IF;
    
    INSERT INTO FinalTable VALUES(varCRN,varCourseDepartment,varCourseNumber,varCourseName,varRecommendLevel,varDiffLevel,varAvgGPA);
    
    END LOOP NICELOOP;

CLOSE cusCur;
    
END $$

DELIMITER ;

    
