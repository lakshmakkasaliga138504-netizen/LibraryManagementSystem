
package com.library;

import com.library.entity.StudentEntity;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // READ
    public List<Student> getAllStudents() throws SQLException {

        List<Student> students = new ArrayList<>();

        try (Session session = sessionFactory.openSession()) {

            List<StudentEntity> entities = session.createQuery(
                    "FROM StudentEntity ORDER BY studentId",
                    StudentEntity.class
            ).getResultList();

            for (StudentEntity entity : entities) {
                students.add(new Student(
                        entity.getStudentId(),
                        entity.getName(),
                        entity.getEmail(),
                        entity.getPhone()
                ));
            }

        } catch (Exception e) {
            throw new SQLException("Unable to fetch students", e);
        }

        return students;
    }

    // CREATE
    public boolean addStudent(String name, String email, String phone) {

        Session session = sessionFactory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();

            StudentEntity student = new StudentEntity();
            student.setName(name);
            student.setEmail(email);
            student.setPhone(phone);

            session.persist(student);

            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            System.err.println("ADD STUDENT ERROR:");
            e.printStackTrace();

            return false;

        } finally {
            session.close();
        }
    }

    // UPDATE
    public boolean updateStudent(
            int id, String name, String email, String phone) {

        Session session = sessionFactory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();

            StudentEntity student =
                    session.get(StudentEntity.class, id);

            if (student == null) {
                transaction.rollback();
                return false;
            }

            student.setName(name);
            student.setEmail(email);
            student.setPhone(phone);

            transaction.commit();
            return true;

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            System.err.println("UPDATE STUDENT ERROR:");
            e.printStackTrace();

            return false;

        } finally {
            session.close();
        }
    }

    // DELETE
    public boolean deleteStudent(int id) {

        Session session = sessionFactory.openSession();
        Transaction transaction = null;

        try {
            transaction = session.beginTransaction();

            StudentEntity student =
                    session.get(StudentEntity.class, id);

            if (student == null) {
                transaction.rollback();
                return false;
            }

            session.remove(student);

            transaction.commit();
            return true;

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            System.err.println("DELETE STUDENT ERROR:");
            e.printStackTrace();

            return false;

        } finally {
            session.close();
        }
    }
}
