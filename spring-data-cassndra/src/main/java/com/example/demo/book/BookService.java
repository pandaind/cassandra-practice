package com.example.demo.book;

import com.datastax.oss.driver.api.querybuilder.QueryBuilder;
import org.springframework.data.cassandra.core.CassandraOperations;
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

    public void addBook(Book book){
        repository.save(book);
    }

    public List<Book> fetchBooks(){
        return repository.findAll();
    }

    public String findOneTitleByPublisher(String publisher){
        return operations.selectOne(QueryBuilder.selectFrom("book")
                        .column("title")
                        .whereColumn("publisher").isEqualTo(literal(publisher))
                        .limit(1)
                        .allowFiltering()
                        .build(), String.class);
    }

    public List<Book> findAllByPublisher(String publisher){

        return repository.getBookByPublisherEquals(publisher);
/*       return operations.query(Book.class)
                .matching(Query.query(Criteria.where("publisher").is(publisher)).withAllowFiltering())
                .all();*/
    }
}
