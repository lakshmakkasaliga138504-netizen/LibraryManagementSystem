package com.library;

import com.library.entity.IssueEntity;
import com.library.entity.BookEntity;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import jakarta.persistence.LockModeType;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class IssueDAO {

    private SessionFactory sessionFactory;

    // Spring injects Hibernate SessionFactory
    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // READ - Get all issues
    public List<Issue> getAllIssues() throws SQLException {

        List<Issue> issues = new ArrayList<>();

        try (Session session = sessionFactory.openSession()) {

            List<IssueEntity> entities = session.createQuery(
                    "FROM IssueEntity ORDER BY issueId DESC",
                    IssueEntity.class
            ).getResultList();

            for (IssueEntity entity : entities) {

                Issue issue = new Issue(
                        entity.getIssueId(),
                        entity.getStudentId(),
                        entity.getBookId(),
                        entity.getIssueDate() == null ? null :
                            java.sql.Date.valueOf(entity.getIssueDate()),
                        entity.getReturnDate() == null ? null :
                            java.sql.Date.valueOf(entity.getReturnDate())
                );

                issues.add(issue);
            }

        } catch (Exception e) {
            throw new SQLException("Unable to fetch issues", e);
        }

        return issues;
    }

    // CREATE - Issue a book
    public boolean addIssue(int studentId, int bookId,
                            java.sql.Date issueDate,
                            java.sql.Date returnDate) {

        Transaction transaction = null;

        try (Session session = sessionFactory.openSession()) {

            transaction = session.beginTransaction();

            IssueEntity issue = new IssueEntity();

            issue.setStudentId(studentId);
            issue.setBookId(bookId);

            issue.setIssueDate(
                    issueDate == null ? null : issueDate.toLocalDate()
            );

            issue.setReturnDate(
                    returnDate == null ? null : returnDate.toLocalDate()
            );

            session.persist(issue);

            transaction.commit();
            return true;

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            System.out.println("Add issue failed: " + e.getMessage());
            return false;
        }
    }

    // UPDATE - Return a book
    public boolean returnBook(int issueId) {

        Transaction transaction = null;

        try (Session session = sessionFactory.openSession()) {

            transaction = session.beginTransaction();

            IssueEntity issue = session.find(
                    IssueEntity.class,
                    issueId,
                   LockModeType.PESSIMISTIC_WRITE
            );

            if (issue == null || issue.getReturnDate() != null) {
                transaction.rollback();
                return false;
            }

          BookEntity book = session.find(
        BookEntity.class,
        issue.getBookId(),
        LockModeType.PESSIMISTIC_WRITE
);
            

            if (book == null) {
                transaction.rollback();
                return false;
            }

            // Update return date
            issue.setReturnDate(LocalDate.now());

            // Increase available book quantity
            book.setQuantity(book.getQuantity() + 1);

            transaction.commit();
            return true;

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            System.out.println("Return book failed: " + e.getMessage());
            return false;
        }
    }
}
