export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json }
  | Json[]

export interface Database {
  public: {
    Tables: {
      todos: {
        Row: {
          content: string | null
          done: boolean | null
          id: number
          inserted_at: string
          title: string | null
          user_id: string
        }
        Insert: {
          content?: string | null
          done?: boolean | null
          id?: number
          inserted_at?: string
          title?: string | null
          user_id: string
        }
        Update: {
          content?: string | null
          done?: boolean | null
          id?: number
          inserted_at?: string
          title?: string | null
          user_id?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

