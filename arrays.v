module main

fn packages_array() []string {
	titles := scrape_packages()

	// Adding the right packages to check for to an array
	mut len := 0
	mut issues := []string{}
	for len < titles.len {
		issues << titles[len]
		len += 2
	}
	return issues
}

fn links_array() []string {
	links := scrape_links()
	
	// Adding the right links to check for to an array
	mut len := 0
	mut issues := []string{}
	for len < links.len {
		issues << links[len]
		len += 2
	}
	return issues
}