module main

import net.http
import net.html
import os

fn main() {
	page := http.get_text("https://bbs.archlinux.org/viewforum.php?id=44")
	//println("${page}")
	
	doc := html.parse('${page}')
	//println("${doc}")

	links_tag := doc.get_tag('a')
	mut links := []string{}
	for entry in links_tag {
		links << entry.attributes['href']
	}

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
	
	// Trimming the extra links
	links.trim(83)
	links.delete_many(0, 28)

	mut len := 0
	mut packages_issues := []string{}
	for len < titles.len {
		packages_issues << titles[len]
		len += 2
	}

	len = 0
	mut links_issues := []string{}
	for len < links.len {
		links_issues << links[len]
		len += 2
	}

	// println(packages_issues)
	// println(links_issues)

	mut solved_amount := 0
	mut unsolved_amount := 0
	raw_packages := os.execute("pacman -Q | awk '{print $1}'").output
	
	mut packages_installed := raw_packages.split_into_lines()

	len = 0
	mut package_map := map[string]string{}
	for package in packages_issues {
		package_map[package] = 'https://bbs.archlinux.org/${links_issues[len]}'
		len += 1
	}

	mut issues := 0
	len = 0
	for package in packages_installed {
		//len += 1
		for issue in packages_issues {
			if issue.contains(package) {
				println("Potential issue with $package\nLink: ${package_map[issue]}")
				issues += 1
			}
		}
	}
}


fn notify(solved int, unresolved int, hits int) {
	message := 'Arch Packages update:\n${solved} solved\n${unresolved} open\nYou had ${hits} hits'
	os.execute('notify-send "ArchScan Alert" "${message}"')
}