package com.example.demo.book;

import com.datastax.oss.driver.api.core.cql.SimpleStatement;
import com.datastax.oss.driver.api.querybuilder.QueryBuilder;
import org.springframework.data.cassandra.core.CassandraOperations;
import org.springframework.data.cassandra.core.query.CassandraPageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;

import java.util.List;

import static com.datastax.oss.driver.api.querybuilder.QueryBuilder.literal;

@Service
public class BookService {
    private final BookRepository repository;

    private final CassandraOperations operations;

    public BookService(BookRepository repository, CassandraOperations operations) {
        this.repository = repository;
        this.operations = operations;
    }

    public void addBook(Book book) {
        repository.save(book);
    }

    public List<Book> fetchBooks() {
        return repository.findAll();
    }


    public List<Book> fetchBooks(final Integer size, final Integer page) {
        Pageable pageable = CassandraPageRequest.first(size);
        Slice<Book> books = repository.findAll(pageable);
        if (page != 1) {
            int counter = page;
            while (counter > 0) {
                books = repository.findAll(books.nextOrLastPageable());
                counter--;
            }
        }
        return books.getContent();
    }

    public String findOneTitleByPublisher(String publisher) {
        return operations.selectOne(QueryBuilder.selectFrom("book")
                .column("title")
                .whereColumn("publisher").isEqualTo(literal(publisher))
                .limit(1)
                .allowFiltering()
                .build(), String.class);
    }

    public List<Book> findAllByPublisher(String publisher) {
        return repository.getBookByPublisherEquals(publisher);
/*       return operations.query(Book.class)
                .matching(Query.query(Criteria.where("publisher").is(publisher)).withAllowFiltering())
                .all();*/
    }

    public List<Book> findAllByJDBC(Integer limit) {
        String cqlQuery = "select * from book limit ?";
        SimpleStatement st = SimpleStatement.builder(cqlQuery).addPositionalValues(limit).build();
        return operations.getCqlOperations().query(st, (row, rowNum) -> new Book(row.getUuid("isbn"),
                row.getString("title"),
                row.getString("publisher"),
                row.getSet("tags", String.class)));
    }
    public void truncate() {
        operations.execute(QueryBuilder.truncate("book").build());
    }

}
