<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-2xl mx-auto px-4">
      <!-- Header -->
      <div class="text-center mb-8">
        <h1 class="text-4xl font-bold text-gray-900 mb-2">Todo List</h1>
        <p class="text-gray-600">Stay organized and get things done</p>
      </div>

      <!-- Add Todo Form -->
      <div class="bg-white rounded-lg shadow-md p-6 mb-6">
        <form @submit.prevent="addTodo" class="flex gap-3">
          <input
              v-model="newTodo"
              type="text"
              placeholder="What needs to be done?"
              class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
              required
          />
          <button
              type="submit"
              :disabled="!newTodo.trim() || isLoading"
              class="px-6 py-3 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            <Plus class="w-5 h-5" v-if="!isLoading" />
            <Loader2 class="w-5 h-5 animate-spin" v-else />
          </button>
        </form>
      </div>

      <!-- Filter Tabs -->
      <div class="flex justify-center mb-6">
        <div class="bg-white rounded-lg shadow-sm p-1 flex">
          <button
              v-for="filter in filters"
              :key="filter.key"
              @click="currentFilter = filter.key"
              :class="[
              'px-4 py-2 rounded-md text-sm font-medium transition-colors',
              currentFilter === filter.key
                ? 'bg-emerald-100 text-emerald-700'
                : 'text-gray-500 hover:text-gray-700'
            ]"
          >
            {{ filter.label }}
          </button>
        </div>
      </div>

      <!-- Todo List -->
      <div class="bg-white rounded-lg shadow-md overflow-hidden">
        <div v-if="filteredTodos.length === 0" class="p-8 text-center">
          <CheckCircle class="w-16 h-16 text-gray-300 mx-auto mb-4" />
          <p class="text-gray-500 text-lg">
            {{ currentFilter === 'all' ? 'No todos yet' : `No ${currentFilter} todos` }}
          </p>
          <p class="text-gray-400 text-sm mt-1">
            {{ currentFilter === 'all' ? 'Add one above to get started!' : 'Great job staying organized!' }}
          </p>
        </div>

        <div v-else>
          <div
              v-for="todo in filteredTodos"
              :key="todo.id"
              class="border-b border-gray-100 last:border-b-0 hover:bg-gray-50 transition-colors"
          >
            <div class="p-4 flex items-center gap-4">
              <!-- Checkbox -->
              <button
                  @click="toggleTodo(todo.id)"
                  :class="[
                  'w-6 h-6 rounded-full border-2 flex items-center justify-center transition-colors',
                  todo.completed
                    ? 'bg-emerald-500 border-emerald-500 text-white'
                    : 'border-gray-300 hover:border-emerald-400'
                ]"
              >
                <Check class="w-4 h-4" v-if="todo.completed" />
              </button>

              <!-- Todo Text -->
              <div class="flex-1">
                <p
                    :class="[
                    'text-lg transition-all',
                    todo.completed
                      ? 'text-gray-500 line-through'
                      : 'text-gray-900'
                  ]"
                >
                  {{ todo.text }}
                </p>
                <p class="text-sm text-gray-400 mt-1">
                  {{ formatDate(todo.createdAt) }}
                </p>
              </div>

              <!-- Delete Button -->
              <button
                  @click="deleteTodo(todo.id)"
                  class="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
              >
                <Trash2 class="w-5 h-5" />
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Stats -->
      <div class="mt-6 bg-white rounded-lg shadow-md p-4">
        <div class="flex justify-between items-center text-sm text-gray-600">
          <span>{{ activeTodos.length }} active</span>
          <span>{{ completedTodos.length }} completed</span>
          <span>{{ todos.length }} total</span>
        </div>

        <!-- Progress Bar -->
        <div class="mt-3 bg-gray-200 rounded-full h-2">
          <div
              class="bg-emerald-500 h-2 rounded-full transition-all duration-300"
              :style="{ width: `${completionPercentage}%` }"
          ></div>
        </div>
      </div>

      <!-- Clear Completed Button -->
      <div v-if="completedTodos.length > 0" class="mt-4 text-center">
        <button
            @click="clearCompleted"
            class="px-4 py-2 text-red-600 hover:text-red-700 hover:bg-red-50 rounded-lg transition-colors"
        >
          Clear {{ completedTodos.length }} completed todo{{ completedTodos.length !== 1 ? 's' : '' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Plus, Check, Trash2, CheckCircle, Loader2 } from 'lucide-vue-next'

// Reactive data
const todos = ref([])
const newTodo = ref('')
const currentFilter = ref('all')
const isLoading = ref(false)

// Filter options
const filters = [
  { key: 'all', label: 'All' },
  { key: 'active', label: 'Active' },
  { key: 'completed', label: 'Completed' }
]

// API Base URL
const API_BASE_URL = 'https://website-f-r-webtechnologie-1.onrender.com/api/todos'

// Computed properties
const activeTodos = computed(() => todos.value.filter(todo => !todo.completed))
const completedTodos = computed(() => todos.value.filter(todo => todo.completed))
const filteredTodos = computed(() => {
  switch (currentFilter.value) {
    case 'active':
      return activeTodos.value
    case 'completed':
      return completedTodos.value
    default:
      return todos.value
  }
})
const completionPercentage = computed(() => {
  if (todos.value.length === 0) return 0
  return Math.round((completedTodos.value.length / todos.value.length) * 100)
})

// Date formatter
const formatDate = (date) => {
  const dateObj = typeof date === 'string' ? new Date(date) : date
  return dateObj.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  })
}

// Methods
const fetchTodos = async () => {
  try {
    const response = await fetch(API_BASE_URL)
    if (!response.ok) throw new Error('Failed to fetch todos')
    todos.value = await response.json()
  } catch (error) {
    console.error('Error:', error)
  }
}

const addTodo = async () => {
  if (!newTodo.value.trim()) return
  isLoading.value = true

  try {
    const response = await fetch(API_BASE_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        text: newTodo.value.trim(),
        completed: false
      })
    })
    if (!response.ok) throw new Error('Failed to add todo')
    const data = await response.json()
    todos.value.unshift(data)
    newTodo.value = ''
  } catch (error) {
    console.error('Error:', error)
  } finally {
    isLoading.value = false
  }
}

const toggleTodo = async (id) => {
  try {
    const todo = todos.value.find(t => t.id === id)
    if (!todo) return

    const response = await fetch(`${API_BASE_URL}/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        ...todo,
        completed: !todo.completed
      })
    })
    if (!response.ok) throw new Error('Failed to update todo')
    todo.completed = !todo.completed
  } catch (error) {
    console.error('Error:', error)
  }
}

const deleteTodo = async (id) => {
  try {
    const response = await fetch(`${API_BASE_URL}/${id}`, {
      method: 'DELETE'
    })
    if (!response.ok) throw new Error('Failed to delete todo')
    todos.value = todos.value.filter(todo => todo.id !== id)
  } catch (error) {
    console.error('Error:', error)
  }
}

const clearCompleted = async () => {
  try {
    await Promise.all(
        completedTodos.value.map(todo =>
            fetch(`${API_BASE_URL}/${todo.id}`, {
              method: 'DELETE'
            })
        )
    )
    todos.value = todos.value.filter(todo => !todo.completed)
  } catch (error) {
    console.error('Error clearing completed todos:', error)
  }
}

// Fetch todos on component mount
onMounted(() => {
  fetchTodos()
})
</script>