from sys import argv
from html import escape as html_escape
from datetime import datetime
from os import listdir
from os.path import isdir

http_blog_upper_dir=f"/public/home/tc565/public_html/tim.clifford.lol/blog"
gem_blog_upper_dir=f"/home/tc565/bliz/serve/blog"
blog_comments_upper_dir=f"/home/tc565/blog_comments"

def http_update(post):

	blog_dir = f"{http_blog_upper_dir}/{post}"
	blog_comments_dir = f"{blog_comments_upper_dir}/{post}"

	if not isdir(blog_dir):
		return

	comment_html="<hr>"

	if isdir(blog_comments_dir):
		for date in sorted(listdir(blog_comments_dir)):

			if not isdir(f"{blog_comments_dir}/{date}"): continue

			name = html_escape(open(f"{blog_comments_dir}/{date}/name").read())
			date_hr = datetime.fromtimestamp(float(date)).isoformat(' ', timespec='seconds')
			comment = html_escape(open(f"{blog_comments_dir}/{date}/comment").read())
			comment_html += f"""
<div class="comment">
	<div class="comment-header">
		<div class="comment-name">
			<h3>{name}</h3>
		</div>
		<div class="comment-date">
			<h4>{date_hr}</h4>
		</div>
	</div>
	<div class="comment-content">
		{comment}
	</div>
</div>
<hr>
"""
	if comment_html == "<hr>":
		comment_html = '<div style="margin-left: 20px; margin-top: 10px;">No comments yet! Tell me what you think!</div>'

	open(f"{blog_dir}/comments.html", "w").write(comment_html)

def gem_update(post):

	blog_dir = f"{gem_blog_upper_dir}/{post}"
	blog_comments_dir = f"{blog_comments_upper_dir}/{post}"

	if not isdir(blog_dir):
		return

	comment_gem="## Comments\n"

	if isdir(blog_comments_dir):
		for date in sorted(listdir(blog_comments_dir)):

			if not isdir(f"{blog_comments_dir}/{date}"): continue

			name = open(f"{blog_comments_dir}/{date}/name").read()
			date_hr = datetime.fromtimestamp(float(date)).isoformat(' ', timespec='seconds')
			comment = open(f"{blog_comments_dir}/{date}/comment").read().replace("\n", "\n> ")
			comment_gem += f"""
{name} at {date_hr}:
> {comment}
"""
	if comment_gem == "## Comments\n":
		comment_gem += '\nNo comments yet! Tell me what you think!'

	open(f"{blog_dir}/comments.gmi", "w").write(comment_gem)

if __name__ == "__main__":

	if len(argv) > 1:
		posts = argv[1:]
	else:
		posts = listdir(http_blog_upper_dir)

	for post in posts:
		http_update(post)
		gem_update(post)

	print("Done")
