module main

import net.http
import net.html

const (
	page = http.get_text('https://bbs.archlinux.org/viewforum.php?id=44')
)

fn scrape_links() []string {
	doc := html.parse('$page')

	// Getting all of the <a> tags to retrieve links
	links_tag := doc.get_tag('a')
	mut links := []string{}
	for entry in links_tag {
		links << entry.attributes['href']
	}

	// Trimming the extra links
	links.trim(83)
	links.delete_many(0, 28)

	return links
}

fn scrape_packages() []string {
	doc := html.parse('$page')

	// Getting all of the <td> tags to get the issue titles
	packages_tag := doc.get_tag('td')
	mut titles := []string{}
	for entry in packages_tag {
		tag_array := entry.get_tags('a')
		for tags in tag_array {
			titles << tags.content
		}
	}

	// Trimming the stickied titles
	titles.delete_many(0, 6)

	return titles
}
