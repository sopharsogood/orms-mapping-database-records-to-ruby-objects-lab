class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
      SQL
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
      SQL
      
    DB[:conn].execute(sql, name).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      SQL
      
    DB[:conn].execute(sql, 9).collect do |row|
      self.new_from_db(row)
    end
  end 

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < ?
      SQL
    
    DB[:conn].execute(sql, 12).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(number_of_students)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
      SQL
    
    DB[:conn].execute(sql, number_of_students).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1
      SQL
      
    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      SQL
    
    DB[:conn].execute(sql, grade).collect do |row|
      self.new_from_db(row)
    end
  end
end
