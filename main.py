import requests
from bs4 import BeautifulSoup
import subprocess



lent = 0


# Making the function to send notifications via system subprocesses
def notify(solved, unresolved, hits):
    message = f"Arch Packages update:\n{solved} solved\n{unresolved} open\nYou had {hits} hits"
    subprocess.Popen(['notify-send', message])
    return


# Setting the URL to the proper thread
URL = "https://bbs.archlinux.org/viewforum.php?id=44"

# Getting the contents of the page
page = requests.get(URL)
initial = BeautifulSoup(page.content, "lxml")

# Finding the "tbody" (table body) elements
results = initial.find("tbody")

# Converting the results to a string, then parsing them again
links = BeautifulSoup(str(results), "html.parser")
raw = []

# Getting all the hyperlinks
for link in links.find_all('a'):
    raw.append(link.get_text('href'))

# Trimming the first six (these will likely never change, and are the stickied topics)
rawTrimmed = raw[6:]

# Taking out the date hyperlinks and keeping just the topic names
packages = []
while lent < len(rawTrimmed):
    packages.append(rawTrimmed[lent])
    lent += 2

# Figuring out how many of the topics had "[SOLVED]" in the title (might be inaccurate, I saw one with "[solved]"
solvedAmount = 0
for entry in packages:
    if entry.startswith("[SOLVED]"):
        solvedAmount += 1
    else:
        pass
unsolvedAmount = len(packages) - solvedAmount

output = subprocess.check_output("pacman -Qet | awk '{print $1}'", shell=True)
installedPackages = output.decode().splitlines()

# Getting the hit count of packages installed vs packages in the topic
hitCount = 0
for package in installedPackages:
    for issues in packages:
        if package in issues:
            print(f"Package {package} showed up in issue {issues}")
            hitCount += 1

# Sending a desktop notification
notify(solvedAmount, unsolvedAmount, hitCount)
