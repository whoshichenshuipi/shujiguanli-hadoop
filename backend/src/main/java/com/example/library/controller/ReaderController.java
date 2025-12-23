package com.example.library.controller;

import com.example.library.entity.Reader;
import com.example.library.service.ReaderService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/readers")
public class ReaderController {
    private final ReaderService readerService;

    public ReaderController(ReaderService readerService) {
        this.readerService = readerService;
    }

    @GetMapping
    public List<Reader> list() {
        return readerService.findAll();
    }

    @PostMapping
    public Reader create(@RequestBody Reader reader) {
        return readerService.save(reader);
    }

    @PutMapping("/{id}")
    public Reader update(@PathVariable Long id, @RequestBody Reader reader) {
        reader.setId(id);
        return readerService.save(reader);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        readerService.delete(id);
    }
}

