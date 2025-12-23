package com.example.library.controller;

import com.example.library.dto.BorrowRequest;
import com.example.library.entity.BorrowRecord;
import com.example.library.repository.BorrowRecordRepository;
import com.example.library.service.BorrowService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/borrow")
public class BorrowController {
    private final BorrowService borrowService;
    private final BorrowRecordRepository borrowRecordRepository;

    public BorrowController(BorrowService borrowService,
                            BorrowRecordRepository borrowRecordRepository) {
        this.borrowService = borrowService;
        this.borrowRecordRepository = borrowRecordRepository;
    }

    @GetMapping
    public List<BorrowRecord> list() {
        return borrowRecordRepository.findAll();
    }

    @PostMapping
    public BorrowRecord borrow(@RequestBody BorrowRequest request) {
        return borrowService.borrow(request.getBookId(), request.getReaderId(), request.getDueTime());
    }

    @PostMapping("/return/{id}")
    public BorrowRecord returnBook(@PathVariable Long id) {
        return borrowService.returnBook(id);
    }
}

