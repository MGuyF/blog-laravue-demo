<script setup>
defineProps({
  modelValue: String,
  label: String,
  id: String,
  rows: {
    type: Number,
    default: 3,
  },
})

const emit = defineEmits(['update:modelValue'])
</script>

<template>
  <div>
    <label :for="id" class="block text-sm font-medium text-gray-700 mb-1">{{ label }}</label>
    
    <!-- Remplacer v-model par :value + @input -->
    <textarea
      :id="id"
      :value="modelValue"
      @input="emit('update:modelValue', $event.target.value)"
      class="w-full p-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
      :rows="rows"
    ></textarea>
  </div>
</template>
