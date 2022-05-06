module Articles

export Article

struct Article
    content::String
    links::Vector{String}
    title::String
    image::String
end

end