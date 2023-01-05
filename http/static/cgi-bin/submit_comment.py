#!/usr/bin/python3

import traceback
print("Content-Type: text/html\n")

try:
	from sys import stdin, path
	from html import escape as html_escape
	from urllib.parse import unquote as url_unquote
	from datetime import datetime
	from os import makedirs, listdir
	from os.path import isdir
	from email_validator import validate_email, EmailNotValidError


	path.append("/home/tc565/python-lib")

	import srcf_tweaked.mail as mail

	now = datetime.now()

	def get_inner_html(): # side effects!

		post_data = {}

		for x in stdin.read().split("&"):
			s = x.split("=")
			if len(s) != 2:
				return '<div style="color: red;">Invalid input (0)</div>'

			post_data[s[0]] = url_unquote(s[1].replace("+", " ")) # why

		if not sorted(post_data.keys()) == ['antispam', 'comment', 'email', 'name', 'post']:
			return '<div style="color: red;">Invalid input (1)</div>'

		if post_data["antispam"] != "lethologica":
			return '<div style="color: red;">Possible spam detected</div>'

		if "." in post_data['post'] or "/" in post_data['post']:
			return '<div style="color: red;">Invalid input (2)</div>'

		blog_dir=f"/public/home/tc565/public_html/tim.clifford.lol/blog/{post_data['post']}"

		blog_comments_dir=f"/home/tc565/blog_comments/{post_data['post']}"

		if not isdir(blog_dir):
			return '<div style="color: red;">Invalid input (3)</div>'

		# now we should be happy {post_data['post']} is safe

		if "\n" in post_data['name'] or "\t" in post_data['name']:
			return '<div style="color: red;">Invalid input (4)</div>'

		if post_data["name"] == "":
			post_data["name"] = "Anonymous"

		if post_data["comment"] == "":
			return '<div style="color: red;">Comment cannot be blank</div>'

		if post_data['email'] != "":
			try:
				v = validate_email(post_data['email'], check_deliverability=False)
				post_data['email'] = v['email']
			except EmailNotValidError:
				return '<div style="color: red;">Invalid input (5)</div>'

		blog_comment_dir=f"{blog_comments_dir}/{now.timestamp()}"

		makedirs(blog_comment_dir)

		open(f"{blog_comment_dir}/post", "w").write(post_data["post"])
		open(f"{blog_comment_dir}/name", "w").write(post_data["name"])
		open(f"{blog_comment_dir}/comment", "w").write(post_data["comment"])

		# now regenerate comments for that post

		comment_html="<hr>"

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

		open(f"{blog_dir}/comments.html", "w").write(comment_html)

		# now email recipients
		try:
			try:
				subscribers = [tuple(x.split("\t")) for x in open(f"{blog_comments_dir}/subscribers.tsv").read().split("\n")[:-1]]
			except FileNotFoundError:
				subscribers = []
			subscribers.append(
				("Tim Clifford", "blog-comments@clifford.lol")
			)

			mail_body=f"""\
{post_data['name']} wrote:

  {post_data['comment']}

--

You can reply by navigating to https://tim.clifford.lol/blog/{post_data['post']}/
Please don't reply to this email."""

			for subscriber in subscribers:
				mail.send_mail(
					subscriber,
					f"Blog | New comment on {post_data['post']}",
					mail_body,
					sender=("Tim's blog", "blog@clifford.lol")
				)
		except:
			return f'<div style="color: red;">Added comment, but failed to email recipients with error:\n{traceback.format_exc()}</div>'

		if post_data['email'] != "":
			open(f"{blog_comments_dir}/subscribers.tsv", "a").write(f"{post_data['name']}\t{post_data['email']}\n")


		return "Successfully added your comment"

	try:
		inner = get_inner_html()
	except:
		inner = f"An internal error occured\n{traceback.format_exc()}"
except:
	inner = f"An internal error occured\n{traceback.format_exc()}"

print(inner)
