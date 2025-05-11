<template>
  <div>
    <h3>My Items</h3>
    <ul>
      <li v-for="(item, index) in items" :key="index">
        {{ item.name }} - {{ item.description }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'ItemList',
  props: {
    items: {
      type: Array,
      required: true,
      default: () => [
        { name: 'Item 1', description: 'First item' },
        { name: 'Item 2', description: 'Second item' }
      ]
    }
  }
}
</script>