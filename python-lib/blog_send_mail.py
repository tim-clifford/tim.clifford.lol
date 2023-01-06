from sys import path, argv
path.append("/home/tc565/python-lib")

import srcf_tweaked.mail as mail

def send_mail(blog_comment_dir):

	blog_comments_dir = "/".join([x for x in blog_comment_dir.split("/") if x != ""][:-1])

	post_data={}
	post_data['name'] = open(f"{blog_comment_dir}/name").read()
	post_data['comment'] = open(f"{blog_comment_dir}/comment").read()
	post_data['post'] = open(f"{blog_comment_dir}/post").read()

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

if __name__ == "__main__":
	if len(argv) < 2:
		print(f"{argv[0]}: Needs arg")
		exit(1)

	send_mail(argv[1])


