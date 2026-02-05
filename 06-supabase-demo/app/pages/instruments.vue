<script setup>
// Créer la variable instruments pour stocker les données récupérées
// de la table "instruments"
//
// le mot clé ref est utilisé pour créer une variable vue
// pour  une référence "réactive à une valeur"
const instruments = ref([])

// Créer une fonction asynchrone pour récupérer les données de la table "instruments"
async function getInstruments() {
  // utilise notre objet / conf supabase de utils/supabase.ts
  const supabase = useSupabase();
  const { data } = await supabase.from('instruments').select()
  instruments.value = data
}

// Utiliser le hook onMounted pour appeler la fonction getInstruments
// lorsque le composant est monté
// autrement dit lorsque la page est chargée
onMounted(() => {
  getInstruments()
})
</script>

<template>
  <ul>
    <li v-for="instrument in instruments" :key="instrument.id">{{ instrument.name }}</li>
  </ul>
</template>
