# ArchScan

This program is written with the intentions of providing information whether a package you have installed
shows up in the "Pacman & Package Upgrade Issues" thread on the Arch Forums. Only the most recent posts are checked! (May change)

## Using

For right now, this only works when you run it, I will eventually implement either a cron instance or systemd support.

Please do not rely on this for production environments, it still has false flags for the comparing parts which still need to be worked on.

## Roadmap

- [x] - Enable notification support
- [x] - Show issues resolved, unresolved, and ones that matched installed packages
- [ ] - Tidying up and splitting the files up as needed
- [ ] - Enable a cron/init task that checks for you
- [ ] - Add a CLI interface that shows more details
- [ ] - Other Package Managers?

## Contact

If you wish to contact me, you can reach me via email [contactme@chrisfore.us](emailto:contactme@chrisfore.us)
or through the Issues tab.