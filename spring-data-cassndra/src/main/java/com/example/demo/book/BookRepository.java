package com.example.demo.book;

import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface BookRepository extends CassandraRepository<Book, UUID> {
    @Query(value = "SELECT * FROM book WHERE publisher = ?0 ALLOW FILTERING")
    List<Book> getBookByPublisherEquals(String publisher);
}
