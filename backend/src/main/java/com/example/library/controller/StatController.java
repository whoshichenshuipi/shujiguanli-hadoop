package com.example.library.controller;

import com.example.library.entity.StatBookPopular;
import com.example.library.entity.StatReaderBehavior;
import com.example.library.repository.StatBookPopularRepository;
import com.example.library.repository.StatReaderBehaviorRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/stat")
public class StatController {
    private final StatBookPopularRepository statBookPopularRepository;
    private final StatReaderBehaviorRepository statReaderBehaviorRepository;

    public StatController(StatBookPopularRepository statBookPopularRepository,
                          StatReaderBehaviorRepository statReaderBehaviorRepository) {
        this.statBookPopularRepository = statBookPopularRepository;
        this.statReaderBehaviorRepository = statReaderBehaviorRepository;
    }

    @GetMapping("/hot-books")
    public List<StatBookPopular> hotBooks() {
        return statBookPopularRepository.findAll();
    }

    @GetMapping("/reader-behavior")
    public List<StatReaderBehavior> readerBehavior() {
        return statReaderBehaviorRepository.findAll();
    }

    @GetMapping("/borrow-trend")
    public List<Map<String, Object>> borrowTrend() {
        // Return mock trend data for now
        Map<String, Object> data1 = new HashMap<>();
        data1.put("period", "2025-01");
        data1.put("count", 10);
        
        Map<String, Object> data2 = new HashMap<>();
        data2.put("period", "2025-02");
        data2.put("count", 15);
        
        Map<String, Object> data3 = new HashMap<>();
        data3.put("period", "2025-03");
        data3.put("count", 20);
        
        return Arrays.asList(data1, data2, data3);
    }
}

