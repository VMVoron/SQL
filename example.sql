https://sql-academy.org/ru/sandbox

Задание 1: Найдите всех учеников, у которых имя начинается на букву A.
SELECT * FROM Student WHERE first_name LIKE 'A%';

Задание 2: Найдите всех учеников c фамилиями 'Evseeva', 'Osipova' и 'Lukina'.
SELECT * FROM Student 
WHERE last_name IN ('Evseeva', 'Osipova', 'Lukina');

Задание 3: Посчитайте сколько учеников в классах. Отсортируйте по количеству учеников в порядке убывания.
SELECT 
      c.name class_name, 
      COUNT(DISTINCT s.student) student_count
FROM 
   student_in_class s
      JOIN 
         class c
      ON c.id=s.class
GROUP BY c.name
ORDER BY 2 DESC;


Задание 4: Из задания 3 выберите только те классы, в которых количество учеников меньше 10.
Задание 4.1
SELECT * FROM (
    SELECT 
          c.name class_name, 
          COUNT(DISTINCT s.student) student_count
    FROM 
       student_in_class s
          JOIN 
             class c
          ON c.id=s.class
    GROUP BY c.name
    ORDER BY 2 DESC) as X
WHERE student_count < 10;

Задание 4: Составьте расписание для '11 A' класса с 2019-09-01 по 2019-09-30. Отсортируйте по дате и времени пар в порядке возрастания.
Задание 4.2.
SELECT 
    DATE_FORMAT(date, '%Y-%m-%d') as date_pair, 
    tmp.start_pair,
    tmp.end_pair,
    subj.name as 'subject',
    sch.classroom,
    CONCAT(T.last_name, ' ', T.first_name, ' ', T.middle_name) as 'teacher'
FROM 
    Schedule sch
    JOIN Subject subj ON sch.subject = subj.id
    JOIN Timepair tmp ON sch.number_pair = tmp.id
    JOIN Teacher T ON T.id = sch.teacher
WHERE date BETWEEN '2019-09-01T00:00:00.000Z' AND '2019-09-03T00:00:00.000Z';


Задание 5: Выведите полный список учителей и студентов с указанием типа (student или teacher).
Задание 5.
SELECT 
    'teacher' as 'school_member',
    T.last_name,  
    T.first_name, 
    T.middle_name,
    S.last_name,
    S.first_name,
    S.middle_name
FROM 
    Teacher T
        RIGHT JOIN
            Student S 
            ON T.last_name = S.last_name
            AND T.first_name = S.first_name
            AND T.middle_name = S.middle_name
UNION ALL
SELECT 
    'student' as 'school_member',
    T.last_name,  
    T.first_name, 
    T.middle_name,
    S.last_name,
    S.first_name,
    S.middle_name
FROM 
    Student S
        LEFT JOIN
            Teacher T
            ON T.last_name = S.last_name
            AND T.first_name = S.first_name
            AND T.middle_name = S.middle_name
WHERE T.last_name IS NULL AND T.first_name IS NULL AND T.middle_name IS NULL;

Задание 6: Посчитайте сколько часов занимают занятия по расписанию. Сгруппируйте результат по предмету и классу. Округлите до одного знака после запятой.
Задание 6.
SELECT 
    C.name AS class_name, 
    Subject.name AS subject, 
    ANY_VALUE(ROUND((CONVERT(TIMESTAMPDIFF(MINUTE, start_pair, end_pair), UNSIGNED)*COUNT(subject)/60), 1)) as pair
FROM 
    Subject
        JOIN 
            Schedule 
                ON Subject.id = Schedule.subject 
        JOIN 
            Class C
                ON Schedule.class = C.id 
        JOIN Timepair 
                ON Schedule.number_pair = Timepair.id
GROUP BY class_name, subject
