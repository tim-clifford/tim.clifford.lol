<?php
$email = $_POST["email"];
$error = "";
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
	$error.="Invalid email address. If you're trying to hack me I'll be mad 😠";
} else {
	// fix ' to outwit the hackers
	$email = str_replace("'", "'\"'\"'", $email);
	$output = null;
	$retval = null;
	// hardcode paths and stuff for extra security
	exec("echo '".$email."' | /usr/bin/ssh shell.srcf.net /usr/local/bin/srcf-mailman-add tc565-blog >> /home/tc565/logs/web-mailman 2>&1", $output, $retval);
	if ($retval != 0)
		$error = "Failed to add email address. Please email me so I can fix it :) Exit code: ".$retval;
}
?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <title>Email subscription php stuff</title>
  </head>
  <body>
<?php
if (strlen($error) == 0) {
?>
    <span>Successfully subscribed <?php echo $email?></span>
    <p/>
    <p>
      Thanks for the support! You should receive email confirmation. To
      unsubscribe, email tc565-blog-request@srcf.net with subject line
      "unsubscribe"
    </p>
    <p/>
    <p>
      PS: I know this page is ugly, it's a PHP bodge :P
    </p>
<?php
} else {
	echo '<span style="color: red; font-weight: bold;">'.$error.'</span>';
}
?>
  </body>
</html>
