module Gameplay

using ..Wikipedia

export newgame

function newgame(difficulty::Int)
    articles = []

    for i in 1:difficulty+1
        article = i == 1 ? fetchpage() : articles[i-1].links |> rand |> fetchpage
        push!(articles, articleinfo(article))
    end

    return articles
end

end



