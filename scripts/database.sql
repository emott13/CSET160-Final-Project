-- STATEMENTS TO CREATE DATABASE -- 
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
    created_by INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (created_by) REFERENCES teachers(teacher_id),
    INDEX idx_teacher_id (teacher_id)
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
    FOREIGN KEY (test_id) REFERENCES attempts(test_id),
    FOREIGN KEY (student_id) REFERENCES attempts(student_id),
    FOREIGN KEY (graded_by) REFERENCES tests(teacher_id)
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
-- prehashed values for passwords. all same: TestPass01! -- 
INSERT INTO teachers (first_name, last_name, email, password)
VALUES
	('John', 'Smith', 'jsmith@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('jane', 'Doe', 'jdoe@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Irene", "Marchand", "imarchand@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Aishwarya", "Midgley", "amidgley@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Kamila", "Anselmi", "kanselmi@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Iael", "Nussenbaum", "inussenbaum@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Kalliope", "Mazur", "kmazur@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Shana ", "Michaels", "smichaels@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Josua", "Kavaliou", "jkavaliou@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Brynjarr", "Carey", "bcarey@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Domitilla", "Sudworth", "dsudworth@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Zach", "Cvetkovic", "zcvetkovic@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Shou", "Le", "sle@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Isaac", "Myers", "imyers@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Maja", "Ismailova", "mismailova@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Darina", "Polakova", "dpolakova@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Sujay", "Petocs", "spetocs@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Mirka", "MacNeill", "mmacneill@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Dayna", "Assenberg", "dassenberg@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Daedalus", "Dziedzic", "ddziedzic@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Janvier", "Nakamura", "jnakamura@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Erramun", "Xu", "exu@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Boitumelo", "Gomulka", "bgomulka@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Emma", "Sedlackova", "esedlackova@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'),
	("Danijela", "Zsoldos", "dzsoldos@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ("Gavin", "Bryan", "gbryan@gradehub.com", '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ');

INSERT INTO students(first_name, last_name, email, password)
VALUES
	('Bogomilu','Willard','bwillard@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Junius','Dannel','jdannel@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Sashi','Bazzoli','sbazzoli@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Carlo','Araullo','caraullo@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Tancred','Yurchenko','tyurchenko@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Caelia','Ramos','cramos@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Imogene','Jesus','ijesus@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Mary','Colt','mcolt@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Jaak','Baumer','jbaumer@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Stacia','Bellerose','sbellerose@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Gemini','Kadyrov','gkadyrov@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Laurynas','Sheehy','lsheehy@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Sandra','McGee','smcgee@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Thomas','Garey','tgarey@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Elwira','Fukui','efukui@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Hakon','Graf','hgraf@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Isaac','Macnamara','imacnamara@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Anna','Bosch','abosch@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Annelies','Leonardsen','aleonardsen@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Celeste','Rademaker','crademaker@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Ildo','Schroder','ischroder@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Andre','Diaz','adiaz@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Nelda','Kuznetsova','nkuznetsova@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Maggie','Addisons','maddisons@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Joanna','Schroder','jshroder@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ'), 
    ('Merja','Avci','mavci@gradehub.com', '$+&2q9e~*$1+JR=G_#K$8`!_/k~9?3#oEJ/`dLe*D$5?_GR#kPEk2JK2;kdE8#$2mmd/=G5#EK0dR=$3RG18L20J0~q;Q`#2`0~=e@Gq_`2@+JRDQ5i/3~*;L`95&@mq/D=1`ei&D*~kQKdKR1d+$k2R!5m2_RQo_L=KQ5@J$=@93R~2i`;#J`1J8Km`#*`D@11qq_o/&Q`+e`&3?`EDio9?*K55iL82Pm`;&o1/GJi@_mo/DQ');
INSERT INTO loggedin
VALUES (NULL, NULL);
-- drop database cset160final;