CREATE DATABASE IF NOT EXISTS cset160final;
USE cset160final;
CREATE TABLE IF NOT EXISTS students(
	student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    email VARCHAR(40),
    password VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS teachers(
	teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    email VARCHAR(40),
    password VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS tests(
	test_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    tests_taken INT NOT NULL DEFAULT 0,
    teacher_id INT NOT NULL, 
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);
-- CREATE TABLE IF NOT EXISTS questions(
-- 	question_id INT PRIMARY KEY AUTO_INCREMENT,
--     question VARCHAR(255) NOT NULL,
--     test_id INT NOT NULL,
--     FOREIGN KEY (test_id) REFERENCES tests(test_id)
-- );
-- CREATE TABLE IF NOT EXISTS attempts(
-- 	attempt_id INT PRIMARY KEY AUTO_INCREMENT,
--     score INT,
--     test_id INT NOT NULL,
--     student_id INT NOT NULL,
--     FOREIGN KEY (test_id) REFERENCES tests(test_id),
--     FOREIGN KEY (student_id) REFERENCES students(student_id)
-- );
-- CREATE TABLE IF NOT EXISTS stud_answers(
-- 	answer VARCHAR(255),
--     question_id INT NOT NULL,
--     attempt_id INT NOT NULL,
--     FOREIGN KEY (question_id) REFERENCES questions(question_id),
--     FOREIGN KEY (attempt_id) REFERENCES attempts(attempt_id)
-- );
CREATE TABLE IF NOT EXISTS loggedin(
    student_id INT,
    teacher_id INT, 
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

ALTER TABLE teachers AUTO_INCREMENT=90000;
ALTER TABLE students AUTO_INCREMENT=10000;
ALTER TABLE tests AUTO_INCREMENT=780000;
-- ALTER TABLE tests ADD FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id);

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

-- INSERT INTO tests(name, teacher_id)
-- VALUES
-- 	("Science", 90000),
--     ("History", 90001);

-- INSERT INTO questions(

SELECT * FROM teachers;
SELECT * FROM students;