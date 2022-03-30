# Add variables and functions here. You will be able to use them in .bliz scripts.

# just a little different from Cadence's to match my publishing style
function gemlog_intro_meta_p
    set -l words (bliz_word_count)
    set -l minutes (expr \( $words + 150 \) / 300)
    set -l hits (bliz_hits)
    set -l published $argv[1]
    echo -n "> $words words, about "
    if test $minutes -gt 1
         echo "$minutes minutes to read (300 wpm)."
    else
        echo "a minute to read."
    end
    echo "> First published on $published."
    echo "> This article has been loaded $hits times."
end

function proxy_site
	set -l req_url $argv[1]
	string match -rq -- '^(?:.*://)?(?<req_host>[^/]*)(?:.*)' $req_url
	set response (echo $req_url | ncat --crlf --ssl --no-shutdown $req_host 1965 | string split0)
	echo $response | read code meta

	# check that we got a 2x exit code. Could handle redirects as well but meh
	if string match -rq '^2' $code
		echo "$response" | sed '1d'
	else
		echo "ERROR: Got status code $code from $req_host. Contact the administrator of this site."
	end
end
