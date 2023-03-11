import React from "react";

import {Todo} from "@/lib/Todo";
import {createSupabaseServer} from "@/utils/supabase-server";


type HomeProps = {
    todos: Todo[]
}

export async function getServerSideProps() {
    const supabaseServer = createSupabaseServer();
    const {data} = await supabaseServer.from("todos").select("*");
    return {
        props: {todos: data},
    }
}

const Home = ({todos}: HomeProps) => {
    return (
        <div className="container" style={{padding: '50px 0 100px 0'}}>
            <div>
                {todos?.map(item =>
                    <li key={item.id}>Title: {item.title} Content: {item.content} Done: {item.done ? 'true' : 'false'}</li>
                )}
            </div>
        </div>
    )
}

export default Home
