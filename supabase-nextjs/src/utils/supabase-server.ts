import {Database} from "@/lib/database.types";
import {createServerComponentSupabaseClient} from "@supabase/auth-helpers-nextjs";
import {RequestCookies} from "next/dist/compiled/@edge-runtime/cookies";

export const createSupabaseServer = () => createServerComponentSupabaseClient<Database>(
    {
        headers: () => new Headers(),
        cookies: () => new RequestCookies(new Headers()),
    }
)
