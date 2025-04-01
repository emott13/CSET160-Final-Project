-- Needed to create db 
CREATE DATABASE IF NOT EXISTS cset160final;
USE cset160final;
CREATE TABLE IF NOT EXISTS students(
	student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    email VARCHAR(40) UNIQUE,
    password VARCHAR(300)
);
CREATE TABLE IF NOT EXISTS teachers(
	teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    email VARCHAR(40) UNIQUE,
    password VARCHAR(300)
);
CREATE TABLE IF NOT EXISTS tests(
	test_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL,
    testName VARCHAR(255),
    questionNum INT,
    question_1 VARCHAR(255),
	question_2 VARCHAR(255),
	question_3 VARCHAR(255),
	question_4 VARCHAR(255),
	question_5 VARCHAR(255),
	question_6 VARCHAR(255),
	question_7 VARCHAR(255),
	question_8 VARCHAR(255),
	question_9 VARCHAR(255),
	question_10 VARCHAR(255),
	question_11 VARCHAR(255),
	question_12 VARCHAR(255),
	question_13 VARCHAR(255),
	question_14 VARCHAR(255),
    question_15 VARCHAR(255),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (created_by) REFERENCES teachers(teacher_id),
    INDEX idx_teacher_id (teacher_id)
);
CREATE TABLE IF NOT EXISTS test_information(
	test_id INT UNIQUE,
	created_by INT,
    attempts INT,
    FOREIGN KEY (test_id) REFERENCES tests(test_id)
);
CREATE TABLE IF NOT EXISTS attempts(
	test_id INT NOT NULL,
    student_id INT NOT NULL,
	testName VARCHAR(255),
    questionNum INT,
    answer_1 VARCHAR(255),
	answer_2 VARCHAR(255),
	answer_3 VARCHAR(255),
	answer_4 VARCHAR(255),
	answer_5 VARCHAR(255),
	answer_6 VARCHAR(255),
	answer_7 VARCHAR(255),
	answer_8 VARCHAR(255),
	answer_9 VARCHAR(255),
	answer_10 VARCHAR(255),
	answer_11 VARCHAR(255),
	answer_12 VARCHAR(255),
	answer_13 VARCHAR(255),
	answer_14 VARCHAR(255),
    answer_15 VARCHAR(255),
    FOREIGN KEY (test_id) REFERENCES tests(test_id), 
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    UNIQUE KEY (test_id, student_id)
);
CREATE TABLE IF NOT EXISTS grades (
	test_id INT,
    student_id INT,
    graded_by INT,
    grade DECIMAL,
    FOREIGN KEY (test_id) REFERENCES tests(test_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (graded_by) REFERENCES teachers(teacher_id)
);
CREATE TABLE IF NOT EXISTS loggedin (
    student_id INT,
    teacher_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);
ALTER TABLE teachers AUTO_INCREMENT=90000;
ALTER TABLE students AUTO_INCREMENT=10000;
ALTER TABLE tests AUTO_INCREMENT=780000;

-- ALTER TABLE tests ADD INDEX idx_teacher_id (teacher_id); 
ALTER TABLE tests ADD FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id);
-- ALTER TABLE attempts ADD COLUMN testName VARCHAR(255) AFTER student_id;

INSERT INTO teachers (first_name, last_name, email)
VALUES
	('John', 'Smith', 'jsmith@gradehub.com'), ('jane', 'Doe', 'jdoe@gradehub.com'),
	("Irene", "Marchand", "imarchand@gradehub.com"), ("Aishwarya", "Midgley", "amidgley@gradehub.com"),
	("Kamila", "Anselmi", "kanselmi@gradehub.com"), ("Iael", "Nussenbaum", "inussenbaum@gradehub.com"),
	("Kalliope", "Mazur", "kmazur@gradehub.com"), ("Shana ", "Michaels", "smichaels@gradehub.com"),
	("Josua", "Kavaliou", "jkavaliou@gradehub.com"), ("Brynjarr", "Carey", "bcarey@gradehub.com"),
	("Domitilla", "Sudworth", "dsudworth@gradehub.com"), ("Zach", "Cvetkovic", "zcvetkovic@gradehub.com"),
	("Shou", "Le", "sle@gradehub.com"), ("Isaac", "Myers", "imyers@gradehub.com"),
	("Maja", "Ismailova", "mismailova@gradehub.com"), ("Darina", "Polakova", "dpolakova@gradehub.com"),
	("Sujay", "Petocs", "spetocs@gradehub.com"), ("Mirka", "MacNeill", "mmacneill@gradehub.com"),
	("Dayna", "Assenberg", "dassenberg@gradehub.com"), ("Daedalus", "Dziedzic", "ddziedzic@gradehub.com"),
	("Janvier", "Nakamura", "jnakamura@gradehub.com"), ("Erramun", "Xu", "exu@gradehub.com"),
	("Boitumelo", "Gomulka", "bgomulka@gradehub.com"), ("Emma", "Sedlackova", "esedlackova@gradehub.com"),
	("Danijela", "Zsoldos", "dzsoldos@gradehub.com"), ("Gavin", "Bryan", "gbryan@gradehub.com");

INSERT INTO students(first_name, last_name, email)
VALUES
	('Bogomilu','Willard','bwillard@gradehub.com'), ('Junius','Dannel','jdannel@gradehub.com'), 
    ('Sashi','Bazzoli','sbazzoli@gradehub.com'), ('Carlo','Araullo','caraullo@gradehub.com'), 
    ('Tancred','Yurchenko','tyurchenko@gradehub.com'), ('Caelia','Ramos','cramos@gradehub.com'), 
    ('Imogene','Jesus','ijesus@gradehub.com'), ('Mary','Colt','mcolt@gradehub.com'), 
    ('Jaak','Baumer','jbaumer@gradehub.com'), ('Stacia','Bellerose','sbellerose@gradehub.com'), 
    ('Gemini','Kadyrov','gkadyrov@gradehub.com'), ('Laurynas','Sheehy','lsheehy@gradehub.com'), 
    ('Sandra','McGee','smcgee@gradehub.com'), ('Thomas','Garey','tgarey@gradehub.com'), 
    ('Elwira','Fukui','efukui@gradehub.com'), ('Hakon','Graf','hgraf@gradehub.com'), 
    ('Isaac','Macnamara','imacnamara@gradehub.com'), ('Anna','Bosch','abosch@gradehub.com'), 
    ('Annelies','Leonardsen','aleonardsen@gradehub.com'), ('Celeste','Rademaker','crademaker@gradehub.com'), 
    ('Ildo','Schroder','ischroder@gradehub.com'), ('Andre','Diaz','adiaz@gradehub.com'), 
    ('Nelda','Kuznetsova','nkuznetsova@gradehub.com'), ('Maggie','Addisons','maddisons@gradehub.com'), 
    ('Joanna','Schroder','jshroder@gradehub.com'), ('Merja','Avci','mavci@gradehub.com');
INSERT INTO loggedin
VALUES (NULL, NULL);

-- All following queries are not needed to create db, made for adjustments as we recognized changes needed


-- ALTER TABLE tests ADD INDEX idx_teacher_id (teacher_id);
-- ALTER TABLE tests ADD FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id);
-- ALTER TABLE attempts ADD COLUMN testName VARCHAR(255) AFTER student_id; 

SELECT * FROM test_information;
-- SELECT * FROM loggedin;
-- SELECT * FROM teachers where teacher_id = 90014;
-- SELECT * FROM students;
SELECT * FROM tests where test_id = 780005;
SELECT * FROM tests;
SELECT * FROM attempts;
-- SELECT * FROM grades;
-- SELECT * FROM tests CROSS JOIN attempts;
-- SELECT CONCAT(first_name, " ", last_name) FROM teachers WHERE teacher_id IN(90000, 90001, 90002, 90003) ORDER BY first_name ASC;

-- alter table grades modify grade decimal;
-- alter table students modify column password varchar(300);