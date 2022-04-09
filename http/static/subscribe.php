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
<html lang="en">
  <head>
    <title>Email subscription</title>
    <link rel="icon" type="image/png" href="/avatar_48.png"/>
    <meta charSet="utf-8"/>
    <meta content="width=device-width, initial-scale=1" name="viewport"/>
    <link rel="stylesheet" href="/main.css"/>
  </head>
  <body>
    <div class="${COLOR}">
      <div class="Topbar_div">
        <nav class="Topbar_nav">
          <a class="topbar-title" href="/">
            <img class="topbar-img" src="/avatar_128.png"/>
          </a>
          <ul>
            <li><a href="/about/">About</a></li>
            <li><a href="/dracula/">Dracula</a></li>
            <li><a href="/blog/">Blog</a></li>
            <li>
              <a href="/blog/"
                 class="Topbar_bigbutton">SourceHut
              </a>
            </li>
          </ul>
        </nav>
      </div>
      <div class="single">
        <div class="wrap"><div class="page">
          <p/>
          <p/>
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
<?php
} else {
	echo '<span style="color: #ff5555; font-weight: bold;">'.$error.'</span>';
	http_response_code(400);
}
?>
        </div></div>
      </div>
      <div style="background:#20222b;padding:60px 0">
        <p class="credits">
          The design is from
          <a class="cyan" href="https://draculatheme.com" target="blank">
            draculatheme.com
          </a>,
          <br/>
          made with <span class="love">♥</span> by
          <a class="green" href="https://zenorocha.com" target="blank">
            Zeno Rocha
          </a>
          <br/>
            under
          <a class="orange" href="http://zenorocha.mit-license.org/" target="blank">
            MIT license
          </a>
        </p>
      </div>
    </div>
  </body>
</html>
