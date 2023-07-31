function displayResults(results, store) {
    const searchResults = document.getElementById('results')
    if (results.length) {
        let recipes = []
        // Iterate and build result list elements
        for (const n in results) {
            const item = store[results[n].ref]
            recipes.push(item)
        }
        searchResults.replaceWith(createRecipeColumns(recipes))
    } else {
        searchResults.innerHTML = 'No results found.'
    }
}

// Function to create the columns with recipes
function createRecipeColumns(recipes) {
    const columnsContainer = document.createElement("div");
    columnsContainer.classList.add("columns", "is-centered");

    // Create columns
    let columns = []
    for (let i = 0; i <= 3; i++) {
        const column = document.createElement("div");
        column.classList.add("column");
        columnsContainer.appendChild(column);
        columns.push(column);
    }

    // Add recipe to column
    recipes.forEach((recipe, index) => {
        columns[index % 4].innerHTML += createRecipeHTML(recipe);
    });

    return columnsContainer;
}

// Function to generate the HTML code for each recipe
function createRecipeHTML(recipe) {
    return `
    <a class="box" href="${recipe.url}" aria-label="${recipe.title}">
      <div class="is-flex">
        <figure class="image is-48x48" style="margin-right: 0.5em;">
          <img alt="/images/small${recipe.featured_image}" class="is-rounded" src="/images/small${recipe.featured_image}">
        </figure>
        <div>
          <div>${recipe.title}</div>
          <small class="has-text-grey">${recipe.summary}</small>
        </div>
      </div>
      <div style="margin-top: 0.5em;">
        <span class="tag is-primary is-light">${recipe.time}</span>
        ${recipe.tags.map(tag => `<span class="tag">${tag}</span>`).join('\n')}
      </div>
    </a>
  `;
}

// Get the query parameter(s)
const params = new URLSearchParams(window.location.search)
const query = params.get('query')

// Perform a search if there is a query
if (query) {
    // Retain the search input in the form when displaying results
    document.getElementById('search-input').setAttribute('value', query)
    // Set the title element to include the query
    document.getElementById('title').innerHTML = 'Search results for "' + query + '"'

    const idx = lunr(function () {
        this.ref('id')
        this.field('title', {
            boost: 15
        })
        this.field('tags2', {
            boost: 15
        })
        this.field('summary', {
            boost: 10
        })
        this.field('content', {
            boost: 10
        })
        this.field('time')
        this.field('featured_image')

        for (const key in window.store) {
            this.add({
                id: key,
                title: window.store[key].title,
                tags2: window.store[key].tags2,
                summary: window.store[key].summary,
                time: window.store[key].time,
                featuredImage: window.store[key].featured_image,
                content: window.store[key].content
            })
        }
    })

    // Perform the search
    const results = idx.search(query)
    // Update the list with results
    displayResults(results, window.store)
}