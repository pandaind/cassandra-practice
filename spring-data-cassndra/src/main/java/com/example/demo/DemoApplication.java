package com.example.demo;

import com.datastax.oss.driver.api.core.uuid.Uuids;
import com.datastax.oss.driver.shaded.guava.common.collect.ImmutableSet;
import com.example.demo.book.Book;
import com.example.demo.book.BookService;
import com.example.demo.config.CassandraProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

import java.util.List;

@SpringBootApplication
@EnableConfigurationProperties({CassandraProperties.class})
public class DemoApplication implements CommandLineRunner {

	@Autowired
	private BookService bookService;

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {

		String publisher = "O'Reilly Media";

		Book javaBook = new Book(
				Uuids.timeBased(), "Head First Java", publisher,
				ImmutableSet.of("Computer", "Software"));

		bookService.addBook(javaBook);

		List<Book> allBooks = bookService.fetchBooks();
		List<Book> allBooksByPublisher = bookService.findAllByPublisher(publisher);
		String titleByPublisher = bookService.findOneTitleByPublisher(publisher);

		System.out.println(allBooks);
		System.out.println(allBooksByPublisher);
		System.out.println(titleByPublisher);
	}
}
