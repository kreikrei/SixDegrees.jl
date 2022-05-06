module Gameplay

using ..Wikipedia

export
    newgame

function newgame(difficulty::Int)
    articles = []

    for i in 1:difficulty
        article = begin
            i == 1 ? fetchrandom() : fetchpage(rand(articles[i-1][:links]))
        end
        push!(articles, articleinfo(article))
    end

    return articles
end

end



