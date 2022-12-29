package com.example.demo.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "spring.data.cassandra")
public class CassandraProperties {
    private String contactPoints;
    private String username;
    private String password;
    private String keyspaceName;
    private Integer port;
    private String schemaAction;
}
