package com.example.demo;

import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.Session;
import com.datastax.oss.driver.api.core.uuid.Uuids;
import com.datastax.oss.driver.shaded.guava.common.collect.ImmutableSet;
import com.example.demo.book.Book;
import com.example.demo.book.BookRepository;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.util.TestPropertyValues;
import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Profile;
import org.springframework.test.context.ContextConfiguration;
import org.testcontainers.containers.CassandraContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@Profile("test")
@SpringBootTest
@Testcontainers
@EnableConfigurationProperties
@ContextConfiguration(initializers = BookIntegrationTest.Initializer.class)
class BookIntegrationTest {

    private static final String KEYSPACE_NAME = "test";

    @Autowired
    private BookRepository repository;

    @Container
    public static final CassandraContainer cassandra = (CassandraContainer) new CassandraContainer("cassandra:3.11.2")
            .withExposedPorts(9042);

    public static class Initializer implements ApplicationContextInitializer<ConfigurableApplicationContext> {
        @Override
        public void initialize(ConfigurableApplicationContext configurableApplicationContext) {
            TestPropertyValues.of(
                    "spring.data.cassandra.keyspace-name=" + KEYSPACE_NAME,
                    "spring.data.cassandra.contact-points=" + cassandra.getContainerIpAddress(),
                    "spring.data.cassandra.port=" + cassandra.getMappedPort(9042)
            ).applyTo(configurableApplicationContext.getEnvironment());

            createKeyspace(cassandra.getCluster());
        }
    }

    private static void createKeyspace(Cluster cluster) {
        try (Session session = cluster.connect()) {
            session.execute("CREATE KEYSPACE IF NOT EXISTS " + KEYSPACE_NAME + " WITH replication = \n" +
                    "{'class':'SimpleStrategy','replication_factor':'1'};");
        }
    }

    @Test
    void givenCassandraContainer_whenSpringContextIsBootstrapped_thenContainerIsRunningWithNoExceptions() {
        assertThat(cassandra.isRunning()).isTrue();
    }

    @Nested
    class BookRepositoryIntegrationTest {

        @Test
        void givenValidPersonRecord_whenSavingIt_thenDataIsPersisted() {
            UUID bookId = Uuids.timeBased();
            Book javaBook = new Book(
                    bookId, "Head First Java", "O'Reilly Media",
                    ImmutableSet.of("Computer", "Software"));
            repository.save(javaBook);

            List<Book> savedBooks = repository.findAll();
            assertThat(savedBooks.get(0)).isEqualTo(javaBook);
        }
    }
}
