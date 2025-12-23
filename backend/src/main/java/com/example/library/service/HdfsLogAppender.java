package com.example.library.service;

import com.example.library.entity.BorrowRecord;
import org.springframework.stereotype.Component;

/**
 * Mock implementation of HdfsLogAppender to avoid HDFS dependency in local dev.
 */
@Component
public class HdfsLogAppender {
    public void init() throws Exception {
        // Mock init
    }

    public void appendBorrow(BorrowRecord record) {
        // Mock append
        System.out.println("Mock HDFS log: Borrow record " + record.getId());
    }
}
