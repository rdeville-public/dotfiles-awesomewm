#!/bin/sh

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

update_unicode(){
  local version='14.0'
  local url="https://www.unicode.org/Public/emoji/${version}/emoji-test.txt"
  local out="${SCRIPTPATH}/emojis.txt"

  curl --silent --compressed "${url}" | \
    sed -nE 's/^.+fully-qualified\s+#\s(\S+) E[0-9.]+ / \1 /p' |
    sed -e "s/^ //g" > "${out}"
}

update_gitmoji(){
  local url="https://raw.githubusercontent.com/carloscuesta/gitmoji/master/src/data/gitmojis.json"
  local out="${SCRIPTPATH}/gitmoji.txt"
  curl --silent --compressed "${url}" | \
    jq '.gitmojis[] | .emoji + " " + .code + " " + .description ' | \
    sed 's/"//g' | tr '[:upper:]' '[:lower:]' > "${out}"
}

update_nerdfont_glyphs(){
  local url="https://github.com/ryanoasis/nerd-fonts"
  local nerdfont_dir="/tmp/nerdfont/"
  local out="${SCRIPTPATH}/nerdfont.txt"

  if ! [[ -d "${nerdfont_dir}" ]]
  then
    git clone \
      --depth 1 \
      --filter=blob:none \
      --sparse \
      "${url}" "${nerdfont_dir}"
  fi
  cd "${nerdfont_dir}"
  git sparse-checkout set "bin/scripts/lib/"

  # Iterate through relevant files in nerd-fonts
  echo "" > "${out}"
  for i in ${nerdfont_dir}/bin/scripts/lib/i_{dev,fae,fa,iec,linux,oct,ple,pom,seti,material,weather}.sh
  do
    # Transform to <unicodeChar,name_with_underscores>
    sed -n -r "s/^\s*i='(.*)'\s*i_(.*)=.*/\1,\2/p" $i |
    while IFS=',' read -r -a line;
    do
      # Get character code and space delimit the name
      echo -e "${line[0]} nf ${line[1]//_/ }" >> "${out}"
    done
  done
}


main(){
  echo "Updating Unicode"
  update_unicode
  echo "Updating Gitmoji"
  update_gitmoji
  echo "Updating Nerdfont Glyphs"
  update_nerdfont_glyphs
}

main "$@"

