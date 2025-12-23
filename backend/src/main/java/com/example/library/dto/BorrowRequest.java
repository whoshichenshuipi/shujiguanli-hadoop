package com.example.library.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class BorrowRequest {
    private Long bookId;
    private Long readerId;
    private LocalDateTime dueTime;
}

