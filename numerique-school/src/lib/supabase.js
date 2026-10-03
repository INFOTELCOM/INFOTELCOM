import { createClient } from '@supabase/supabase-js';
const url=import.meta.env.VITE_SUPABASE_URL||'https://gxsemhvyfwizjvoziqct.supabase.co';
const key=import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY||'sb_publishable_lcJ0D_Lh2dxNFqpu8zWk1g_tHT_jG3T';
export const isSupabaseConfigured=Boolean(url&&key);
export const supabase=createClient(url,key);
