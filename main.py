from flask import Flask, render_template, request
from sqlalchemy import create_engine, text, insert, Table, MetaData, desc

app = Flask(__name__)
conn_str = "mysql://root:cset155@localhost/cset160final"
engine = create_engine(conn_str, echo=True)
conn = engine.connect()

metadata = MetaData()
tests = Table('tests', metadata, autoload_with=engine)

@app.route("/", methods = ['POST'])
def home():
    render_template('index.html')

@app.route("/login")
def login():
    return render_template("login.html")


@app.route("/accounts")
@app.route("/accounts.html")
def accounts():
    teacherRows = conn.execute(text('SELECT * FROM teachers;')).all()
    studentRows = conn.execute(text('SELECT * FROM students;')).all()
    return render_template("accounts.html", teachers = teacherRows, students = studentRows)

@app.route('/create')
@app.route('/create.html', methods = ['GET', 'POST'])
def create():
    teacher_id = conn.execute(text('SELECT DISTINCT teacher_id FROM teachers;')).all()
    if request.method == 'POST':
        
        form = request.form.to_dict()
        stmt = insert(tests).values(
            testName=form['testName'], questionNum=form['questionNum'], question_1=form['question_1'],
            question_2=form['question_2'], question_3=form['question_3'], question_4=form['question_4'],
            question_5=form['question_5'], question_6=form['question_6'], question_7=form['question_7'],
            question_8=form['question_8'], question_9=form['question_9'], question_10=form['question_10'],
            question_11=form['question_11'], question_12=form['question_12'], question_13=form['question_13'],
            question_14=form['question_14'], question_15=form['question_15'], teacher_id = form['teacher_id'])
        conn.execute(stmt)
        conn.commit()

    return render_template("create.html", IDs = teacher_id)

if __name__ == "__main__":
    app.run(debug=True)