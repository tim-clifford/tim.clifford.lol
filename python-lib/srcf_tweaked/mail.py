import email.mime.text
import smtplib
import dkim

from email.utils import formatdate, formataddr, make_msgid

# all this is borrowed but tweaked from /usr/lib/python3/dist-packages/srcf/mail/__init__.py

def send_mail(recipient, subject, body,
              sender=('Tim Clifford', 'tc565@srcf.net'),
              reply_to=None,
              dkim_keyfile="/home/tc565/.config/secrets/dkim/clifford.lol.key",
              dkim_selector="srcf",
              dkim_domain="clifford.lol"):
    """
    Send `body` to `recipient`, which should be a (name, email) tuple,
    or a list of multiple tuples. Name may be None.
    """

    if isinstance(recipient, tuple):
        recipient = [recipient]

    message = email.mime.text.MIMEText(body, _charset='us-ascii')
    message["Message-Id"] = make_msgid("srcf-mailto")
    message["Date"] = formatdate(localtime=True)
    message["From"] = formataddr(sender)
    message["To"] = ", ".join([formataddr(x) for x in recipient])
    message["Subject"] = subject

    if reply_to:
        message["Reply-To"] = formataddr(reply_to)

    all_emails = [x[1] for x in recipient]

    if dkim_domain in sender[1]:
        d = dkim.DKIM(message.as_string().encode(), logger=None,
                      signature_algorithm="rsa-sha256".encode(),
                      linesep=dkim.util.get_linesep(message.as_string().encode()))

        sig = d.sign(dkim_selector.encode(), dkim_domain.encode(), open(dkim_keyfile, "rb").read())

        message_str = sig + message.as_string().encode()
    else:
        message_str = message.as_string().encode()

    s = smtplib.SMTP('localhost')
    s.sendmail(sender[1], all_emails, message_str)
    s.quit()
