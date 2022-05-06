module Gameplay

using ..Wikipedia

export
    newgame

function newgame(difficulty::Int)
    articles = [Wikipedia.RANDOM_PAGE_URL]

    for i in 1:difficulty
        article = fetchpage(rand(articles[i-1][:links]))
        push!(articles, articleinfo(article))
    end

    return articles
end

end



