import os
import sys

from plexapi.myplex import MyPlexAccount

USERNAME = os.environ.get("PLEX_USERNAME")
PASSWORD = os.environ.get("PLEX_PASSWORD")
PLEX_SERVER_NAME = os.environ.get("PLEX_SERVER_NAME")

account = MyPlexAccount(USERNAME, PASSWORD)
plex = account.resource(PLEX_SERVER_NAME).connect()

library = plex.library.section("<YOUR_PLEX_LIBRARY_NAME>")
video = library.get(title="<YOUR MOVIE TITLE>")

updates = {"addedAt.value": "2018-08-21 11:19:43"}

video.edit(**updates)
