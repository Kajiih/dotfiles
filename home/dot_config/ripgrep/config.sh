### rg.conf (file location set by RIPGREP_CONFIG_PATH)
# shellcheck disable=all

--max-columns=469
--max-columns-preview
--smart-case
# --column
--no-ignore

--colors=line:fg:cyan
--colors=column:fg:136
--colors=match:fg:182,118,255
--colors=match:style:bold
--colors=path:fg:blue
# --colors=path:style:bold

## types

# web
--type-add
web:*.{html,css,php,phtml,md,js}*

# text
--type-add
text:*.{txt,text,md}*

# ignore

--glob=!.cache/*
--glob=!SteamLibrary/*
--glob=!.steampath/*
--glob=!.steampid/*
--glob=!.wine/*
--glob=!wineprefixes/*
--glob=!Steam/*
--glob=!.steam/*

# maybes

--glob=!.cargo/*
--glob=!.gradle/*
--glob=!.PlayOnLinux/*
