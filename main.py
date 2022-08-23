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

notify(solvedCounter, unsolved)
