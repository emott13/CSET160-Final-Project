from sqlalchemy import create_engine, text

conn_str = "mysql://root:cset155@localhost/cset160final"
engine = create_engine(conn_str, echo=True)
conn = engine.connect()

def setUpDatabase():
    conn.execute(text('CREATE DATABASE IF NOT EXISTS cset160final;'))
    conn.execute(text('USE cset160final;'))    
    conn.execute(
        text('CREATE TABLE IF NOT EXISTS students('
                'student_id INT AUTO_INCREMENT PRIMARY KEY,'
                'first_name VARCHAR(40),'
                'last_name VARCHAR(40),'
                'email VARCHAR(40),'
                'password VARCHAR(255)'
            ');'))
    conn.execute(
        text('CREATE TABLE IF NOT EXISTS teachers('
                'teacher_id INT AUTO_INCREMENT PRIMARY KEY,'
                'first_name VARCHAR(40),'
                'last_name VARCHAR(40),'
                'email VARCHAR(40),'
                'password VARCHAR(255)'
            ');'))
    conn.execute(
        text('CREATE TABLE IF NOT EXISTS tests('
                'test_id INT AUTO_INCREMENT PRIMARY KEY,'
                'teacher_id INT NOT NULL'
            ');'))
    conn.execute(text('ALTER TABLE teachers AUTO_INCREMENT=90000;'))
    conn.execute(text('ALTER TABLE students AUTO_INCREMENT=10000;'))
    conn.execute(text('ALTER TABLE tests AUTO_INCREMENT=780000;'))

if __name__ == 'main':
    setUpDatabase()