import email.mime.text
import smtplib

from email.header import Header
from email.utils import formatdate, make_msgid
from email.utils import formataddr as original_formataddr

# all this is borrowed but tweaked from /usr/lib/python3/dist-packages/srcf/mail/__init__.py

def formataddr(pair):
    name, email = pair
    if name:
        name = Header(name, 'utf-8').encode()
    return original_formataddr((name, email))

def send_mail(recipient, subject, body, sender=('Tim Clifford', 'tc565@srcf.net'), reply_to=None):
    """
    Send `body` to `recipient`, which should be a (name, email) tuple,
    or a list of multiple tuples. Name may be None.
    """

    if isinstance(recipient, tuple):
        recipient = [recipient]

    message = email.mime.text.MIMEText(body, _charset='utf-8')
    message["Message-Id"] = make_msgid("srcf-mailto")
    message["Date"] = formatdate(localtime=True)
    message["From"] = formataddr(sender)
    message["To"] = ", ".join([formataddr(x) for x in recipient])
    message["Subject"] = subject
    if reply_to:
        message["Reply-To"] = formataddr(reply_to)

    all_emails = [x[1] for x in recipient]

    s = smtplib.SMTP('localhost')
    s.sendmail(sender[1], all_emails, message.as_string())
    s.quit()
