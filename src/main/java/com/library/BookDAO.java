
package com.library;

import com.library.entity.BookEntity;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    private SessionFactory sessionFactory;

    // Spring injects Hibernate SessionFactory
    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // READ - Get all books
    public List<Book> getAllBooks() throws SQLException {

        List<Book> books = new ArrayList<>();

        try (Session session = sessionFactory.openSession()) {

            List<BookEntity> entities = session.createQuery(
                    "FROM BookEntity ORDER BY bookId",
                    BookEntity.class
            ).getResultList();

            for (BookEntity entity : entities) {

                Book book = new Book(
                        entity.getBookId(),
                        entity.getTitle(),
                        entity.getAuthor(),
                        entity.getCategory(),
                        entity.getQuantity()
                );

                books.add(book);
            }

        } catch (Exception e) {
            throw new SQLException("Unable to fetch books", e);
        }

        return books;
    }

    // CREATE - Add book
    public boolean addBook(String title, String author,
                           String category, int quantity) {

        Transaction transaction = null;

        try (Session session = sessionFactory.openSession()) {

            transaction = session.beginTransaction();

            BookEntity book = new BookEntity();
            book.setTitle(title);
            book.setAuthor(author);
            book.setCategory(category);
            book.setQuantity(quantity);

            session.persist(book);
            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            System.out.println("Add book failed: " + e.getMessage());
            return false;
        }
    }

    // UPDATE - Update book
    public boolean updateBook(int id, String title, String author,
                              String category, int quantity) {

        Transaction transaction = null;

        try (Session session = sessionFactory.openSession()) {

            transaction = session.beginTransaction();

            BookEntity book = session.get(BookEntity.class, id);

            if (book == null) {
                transaction.rollback();
                return false;
            }

            book.setTitle(title);
            book.setAuthor(author);
            book.setCategory(category);
            book.setQuantity(quantity);

            transaction.commit();
            return true;

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            System.out.println("Update book failed: " + e.getMessage());
            return false;
        }
    }

    // DELETE - Delete book
    public boolean deleteBook(int id) {

        Transaction transaction = null;

        try (Session session = sessionFactory.openSession()) {

            transaction = session.beginTransaction();

            BookEntity book = session.get(BookEntity.class, id);

            if (book == null) {
                transaction.rollback();
                return false;
            }

            session.remove(book);
            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            System.out.println("Delete book failed: " + e.getMessage());
            return false;
        }
    }
}
