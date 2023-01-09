#!/usr/bin/python3

import requests
import re

rss = requests.get("https://dalek.zone/feeds/videos.xml?videoChannelId=18406").text

rss = re.sub("<link>.*?</link>", "<link>https://tim.clifford.lol/music/</link>", rss, count=1, flags=re.DOTALL)
rss = re.sub("<description>.*?</description>", "<description>Tim makes music :]</description>", rss, count=1, flags=re.DOTALL)
rss = re.sub("<image>.*?</image>", "", rss, count=1, flags=re.DOTALL)
rss = re.sub("<copyright>.*?</copyright>", "<copyright>CC BY-SA 4.0</copyright>", rss, flags=re.DOTALL)

print("Content-Type: application/xml; charset=utf-8")
print()
print(rss)
