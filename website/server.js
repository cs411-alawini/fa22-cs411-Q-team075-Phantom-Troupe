var express = require('express');
var bodyParser = require('body-parser');
var mysql = require('mysql2');
var path = require('path');
var connection = mysql.createConnection({
                host:'34.135.179.159',
          	user:'root',
		password:'phantom',
		database:'helpmegraduate'
});

connection.connect;

var app = express();

// set up ejs view engine
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
 
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(__dirname + '../public'));

/* GET home page, respond by rendering index.ejs */
app.get('/', function(req, res) {
  res.render('index', { title: 'Please enter your info to use our database.' });
});

app.get('/success', function(req, res) {
      res.render('index2',{title:'Successfully log in, please choose the operation you want.'});
});
 
// this code is executed when a user clicks the form submit button
app.post('/mark', function(req, res) {
  var UserID = req.body.UserID;
  
  var firstname = req.body.UserFirstName;

  var lastname = req.body.UserLastName;
 
  var sql = `INSERT INTO UserInfo(UserID,UserFirstName,UserLastName) VALUES ('${UserID}','${firstname}','${lastname}')`;

console.log(sql);
  connection.query(sql, function(err, result) {
    if (err) {
      res.send(err)
      return;
    }
    res.redirect('/success');
  });
}); 


// this code is the next page
app.post('/mark2',function(req,res){
var UserID = req.body.UserID;

var sql2 = `DELETE FROM UserInfo WHERE UserID = '${UserID}'`;

console.log(sql2);
connection.query(sql2,function(err2,result){
	if(err2){
	res.send(err2)
	return;
}
res.send('Delete successfully');
});
});

app.post('/searchusers',function(req,res){
var UserID = req.body.UserID;

var sql3 = `SELECT * FROM UserInfo WHERE UserID = '${UserID}'`;

console.log(sql3);
connection.query(sql3,function(err3,result){
        if(err3){
        res.send(err3)
        return;
}
res.send(result);
});
});

app.post('/updateusers',function(req,res){
var UserID = req.body.UserID;

var firstname = req.body.UserFirstName;

var lastname = req.body.UserLastName;

var sql4 = `UPDATE UserInfo SET UserFirstName='${firstname}',UserLastName='${lastname}' WHERE UserID = '${UserID}'`;

console.log(sql4);
connection.query(sql4,function(err4,result){
        if(err4){
        res.send(err4)
        return;
}
res.send('Update successfully');
});
});

app.post('/advq1',function(req,res){

var sql5 = `SELECT Courses.Department, Courses.CourseNumber, Professors.ProfessorName
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
ORDER BY Courses.CourseNumber`;

console.log(sql5);
connection.query(sql5,function(err5,result){
        if(err5){
        res.send(err5)
        return;
}
res.send(result);
});
});

app.post('/advq2',function(req,res){

var sql6 = `SELECT DISTINCT Courses.Department, Courses.CourseNumber,Courses.CourseName, Professors.ProfessorName,Professors.Rate
FROM Courses JOIN Teach USING (CRN) JOIN Professors USING (ProfessorID)
WHERE Courses.Department='CS' AND Professors.Rate > (SELECT avg(p.Rate) as AvgProfRate
                                                    FROM Professors p)
ORDER BY Professors.Rate DESC, Courses.CourseNumber ASC`;

console.log(sql6);
connection.query(sql6,function(err6,result){
        if(err6){
        res.send(err6)
        return;
}
res.send(result);
});
});

app.post('/normalq1',function(req,res){

var dep = req.body.Course_Dep;

var sql6 = `SELECT DISTINCT Courses.Department,Courses.CourseNumber,Courses.CourseName,Grades.AvgGPA,Difficulty.DifficultyLevel,Professors.ProfessorName,Professors.Rate
	 FROM Courses JOIN DifficultyOfCourses USING (CRN) JOIN Difficulty USING (DifficultyLevel)
	JOIN CoursesHasGrades USING (CRN) JOIN Grades USING (GradeLevel) JOIN Teach USING (CRN) JOIN Professors USING (ProfessorID)
	WHERE Courses.Department='${dep}'
	ORDER BY CourseNumber`; 

console.log(sql6);
connection.query(sql6,function(err6,result){
        if(err6){
        res.send(err6)
        return;
}
res.send(result);
});
});


app.listen(80, function () {
    console.log('Node app is running on port 80');
});
