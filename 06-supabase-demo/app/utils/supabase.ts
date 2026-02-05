import { createClient } from "@supabase/supabase-js";

export function useSupabase() {
  const config = useRuntimeConfig();
  const supabaseUrl = config.public.supabaseUrl;
  const supabaseAnonKey = config.public.supabaseAnonKey;
  return createClient(supabaseUrl, supabaseAnonKey);
}

