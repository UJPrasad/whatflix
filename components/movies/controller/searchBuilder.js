const searchBuilder = ({ userId, text }) => {
    let searchText;
    let searchQuery = '';
    let searchQueryInputs = { userId };
    searchText = decodeURIComponent(text);
    searchText = searchText.split(',').map(x => `%${x.trim()}%`);
    searchQueryInputs.director = 'director';
    searchQueryInputs.actor = 'actor';
    searchQueryInputs.title = 'title';
    searchQuery += 'or (( ';
    searchQuery += 'director_id in (select director_id from directors where '
    searchText.forEach((x, i) => {
        searchQueryInputs[`directorQ${i}`] = `${x}`;
        searchQuery += ` lower($(director:name)) like lower($(directorQ${i})) and `
    });
    searchQuery += ' 1 = 1 )) or ( actor_id in (select actor_id from actors where ';
    searchText.forEach((x, i) => {
        searchQueryInputs[`actorQ${i}`] = `${x}`;
        searchQuery += ` lower($(actor:name)) like lower($(actorQ${i})) and `;
    });
    searchQuery += ' 1 = 1 )) or ('
    searchText.forEach((x, i) => {
        searchQueryInputs[`titleQ${i}`] = `${x}`;
        searchQuery += `lower($(title:name)) like lower($(titleQ${i})) and `;
    });
    searchQuery += ' 1 = 1))';

    return { options: searchQuery, inputs: searchQueryInputs };
}

module.exports = searchBuilder