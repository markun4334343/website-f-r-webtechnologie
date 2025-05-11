<template>
  <div id="app">
    <h1>My Webtech App</h1>
    <ItemList :items="dynamicItems" />
  </div>
</template>

<script>
import ItemList from './components/ItemList.vue'

export default {
  name: 'App',
  components: { ItemList },
  data() {
    return {
      dynamicItems: [
        { name: 'Vue', description: 'Frontend Framework' },
        { name: 'Spring Boot', description: 'Backend Framework' }
      ]
    }
  }
}
</script>