

connection = sqlite3.connect("university.db")
cursor = connection.cursor()


def create_students_table():
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS students (
        student_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        gender TEXT
    )
    """)
    connection.commit()


def create_courses_table():
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS courses (
        course_id INTEGER PRIMARY KEY AUTOINCREMENT,
        course_name TEXT,
        credits INTEGER
    )
    """)
    connection.commit()


def create_enrollments_table():
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS enrollments (
        enrollment_id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER,
        course_id INTEGER,
        grade TEXT,
        FOREIGN KEY(student_id) REFERENCES students(student_id),
        FOREIGN KEY(course_id) REFERENCES courses(course_id)
    )
    """)
    connection.commit()


def add_student(name, age, gender):
    cursor.execute("INSERT INTO students (name, age, gender) VALUES (?, ?, ?)", (name, age, gender))
    connection.commit()


def add_course(course_name, credits):
    cursor.execute("INSERT INTO courses (course_name, credits) VALUES (?, ?)", (course_name, credits))
    connection.commit()


def enroll_student(student_id, course_id, grade):
    cursor.execute("INSERT INTO enrollments (student_id, course_id, grade) VALUES (?, ?, ?)", (student_id, course_id, grade))
    connection.commit()


def show_all_students():
    cursor.execute("SELECT * FROM students")
    data = cursor.fetchall()
    for row in data:
        print(row)


def show_all_courses():
    cursor.execute("SELECT * FROM courses")
    data = cursor.fetchall()
    for row in data:
        print(row)


def show_student_enrollments(student_id):
    cursor.execute("""
    SELECT students.name, courses.course_name, enrollments.grade 
    FROM enrollments 
    JOIN students ON enrollments.student_id = students.student_id 
    JOIN courses ON enrollments.course_id = courses.course_id 
    WHERE students.student_id = ?
    """, (student_id,))
    data = cursor.fetchall()
    for row in data:
        print(row)


def show_course_enrollments(course_id):
    cursor.execute("""
    SELECT courses.course_name, students.name, enrollments.grade 
    FROM enrollments 
    JOIN courses ON enrollments.course_id = courses.course_id 
    JOIN students ON enrollments.student_id = students.student_id 
    WHERE courses.course_id = ?
    """, (course_id,))
    data = cursor.fetchall()
    for row in data:
        print(row)


def update_student(student_id, name=None, age=None, gender=None):
    if name:
        cursor.execute("UPDATE students SET name = ? WHERE student_id = ?", (name, student_id))
    if age:
        cursor.execute("UPDATE students SET age = ? WHERE student_id = ?", (age, student_id))
    if gender:
        cursor.execute("UPDATE students SET gender = ? WHERE student_id = ?", (gender, student_id))
    connection.commit()


def update_course(course_id, course_name=None, credits=None):
    if course_name:
        cursor.execute("UPDATE courses SET course_name = ? WHERE course_id = ?", (course_name, course_id))
    if credits:
        cursor.execute("UPDATE courses SET credits = ? WHERE course_id = ?", (credits, course_id))
    connection.commit()


def delete_student(student_id):
    cursor.execute("DELETE FROM students WHERE student_id = ?", (student_id,))
    connection.commit()


def delete_course(course_id):
    cursor.execute("DELETE FROM courses WHERE course_id = ?", (course_id,))
    connection.commit()


create_students_table()
create_courses_table()
create_enrollments_table()


add_student("Mehemmed", 20, "Male")
add_student("Roya", 22, "Female")
add_course("Mathematics", 4)
add_course("Physics", 3)
enroll_student(1, 1, "A")
enroll_student(2, 2, "B")


print("Bütün tələbələr:")
show_all_students()
print("\nBütün kurslar:")
show_all_courses()
print("\nMehemmed-in qeydiyyatları:")
show_student_enrollments(1)
print("\nMathematics kursuna qeydiyyatlar:")
show_course_enrollments(1)


update_student(1, age=18)
update_course(2, credits=4)


print("\nYenilənmiş tələbələr:")
show_all_students()
print("\nYenilənmiş kurslar:")
show_all_courses()


delete_student(2)


print("\nSilinmiş tələbədən sonra tələbələr:")
show_all_students()


delete_course(1)


print("\nSilinmiş kursdan sonra kurslar:")
show_all_courses()


connection.close()


