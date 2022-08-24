module main

import os

fn main() {
	packages_issues := packages_array()
	issue_amount := get_issues()

	solved_amount := calculate_solved()
	// Simple math to figure out the amount without '[SOLVED]' in the title
	unsolved_amount := packages_issues.len - solved_amount

	// Sending the notification
	notify(solved_amount, unsolved_amount, issue_amount)
}

fn notify(solved int, unresolved int, hits int) {
	message := 'Arch Packages update:\n$solved solved\n$unresolved open\nYou had $hits hits'
	os.execute('notify-send "ArchScan Alert" "$message"')
}

fn get_installed() []string {
	// Getting the installed packages then putting it into a format suitable for arrays
	raw_packages := os.execute("pacman -Q | awk '{print $1}'").output
	packages := raw_packages.split_into_lines()
	return packages
}

fn create_map() map[string]string {
	packages_issues := packages_array()
	links_issues := links_array()

	// Added the packages/links to a map for easier access
	mut len := 0
	mut package_map := map[string]string{}
	for package in packages_issues {
		package_map[package] = 'https://bbs.archlinux.org/${links_issues[len]}'
		len += 1
	}
	return package_map
}

fn get_issues() int {
	packages_installed := get_installed()
	packages_issues := packages_array()
	package_map := create_map()

	// Getting the amount of issues detected in the installed packages
	mut issue_amount := 0
	for package in packages_installed {
		for issue in packages_issues {
			if issue.contains(package) {
				println('\nPotential issue with \e[0;34m$package \e[0m\nLink: ${package_map[issue]}')
				issue_amount += 1
			}
		}
	}
	return issue_amount
}

fn calculate_solved() int {
	packages_issues := packages_array()
	// Checking to see how many posts have '[SOLVED]' in the title
	mut amount := 0
	for package in packages_issues {
		if package.contains('[SOLVED]') == true {
			amount += 1
		}
	}
	return amount
}
