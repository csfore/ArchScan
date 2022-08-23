import requests
from bs4 import BeautifulSoup
import subprocess

URL = "https://bbs.archlinux.org/viewforum.php?id=44"
solvedCounter = 0
lent = 0


# Making the function to send notifications via system subprocesses
def notify(solved, unresolved):
    message = f"Arch Packages update:\n{solved} solved\n{unresolved} open"
    subprocess.Popen(['notify-send', message])
    return


page = requests.get(URL)

initial = BeautifulSoup(page.content, "lxml")

results = initial.find("tbody")

links = BeautifulSoup(str(results), "html.parser")

raw = []

for link in links.find_all('a'):
    raw.append(link.get_text('href'))

rawTrimmed = raw[6:]

packages = []
while lent < len(rawTrimmed):
    packages.append(rawTrimmed[lent])
    lent += 2

for entry in packages:
    if entry.startswith("[SOLVED]"):
        solvedCounter += 1
    else:
        pass

unsolved = len(packages) - solvedCounter

# listPackages = subprocess.Popen(("pacman", "-Qet"), stdout=subprocess.PIPE)
# awkPackages = subprocess.check_output(("awk", "{print $1}"), stdin=listPackages.stdout)
# output = listPackages.communicate()[0]
#
# print(output)

output = subprocess.check_output("pacman -Qet | awk '{print $1}'", shell=True)

#print(output.decode().splitlines())
#notify(solvedCounter, unsolved)

installedPackages = output.decode().splitlines()

arr = ["abc", "a", "123"]

ar = ["pack", "pac", "p"]

# for x in arr:
#     for y in ar:
#         if x in y:
#             print(f"{x}, {y}")

for package in installedPackages:
    for issues in packages:
        if package in issues:
            print(f"Package {package} showed up in issue {issues}")