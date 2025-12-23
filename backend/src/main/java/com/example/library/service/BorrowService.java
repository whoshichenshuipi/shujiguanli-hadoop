package com.example.library.service;

import com.example.library.entity.Book;
import com.example.library.entity.BorrowRecord;
import com.example.library.entity.Reader;
import com.example.library.repository.BookRepository;
import com.example.library.repository.BorrowRecordRepository;
import com.example.library.repository.ReaderRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class BorrowService {
    private final BorrowRecordRepository borrowRecordRepository;
    private final BookRepository bookRepository;
    private final ReaderRepository readerRepository;
    private final HdfsLogAppender hdfsLogAppender;

    public BorrowService(BorrowRecordRepository borrowRecordRepository,
                         BookRepository bookRepository,
                         ReaderRepository readerRepository,
                         HdfsLogAppender hdfsLogAppender) {
        this.borrowRecordRepository = borrowRecordRepository;
        this.bookRepository = bookRepository;
        this.readerRepository = readerRepository;
        this.hdfsLogAppender = hdfsLogAppender;
    }

    @Transactional
    public BorrowRecord borrow(Long bookId, Long readerId, LocalDateTime dueTime) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new IllegalArgumentException("book not found"));
        Reader reader = readerRepository.findById(readerId)
                .orElseThrow(() -> new IllegalArgumentException("reader not found"));

        BorrowRecord record = new BorrowRecord();
        record.setBook(book);
        record.setReader(reader);
        record.setBorrowTime(LocalDateTime.now());
        record.setDueTime(dueTime);
        record.setStatus("borrowed");

        BorrowRecord saved = borrowRecordRepository.save(record);
        hdfsLogAppender.appendBorrow(saved);
        return saved;
    }

    @Transactional
    public BorrowRecord returnBook(Long recordId) {
        BorrowRecord record = borrowRecordRepository.findById(recordId)
                .orElseThrow(() -> new IllegalArgumentException("record not found"));
        record.setReturnTime(LocalDateTime.now());
        record.setStatus("returned");

        BorrowRecord saved = borrowRecordRepository.save(record);
        hdfsLogAppender.appendBorrow(saved);
        return saved;
    }
}

