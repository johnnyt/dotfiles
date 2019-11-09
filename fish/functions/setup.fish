## Defines abbreviations
function setup
    for abbreviation in (abbr -l)
        abbr -e $abbreviation
    end

    abbr gma git checkout master
    abbr gco git checkout
    abbr gst git status
    abbr gba git branch -a

    abbr g git
    abbr gf git fetch
    abbr gs git status
    abbr gc git commit -m
    abbr gm git pull --ff-only
    abbr ga git add
    abbr gp git push
    abbr gd git diff
    abbr l ls -lah
    abbr bs brew services

    abbr bx bundle exec
    fisher
end
