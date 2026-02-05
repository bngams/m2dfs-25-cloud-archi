<script setup>
const user = ref(null)
const avatarUrl = ref('')

onMounted(() => {
  const supabase = useSupabase()
  supabase.auth.getSession().then(({ data: { session } }) => {
    user.value = session?.user || null
    loadAvatar()
  })
})

const loadAvatar = () => {
  const supabase = useSupabase()
  if (user.value) {
    const { data } = supabase.storage.from('avatars').getPublicUrl(user.value.id)
    avatarUrl.value = data.publicUrl
  }
}

const uploadAvatar = (file) => {
  const supabase = useSupabase()
  if (user.value && file) {
    supabase.storage.from('avatars').upload(user.value.id, file, { upsert: true }).then(({ data, error }) => {
      if (error) {
        console.error('Error uploading avatar:', error)
      } else {
        console.log('Avatar uploaded:', data)
        loadAvatar() // Refresh the avatar after upload
      }
    })
  }
}
</script>

<template>
  <div v-if="user" class="flex flex-col items-center gap-4 p-4">
    <UUser
      :name="user?.email || ''"
      :description="user?.id || ''"
      orientation="vertical"
      :avatar="{
        src: avatarUrl,
        alt: 'User Avatar'
      }"
      size="xl"
    />

    <UFileUpload
      accept="image/*"
      variant="button"
      label="Change avatar"
      @update:model-value="uploadAvatar"
    />
  </div>
  <div v-else class="flex flex-col items-center gap-4 p-4">
    <p>You are not logged in. Please log in to view your profile.</p>
    <UButton
      to="/login"
      variant="outline"
      color="primary"
    />
  </div>
</template>
