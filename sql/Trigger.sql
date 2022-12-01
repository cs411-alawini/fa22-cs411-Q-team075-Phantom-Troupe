DELIMITER $$
CREATE TRIGGER ProfessorRate
BEFORE UPDATE ON Professors
FOR EACH ROW
BEGIN
IF new.Department = "ECE" THEN
SET new.Rate=new.Rate + 1;
END IF;
END $$
DELIMITER ;
