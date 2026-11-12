(function () {
    const store = window.store || {}
    const query = new URLSearchParams(window.location.search).get('query')
    const input = document.getElementById('search-input')
    const title = document.getElementById('search-title')
    const count = document.getElementById('search-count')
    const results = document.getElementById('results')
    const empty = document.getElementById('no-results')
    // Same icons as partials/meta.html
    const ICON_TIME = '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg>'
    const ICON_YIELD = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 11h16a8 8 0 0 1-16 0Z"/><path d="M12 3v4M8 5v2M16 5v2"/></svg>'

    if (!query) {
        input.focus()
        return
    }

    // Retain the query in the form and reflect it in the heading
    input.value = query
    title.textContent = `Results for “${query}”`
    document.title = `${query} · ${document.title}`

    const idx = lunr(function () {
        this.ref('url')
        this.field('title', { boost: 15 })
        this.field('tags', { boost: 15 })
        this.field('summary', { boost: 10 })
        this.field('content', { boost: 10 })
        this.field('time')
        this.field('output')

        for (const url in store) {
            this.add({ url, ...store[url] })
        }
    })

    let matches = []
    try {
        matches = idx.search(query)
    } catch (e) {
        // Lunr throws on malformed query syntax (e.g. a trailing ":"), so fall back to plain terms
        matches = idx.search(query.replace(/[:~^*+\-]/g, ' '))
    }

    count.textContent = `${matches.length} recipe${matches.length === 1 ? '' : 's'}`
    if (!matches.length) {
        empty.hidden = false
        return
    }
    results.replaceChildren(...matches.map(m => createCard(m.ref, store[m.ref])))

    // Builds the same markup as partials/card.html
    function createCard(url, recipe) {
        const card = el('a', 'card')
        card.href = url

        const media = el('div', 'card__media')
        if (recipe.img) {
            const img = el('img')
            Object.assign(img, { src: recipe.img, alt: recipe.title, width: 480, height: 360, loading: 'lazy', decoding: 'async' })
            media.append(img)
        }

        const body = el('div', 'card__body')
        body.append(el('h2', 'card__title', recipe.title))
        if (recipe.summary) body.append(el('p', 'card__summary', recipe.summary))
        const meta = el('ul', 'meta')
        for (const [value, icon, label] of [[recipe.time, ICON_TIME, 'Time: '], [recipe.output, ICON_YIELD, 'Makes: ']]) {
            if (!value) continue
            const li = el('li')
            li.innerHTML = icon
            li.append(el('span', 'sr-only', label), value)
            meta.append(li)
        }
        if (meta.children.length) body.append(meta)

        card.append(media, body)
        return card
    }

    function el(tag, className, text) {
        const node = document.createElement(tag)
        if (className) node.className = className
        if (text) node.textContent = text
        return node
    }
})()
