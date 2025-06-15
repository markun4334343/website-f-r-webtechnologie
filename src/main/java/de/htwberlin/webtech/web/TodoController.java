package de.htwberlin.webtech.web;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoController {

    private final List<Todo> todos = new ArrayList<>();

    @GetMapping
    public ResponseEntity<List<Todo>> getAllTodos() {
        return ResponseEntity.ok(todos);
    }

    @PostMapping
    public ResponseEntity<Todo> addTodo(@RequestBody Todo newTodo) {
        todos.add(newTodo);
        return ResponseEntity.ok(newTodo);
    }

    // Add other endpoints (PUT, DELETE) as needed
}

class Todo {
    private Long id;
    private String text;
    private boolean completed;
    // Add getters/setters
}