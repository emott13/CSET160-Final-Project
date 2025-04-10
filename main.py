from flask import Flask, render_template, request, redirect
from sqlalchemy import create_engine, text, insert, Table, MetaData, update
from scripts.shhhh_its_a_secret import customHash

app = Flask(__name__)                                                                   # initiates flask
conn_str = "mysql://root:cset155@localhost/cset160final"                                # connects to db
engine = create_engine(conn_str, echo=True)                                             # creates engine
conn = engine.connect()                                                                 # connects engine

metadata = MetaData()                                                                   # schema Table objects
tests = Table('tests', metadata, autoload_with=engine)                                  # variable for table 'tests'
grades = Table('grades', metadata, autoload_with=engine)                                # variable for table 'grades'

# fix issue with showing grader's name in test information

# --------------- #
# -- HOME PAGE -- # 
# --------------- #

@app.route("/", methods=["GET", "POST"])
@app.route('/home.html', methods=["GET", "POST"])
@app.route('/home', methods=["GET", "POST"])
def home():
    return render_template("home.html")                                                 # loads home page (page does not exists currently)


# ---------------- #
# -- LOGIN PAGE -- #
# ---------------- #

@app.route('/login.html', methods=["GET", "POST"])
@app.route("/login", methods=["GET", "POST"])
def loginPost():
    if request.method == "POST":                                                        # handles POST requests
        if loggedIntoType() is not None:                                                  # handles if already signed in
            return render_template('login.html', 
                                   error='You are currently signed in. Sign out to switch accounts.')
        accType = request.form['type']                                                  # can be students or teachers
        accounts = dict( conn.execute(                                                  # gets info from student/teacher tables
            text(f"select email, password from {accType}")).all() )

        email = request.form['email']                                                   # gets email from form
        password = request.form['password']                                             # gets pass from form
        checkAgainstHash = customHash(password)                                         # hashes password

        if email in accounts.keys() and accounts[email] == checkAgainstHash:            # checks email/pass against db
            logIntoDB(accType, email, password)                                         # records login
            return render_template("login.html",                                        # loads login page
                                   success = "Success. You are now logged in")          # with success message

        return render_template("login.html", error = "Error: Account not found")        # reloads with error message
    
    if request.method == "GET":                                                         # handles GET requests
        return render_template("login.html")                                            # loads login page


# ------------------ #
# -- SIGN UP PAGE -- # 
# ------------------ #

@app.route("/signup", methods=["GET", "POST"])
def signupPost():
    if request.method == "POST":
        try:
            accType = request.form['type']                                              # can be students or teachers
            password = request.form['password']                                         # gets pass from form                                     
            dbEmails = conn.execute(text(f"select email from {accType}")).all()         # gets emails from acc type in db
            print(password)
            hashedPass = customHash(password)                                           # hashes password
            print(hashedPass)
            print(dbEmails)

            for dbEmail in dbEmails:                                                    # loops through each email
                if dbEmail[0] == request.form['email']:                                 # if email matches form email
                    print("Email already exists")                                       # prevents sign up
                    return render_template("signup.html",                               # loads signup page with error message
                                           error="Error: Email already exists")
            conn.execute(
                text(f"INSERT INTO {accType} (first_name, last_name, email, password)"  # inserts form data
                    "VALUES (:fname, :lname, :email, :password)"),                      # into relevant student
                    {"fname": request.form["fname"],                                    # or teacher table
                    "lname": request.form["lname"], 
                    "email": request.form["email"], 
                    "password": hashedPass}
            )
            conn.commit()                                                               # commits changes to db
            logIntoDB(accType, request.form['email'], request.form['password'])         # logs in user
            return render_template("signup.html",                                       # loads signup page
                                   success = "Success! You are now signed in.")         # with success message
        except Exception as e:                                                          # if exception:
            print(f"Error: {e}")                                                        # prints error          
            return render_template("signup.html", error=f"Error: {e}")                  # loads signup page with error
    
    if request.method == "GET":                                                         # handles GET requests
        return render_template("signup.html")                                           # loads signup page


# ------------------- #
# -- ACCOUNTS PAGE -- #
# ------------------- #

@app.route("/accounts.html")
@app.route("/accounts")
def accounts():
    teacherRows = conn.execute(text('SELECT * FROM teachers;')).all()                   # gets teacher info from teacher table
    studentRows = conn.execute(text('SELECT * FROM students;')).all()                   # gets student info from student table
    return render_template("accounts.html",                                             # loads account page
                           teachers = teacherRows, students = studentRows)              # with info for display


# -------------------------- #
# -- CREATING A TEST PAGE -- #
# -------------------------- #

@app.route('/create.html', methods = ['GET', 'POST'])
@app.route('/create', methods = ['GET', 'POST'])
def create():
    if loggedIntoType() != "teacher":                                                   # forces teacher login
        return render_template("login.html",                                            # loads login page with error message
                        error = "You must be signed in as a teacher to grade a test.")
    teacher_id = conn.execute(                                                          # gets teacher ids from teacher table
        text('SELECT DISTINCT teacher_id FROM teachers ORDER BY teacher_id;')).all()  
    teacher_name = conn.execute(                                                        # gets full name from same table
        text("SELECT CONCAT(first_name, ' ', last_name) FROM teachers ORDER BY teacher_id;")).all() 
    if request.method == 'POST':                                                        # handles POST requests
        try:
            created_by = getCurrentUser()
            print(created_by)
            form = request.form.to_dict()                                               # converts form data to dict
            print(form['teacher_id'])
            stmt = insert(tests).values(                                                # defines insert statement
                testName=form['testName'], questionNum=form['questionNum'],             # statement includes test name,
                question_1=form['question_1'], question_2=form['question_2'],           # questions 1-15, and teach ID
                question_3=form['question_3'], question_4=form['question_4'],
                question_5=form['question_5'], question_6=form['question_6'], 
                question_7=form['question_7'], question_8=form['question_8'], 
                question_9=form['question_9'], question_10=form['question_10'],
                question_11=form['question_11'], question_12=form['question_12'], 
                question_13=form['question_13'], question_14=form['question_14'], 
                question_15=form['question_15'], teacher_id = form['teacher_id'],
                created_by = created_by)
            conn.execute(stmt)                                                          # executes statement
            conn.commit()                                                               # commits changes to db
            return render_template("create.html",                                       # loads create page with
                                   IDs = teacher_id, names = teacher_name)              # teacher ids and names for display
        except Exception as e:
            return render_template(                                                     # if error occurs, loads page
                "create.html", IDs = teacher_id, names = teacher_name,                  # with id/name data and error message
                error=e)
    else:                                                                               # handles GET requests
        return render_template("create.html", IDs = teacher_id, names = teacher_name)   # loads create page with id/name data


# ------------------------ #
# -- VIEWING TESTS PAGE -- #
# ------------------------ #

@app.route("/test", methods=['GET', 'POST'])
def test(error=""):
    testRows = conn.execute(text('SELECT * FROM tests;')).all()                         # gets all data from tests table
    if not testRows:                                                                    # handles if no tests in db
        return render_template("test.html",                                             # loads test page with 
                               tests=[], teachers=[], error="No tests available.")      # error message
    teachers = []                                                                       # empty list for teacher names
    for row in testRows:                                                                # loops through testRows results
        teacher_id = row[1]                                                             # teacher_id is the second column
        teacher_name = conn.execute(                                                    # gets teach full name
            text("SELECT CONCAT(first_name, ' ', last_name)"                            
                 f"FROM teachers WHERE teacher_id = {teacher_id}")).all()               
        teachers.append(teacher_name[:] if teacher_name else ["Unknown"])               # appends name or 'unknown'
    return render_template("test.html", tests=testRows,                                 # loads test page with test,
                           teachers=teachers, message=error)                            # teacher, and message data


# -------------------- #
# -- TEST INFO PAGE -- #
# -------------------- #

@app.route('/test_info', methods=['GET', 'POST'])
def testInfo():
    testRows = conn.execute(                                                            # gets test_id, testName, and 
        text('SELECT test_id, testName, created_by FROM tests;')).all()                 # created_by from tests table
    count = {row[0]: row[1] for row in conn.execute(                                                               # gets test_id, # of attempts from attempts table
        text('SELECT test_id, COUNT(*) FROM attempts GROUP BY test_id')).all()}
    print('count:', count)
    grades = conn.execute(text('SELECT * FROM grades')).all()                           # gets grade data from grades table
    teacher_dict = {row[0]: row[1] for row in conn.execute(text(                        # gets teacher_id, name from teachers table
        'SELECT teacher_id, CONCAT(first_name, " ", last_name) FROM teachers;'          # and converts to dict
    )).all()}
    student_dict = {row[0]: row[1] for row in conn.execute(text(                        # gets student_id, name from students table
        'SELECT student_id, CONCAT(first_name, " ", last_name) FROM students;'          # and converts to dict
    )).all()}              
    print('count:', count)
    print('testRows:', testRows)
    print('grades:', grades)
    print('teachers:', teacher_dict)
    print('students:', student_dict)
    return render_template('test_info.html', testRows = testRows,                       # loads test_info page with testRows, count,
                           count = count, gradeData = grades,                           # grades, teacher_dict, and student_dict
                           teacher_dict = teacher_dict, student_dict = student_dict)


# ------------------------ #
# -- TEST ATTEMPTS PAGE -- # 
# ------------------------ #

@app.route('/attempts', methods=['GET', 'POST'])
def attempts():
    fullData = conn.execute(
      text('SELECT * FROM tests '
            'JOIN attempts ON tests.test_id = attempts.test_id;')).all()                # gets data from tables tests & attemps cross joined
    print(fullData)
    teacherData = {                                                                     # gets teacher id and name, converts to dict
        row[0]: row[1] for row in conn.execute(
            text('SELECT teacher_id, CONCAT(first_name, " ", last_name) '
                 'FROM teachers WHERE teacher_id IN (SELECT teacher_id FROM tests);')
        ).all()
    }
    studentData = {                                                                     # gets student id and name, converts to dict
        row[0]: row[1] for row in conn.execute(
            text('SELECT student_id, CONCAT(first_name, " ", last_name) '
                 'FROM students WHERE student_id IN (SELECT student_id FROM attempts);')
        ).all()
    }
    gradeData = {                                                                       # gets test_id, student_id, and grade
        (row[0], row[1]): row[2] for row in conn.execute(                               # from grades table, converts to dict
            text('SELECT test_id, student_id, grade FROM grades;')
        ).all()
    }
    return render_template('attempts.html', hii = "hieeee",                             # loads attempts page with tests/attempts data,
        fullData=fullData, teacherData=teacherData, 
        studentData=studentData, gradeData = gradeData)                                 # teacher data, and student data


# ------------------ #
# -- TEST GRADING -- #
# ------------------ #

@app.route('/grade/<int:test_id>/<int:tid>/<int:sid>', methods=['POST'])
def grade(test_id, tid, sid): 
    if loggedIntoType() != "teacher":                                                   # forces teacher login
        return render_template("login.html",                                            # loads login page with error message
                        error = "You must be signed in as a teacher to grade a test.")                                                         
    formDict = request.form.to_dict()                                                   # form data to dict
    score = list(formDict.values())[0]                                                  # form dict to list object to list to get score
    
    check = conn.execute(                                                               # check if grade already exists
        text('SELECT * FROM grades WHERE test_id = :test_id AND graded_by = :tid AND student_id = :sid'),
            {'test_id': test_id, 'tid': tid, 'sid': sid}).fetchone()                    # get one row if it exists

    if check is None:                                                                   # if no grade exists, insert a new one
        conn.execute(                                                               
            text('INSERT INTO grades (test_id, student_id, graded_by, grade) VALUES (:test_id, :sid, :tid, :score)'),
            {'test_id': test_id, 'sid': sid, 'tid': tid, 'score': score}
        )
    else:                                                                               # else grade exists, update it
        conn.execute(
            text('UPDATE grades SET grade = :score WHERE test_id = :test_id AND graded_by = :tid AND student_id = :sid'),
            {'test_id': test_id, 'tid': tid, 'sid': sid, 'score': score}
        )

    conn.commit()                                                                       # commit changes to db
    return redirect('/home')                                                            # redirects to home (will change later)


# ---------------------- #
# -- TAKING TEST PAGE -- #
# ---------------------- #

@app.route("/test/<int:test_id>", methods=["GET", "POST"])
def take_test(test_id):
    if loggedIntoType() != "student":                                                   # forces student login
        return render_template("login.html",                                            # loads login page with error message
                               error = "You must be signed in as a student to take a test")

    stud_id = conn.execute(text("SELECT student_id FROM loggedin")).all()[0][0]         # gets student id info from db
    testData = conn.execute(text("SELECT * FROM tests "                                 # gets test info from db
                                f"WHERE test_id = {test_id}")).all()
    if not testData:                                                                    # handles if no test info
        print("This test does not exist")                                               # terminal error message
        return redirect("/test")                                                        # redirects to test page

    if request.method == "GET":                                                         # handles GET requests
        duplicates = conn.execute(
            text("SELECT * FROM attempts "                                              # gets prev test attempt info
                f"WHERE (test_id = {test_id}) AND (student_id = {stud_id})")).all()
        
        if duplicates:                                                                  # handles if test already taken
            print("ran duplicates")                                                     # by currently logged in student
            return redirect("/test")                                                    # redirects to test page

        question_num = testData[0][3]                                                   # defines num of questions from testData
        questions = [testData[0][i] for i in range(4, question_num + 4)]                # defines questions from testData
        return render_template("take_test.html",                                        # loades take test page with
                               testData = testData, questions = questions)              # testData and questions

    if request.method == "POST":                                                        # handles POST requests
        questionsStr = ""
        answersStr = ""
        comma = False

        for i in range(1, testData[0][3] + 1):
            if comma:
                questionsStr += ', '
                answersStr += ', '
            questionsStr += "answer_" + str(i)
            answersStr += "'" + request.form["question_" + str(i)] + "'"
            comma = True

        conn.execute(
            text(f"INSERT INTO attempts(test_id, student_id, questionNum, {questionsStr}) "
                 f"VALUES ({testData[0][0]}, {stud_id},  {testData[0][3]}, {answersStr})"))
        conn.commit()

        return redirect("/test")


# ------------------------ #
# -- EDITING TESTS PAGE -- #
# ------------------------ #

@app.route('/edit/<int:test_id>', methods=["GET", "POST"])
def editTest(test_id):
    if request.method == 'GET':                                                         # handles GET requests
        if loggedIntoType() != 'teacher':                                               # forces teacher login
            return render_template('login.html',                                        # loads login page with error message
                                   error='You must be logged in as a teacher to edit a test.')
        else:                                                                           # if loggin as teacher
            teacher_id = conn.execute(                                                  # gets teacher ids from teacher table
                text('SELECT DISTINCT teacher_id FROM teachers ORDER BY teacher_id;')).all()  
            teacher_name = conn.execute(                                                # gets full name from same table
                text("SELECT CONCAT(first_name, ' ', last_name) FROM teachers ORDER BY teacher_id;")).all() 
            testData = conn.execute(text(                                               # gets test info from tests matching test_id
                f'SELECT * FROM tests WHERE test_id = {test_id};'
            )).all()
            teach_id = testData[0][1]                                                   # defines teacher id
            teach_name = conn.execute(text(                                             # gets teacher full name matching teacher id
                'SELECT CONCAT(first_name, " ", last_name)'
                f'FROM teachers WHERE teacher_id = {teach_id};'
            )).all()
            test_name = testData[0][2]                                                  # defines test name
            question_num = testData[0][3]                                               # defines number of questions
            questions = [testData[0][i] for i in range(4, question_num + 4)]            # defines questions in list

            return render_template('edit.html', test_id = test_id,                      # loads test editing page with
                                   IDs = teacher_id, names = teacher_name,              # teacher ids, teacher names, 
                                   current_teach = teach_name, test_name = test_name,   # current teacher name for test, test name,
                                   question_num = question_num, questions=questions)    # number of questions, and questions list
    
    elif request.method == 'POST':                                                      # handles POST requests
        try:
            form = request.form.to_dict()                                               # converts form data to dict
            stmt = update(tests).where(tests.c.test_id == form['test_id']).values(      # defines statment for updating test with
                testName=form['testName'], questionNum=form['questionNum'],             # test name, number of questions, 
                question_1=form['question_1'], question_2=form['question_2'],           # questions 1-15, and teacher id
                question_3=form['question_3'], question_4=form['question_4'],
                question_5=form['question_5'], question_6=form['question_6'], 
                question_7=form['question_7'], question_8=form['question_8'], 
                question_9=form['question_9'], question_10=form['question_10'],
                question_11=form['question_11'], question_12=form['question_12'], 
                question_13=form['question_13'], question_14=form['question_14'], 
                question_15=form['question_15'], teacher_id = form['teacher_id'])
            conn.execute(stmt)                                                          # executes statement
            conn.commit()                                                               # commits changes to db
            teachers, testRows = getTeachersAndTestRows()                               # gets teachers and test rows
            return render_template("test.html", tests=testRows, teachers=teachers,      # loads tests page with testRows, teacher names,
                                   message="The test has been updated.")                # and update message
        except Exception as e:                                                          # handles errors
            print(f"Error: {e}")                                                        # prints terminal error message
            return render_template("test.html",                                         # loads tests page with error message
                                   message="There was an error saving your test changes.")
        
# ------------------------ #
# -- DELETING TEST PAGE -- #
# ------------------------ #

@app.route('/delete/<int:test_id>', methods = ['POST'])
def delete(test_id):
    if loggedIntoType() != 'teacher':                                                   # forces teacher login
        return render_template('login.html',                                            # loads login page with error message
                               error="You must be logged in as a teacher to delete a test.")

    try:                                                                                # tries deletion
        conn.execute(text('DELETE FROM grades WHERE test_id = :test_id'),             # deletes test attempts matching test_id
                     {'test_id': test_id})
        conn.execute(text('DELETE FROM attempts WHERE test_id = :test_id'),             # deletes test attempts matching test_id
                     {'test_id': test_id})
        conn.execute(text('DELETE FROM tests WHERE test_id = :test_id'),                # deletes test matching test_id
                     {'test_id': test_id})
        conn.commit()                                                                   # commits changes to db
        teachers, testRows = getTeachersAndTestRows()                                   # gets teachers and test rows
        return render_template('test.html', tests=testRows,                             # loads test page with test rows,
                           teachers=teachers, message='Test deleted successfully.')     # teachers, and success message
    except Exception as e:                                                              # if exception
        print(f'Error deleting test: {e}')                                              # prints terminal error
        teachers, testRows = getTeachersAndTestRows()                                   # gets teachers and testRows
        return render_template('test.html', tests=testRows, teachers=teachers,          # loads test page with test rows,
                                message="An error occured while deleting the test.")    # teachers, and error message

# ---------------------- #
# -- VIEW GRADES PAGE -- #
# ---------------------- #

@app.route("/view_grades")
def takeTest():
    gradesData = conn.execute(text('SELECT * FROM tests '
                                   'JOIN attempts ON tests.test_id = attempts.test_id '
                                   'JOIN grades ON grades.student_id = attempts.student_id '
                                   'JOIN students ON students.student_id = grades.student_id;')).all()              
    uniqueStudentsTaken = conn.execute(text('SELECT DISTINCT student_id, CONCAT(first_name, \' \', last_name) FROM grades '
                                            'NATURAL JOIN students;'))
    return render_template("view_grades.html",                                          # loads account page
                           gradesData = gradesData,                                     # with info for display
                           uniqueStudents = uniqueStudentsTaken)

# ------------------ #
# -- ACCOUNT INFO -- #
# ------------------ #

@app.route("/account_info")
def accountInfo():
    accType = loggedIntoType()
    print(accType)
    if accType is None:
        return render_template("login.html", error='Sign in to view account information.')

    loggedInId = conn.execute(text(f"SELECT {accType}_id FROM loggedin;")).all()[0][0]
    accInfo = conn.execute(text(f"SELECT {accType}_id, first_name, last_name FROM {accType}s "
                                f"WHERE {accType}_id = {loggedInId};")).all()[0]
    return render_template("account_info.html", accInfo = accInfo, accType = accType)

@app.route("/logout", methods=["GET", 'POST'])
def logout():
    conn.execute(text("UPDATE loggedin SET student_id = NULL, teacher_id = NULL;"))
    conn.commit()
    return render_template("login.html", message='You have been successfully logged out.')

# --------------- #
# -- FUNCTIONS -- #
# --------------- #

# Uses the account type (Either "students" or "teachers") with the email and password to sign the user in the DB
def logIntoDB(accType, email=None, password=None):                                      # FUNCTION handles user login
        if accType is None:                                                             # accType(None) logs the user out
            conn.execute(text("UPDATE loggedin "                                        # clears logged in info from loggedin table
                            f"SET student_id = NULL, teacher_id = NULL"))
            conn.commit()                                                               # commits changes to db
            return
        
        stmt = text(f"SELECT {accType[:-1]}_id FROM {accType} WHERE email = :email")    # defines statement to get id based on acc type
        result = conn.execute(stmt, {"email": email}).fetchall()                        # defines executed statement
        
        if not result:                                                                  # if no result
            return
        
        stored_id = result[0][0]                                                        # stores id if result not empty

        conn.execute(                                                                   # updates loggedin table based on
            text("UPDATE loggedin SET student_id = :stud_id, teacher_id = :teach_id"),  # acc type and id
                {'stud_id': stored_id if accType == 'students' else None,
                'teach_id': stored_id if accType == 'teachers' else None}
        )                                             
        conn.commit()                                                                   # commits changes to db

def loggedIntoType():                                                                   # FUNCTION checks user type that is logged in 
    value = conn.execute(text("SELECT * FROM loggedin")).all()
    
    if value[0][0]:                                                                     # returns student type if 
        return "student"                                                                # student_id is not null 
    elif value[0][1]:                                                                   # returns teacher type if
        return "teacher"                                                                # teacher_id is not null
    else:                                                                               # else both are null and 
        return None                                                                     # is therefore not signed in

def getCurrentUser():                                                                   # FUNCTION gets current user id
    user = conn.execute(text('SELECT * FROM loggedin;')).all()                          # gets data from loggedin table

    if loggedIntoType() == 'student':                                               # if student type account
        return user[0][0]                                                               # return student_id
    elif loggedIntoType() == 'teacher':                                             # elif teacher type account
        return user[0][1]                                                               # return teacher_id

def getTeachersAndTestRows():                                                           # FUNCTION gets teacher/test data
    testRows = conn.execute(text('SELECT * FROM tests;')).all()                         # gets all data from tests table
    if not testRows:                                                                    # handles if no tests in db
        return None, None                                                               # error message
    
    teachers = []                                                                       # empty list for teacher names
    for row in testRows:                                                                # loops through testRows results
        teacher_id = row[1]                                                             # teacher_id is the second column
        teacher_name = conn.execute(                                                    # gets teach full name
            text("SELECT CONCAT(first_name, ' ', last_name)"                            
                 f"FROM teachers WHERE teacher_id = {teacher_id}")).all()               
        teachers.append(teacher_name[:] if teacher_name else ["Unknown"])               # appends name or 'unknown'
    return teachers, testRows

if __name__ == "__main__":                                                              # helps prevent file from running if imported
    app.run(debug=True)