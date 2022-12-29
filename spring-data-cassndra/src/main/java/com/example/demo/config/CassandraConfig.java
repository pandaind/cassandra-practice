package com.example.demo.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.data.cassandra.config.AbstractReactiveCassandraConfiguration;
import org.springframework.data.cassandra.config.SchemaAction;
import org.springframework.data.cassandra.repository.config.EnableCassandraRepositories;

@Profile("!test")
@Configuration
@EnableCassandraRepositories(basePackages = "com.example.demo")
public class CassandraConfig extends AbstractReactiveCassandraConfiguration {

    private final CassandraProperties properties;

    @Autowired
    public CassandraConfig(CassandraProperties properties) {
        this.properties = properties;
    }

    @Override
    protected String getKeyspaceName() {
        return properties.getKeyspaceName();
    }

    @Override
    protected String getContactPoints() {
        return properties.getContactPoints();
    }

    @Override
    protected int getPort() {
        return properties.getPort();
    }

    @Override
    public SchemaAction getSchemaAction() {
        return SchemaAction.CREATE_IF_NOT_EXISTS;
    }

    @Override
    public String[] getEntityBasePackages() {
        return new String[]{"com.example.demo"};
    }

   /* @Bean
    public CassandraOperations cassandraOperations() {
        return new CassandraTemplate(cassandraSession().getObject());
    }*/
}
