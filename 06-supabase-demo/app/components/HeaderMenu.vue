<script setup lang="ts">
const menuItems = computed<NavigationMenuItem[]>(() => [
  {
    label: 'Home',
    to: '/'
  },
  {
    label: 'About',
    to: '/about'
  },
  {
    label: 'Instruments',
    to: '/instruments'
  }
])
</script>

<template>
  <UNavigationMenu :items="menuItems" />
</template>
