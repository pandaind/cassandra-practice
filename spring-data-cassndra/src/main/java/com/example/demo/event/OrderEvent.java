package com.example.demo.event;

import lombok.Data;
import org.springframework.data.cassandra.core.mapping.Column;
import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;

@Data
@Table(value = "order_event")
public class OrderEvent {
    @PrimaryKey
    private OrderEventKey key;

    @Column(value = "event_code")
    private int eventCode;

    @Column(value = "shipping_address")
    private String shippingAddress;
}
