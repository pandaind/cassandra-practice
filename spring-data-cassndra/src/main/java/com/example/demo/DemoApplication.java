package com.example.demo;

import com.datastax.oss.driver.api.core.uuid.Uuids;
import com.datastax.oss.driver.shaded.guava.common.collect.ImmutableSet;
import com.example.demo.book.Book;
import com.example.demo.book.BookService;
import com.example.demo.config.CassandraProperties;
import com.github.javafaker.Faker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

import java.util.List;
import java.util.Locale;

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

		addData(publisher);

		List<Book> allBooks = bookService.fetchBooks();
		System.out.println(allBooks);

		List<Book> firstPage = bookService.fetchBooks(3, 1);
		System.out.println(firstPage);

		List<Book> secondPage = bookService.fetchBooks(3, 2);
		System.out.println(secondPage);

		List<Book> allBooksByPublisher = bookService.findAllByPublisher(publisher);
		System.out.println(allBooksByPublisher);

		String titleByPublisher = bookService.findOneTitleByPublisher(publisher);
		System.out.println(titleByPublisher);


		List<Book> jdbcBooks = bookService.findAllByJDBC(2);
		System.out.println(jdbcBooks);

		bookService.truncate();
	}

	private String addData(String publisher) {
		int dataSize = 100;
		Faker faker = new Faker(new Locale("en-US"));
		for (int i = 0; i < dataSize; i++){
			Book book = new Book(
					Uuids.timeBased(), faker.book().title(), faker.book().publisher(),
					ImmutableSet.of(faker.book().genre(), faker.book().genre()));

			bookService.addBook(book);
		}

		Book javaBook = new Book(
				Uuids.timeBased(), "Head First Java", publisher,
				ImmutableSet.of("Computer", "Software"));
		bookService.addBook(javaBook);
		return publisher;
	}
}
