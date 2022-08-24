module main

fn packages_array() []string {
	titles := scrape_packages()

	// Adding the right packages to check for to an array
	mut len := 0
	mut packages_issues := []string{}
	for len < titles.len {
		packages_issues << titles[len]
		len += 2
	}
	return packages_issues
}

fn links_array() []string {
	links := scrape_links()
	// Adding the right links to check for to an array
	mut len := 0
	mut links_issues := []string{}
	for len < links.len {
		links_issues << links[len]
		len += 2
	}
	return links_issues
}