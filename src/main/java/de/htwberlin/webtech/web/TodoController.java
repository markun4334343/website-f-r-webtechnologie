package de.htwberlin.webtech.web;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@RestController
@RequestMapping("/api/todos")
@CrossOrigin(origins = "*") // Enable CORS
public class TodoController {

    private final List<Todo> todos = new ArrayList<>();
    private final AtomicLong idCounter = new AtomicLong();

    @GetMapping
    public ResponseEntity<List<Todo>> getAllTodos() {
        return ResponseEntity.ok(todos);
    }

    @PostMapping
    public ResponseEntity<Todo> addTodo(@RequestBody Todo newTodo) {
        newTodo.setId(idCounter.incrementAndGet());
        newTodo.setCreatedAt(java.time.LocalDateTime.now());
        todos.add(newTodo);
        return ResponseEntity.ok(newTodo);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Todo> updateTodo(@PathVariable Long id, @RequestBody Todo updatedTodo) {
        return todos.stream()
                .filter(todo -> todo.getId().equals(id))
                .findFirst()
                .map(todo -> {
                    todo.setText(updatedTodo.getText());
                    todo.setCompleted(updatedTodo.isCompleted());
                    return ResponseEntity.ok(todo);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTodo(@PathVariable Long id) {
        todos.removeIf(todo -> todo.getId().equals(id));
        return ResponseEntity.noContent().build();
    }
}

class Todo {
    private Long id;
    private String text;
    private boolean completed;
    private LocalDateTime createdAt;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}