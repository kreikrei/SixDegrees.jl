module Wikipedia

using HTTP
using Gumbo
using Cascadia
using ..Articles
import Cascadia: matchFirst

const PROTOCOL = "https://"
const DOMAIN_NAME = "en.m.wikipedia.org"
const RANDOM_PAGE_URL = "/wiki/Special:Random"

export fetchpage, articleinfo

buildurl(url) = PROTOCOL * DOMAIN_NAME * url

function fetchpage(url=RANDOM_PAGE_URL)
    url = startswith(url, "/") ? buildurl(url) : url
    response = HTTP.get(url)
    response.status == 200 && length(response.body) > 0 ? String(response.body) : ""
end

function extractlinks(elem)
    map(eachmatch(Selector("a[href^='/wiki/']:not(a[href*=':'])"), elem)) do e
        e.attributes["href"]
    end |> unique
end

function extracttitle(elem)
    try
        matchFirst(Selector("#firstHeading"), elem) |> nodeText
    catch
        matchFirst(Selector("title"), elem) |> nodeText
    end
end

function extractimage(elem)
    e = matchFirst(Selector(".content a.image img"), elem)
    isa(e, Nothing) ? "" : e.attributes["src"]
end

function articlelinks(content)
    if !isempty(content)
        dom = parsehtml(content)
        extractlinks(dom.root)
    end
end

function articledom(content)
    if !isempty(content)
        return parsehtml(content)
    end
    error("Article content can't be parsed into DOM")
end

function articleinfo(content)
    dom = articledom(content)

    return Article(
        content,
        extractlinks(dom.root),
        extracttitle(dom.root),
        extractimage(dom.root)
    )
end

end