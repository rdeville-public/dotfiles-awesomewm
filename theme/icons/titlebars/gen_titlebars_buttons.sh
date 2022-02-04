#!/usr/bin/env bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source "${SCRIPTPATH}/colors.sh"

main()
{
  declare -A icons
  icons[floating]=""
  icons[sticky]=""
  icons[ontop]="ﱓ"
  icons[minimize]=""
  icons[maximized]=""
  icons[close]=""

  declare -A clr
  clr[floating]="${colors[cyan_500]}"
  clr[sticky]="${colors[blue_500]}"
  clr[ontop]="${colors[purple_500]}"
  clr[minimize]="${colors[yellow_500]}"
  clr[maximized]="${colors[green_500]}"
  clr[close]="${colors[red_500]}"

  declare -A icon_cfg
  icon_cfg[circle_fill]=""
  icon_cfg[circle_fill_opacity]=""
  icon_cfg[circle_stroke]=""
  icon_cfg[circle_stroke_opacity]=""
  icon_cfg[text_fill]=""
  icon_cfg[text_fill_opacity]=""
  icon_cfg[text_stroke]=""
  icon_cfg[text_stroke_opacity]=""

  local dark=${colors[grey_700]}
  local darker=${colors[grey_800]}
  local darkest=${colors[grey_900]}

  local light=${colors[grey_300]}
  local lighter=${colors[grey_200]}
  local lightest=${colors[grey_100]}

  local sed_cmd=""

  local clr_icon=""
  local output_filename=""

  for idx_icon in "${!icons[@]}"
  do
    clr_icon=${clr[$idx_icon]}
    for i_mode in "normal" "focus"
    do
      echo "titlebar_${idx_icon}_button_${i_mode}_${i_state}"
      case ${i_mode} in
        normal)
          icon_cfg[circle_fill_opacity]="0.5"
          icon_cfg[circle_stroke_opacity]="0.25"
          icon_cfg[text_fill_opacity]="0.5"
          icon_cfg[text_stroke_opacity]="0.25"
          ;;
        focus)
          icon_cfg[circle_fill_opacity]="1"
          icon_cfg[circle_stroke_opacity]="0.5"
          icon_cfg[text_fill_opacity]="0.5"
          icon_cfg[text_stroke_opacity]="0.25"
          ;;
      esac

      for i_state in "active" "inactive"
      do
        case ${i_state} in
          active)
            icon_cfg[circle_fill]="${clr_icon}"
            icon_cfg[circle_stroke]="${clr_icon}"
            icon_cfg[text_fill]="${lightest}"
            icon_cfg[text_stroke]="${dark}"
            ;;
          inactive)
            icon_cfg[circle_fill]="${darker}"
            icon_cfg[circle_stroke]="${darkest}"
            icon_cfg[text_fill]="${lightest}"
            icon_cfg[text_stroke]="${lighter}"
            ;;
        esac

        output_filename="${idx_icon}_${i_state}_${i_mode}.svg"

        local idx_cfg_maj
        sed \
          -e "s|TPL:CIRCLE_FILL_OPACITY|${icon_cfg[circle_fill_opacity]}|g" \
          -e "s|TPL:CIRCLE_STROKE_OPACITY|${icon_cfg[circle_stroke_opacity]}|g" \
          -e "s|TPL:TEXT_FILL_OPACITY|${icon_cfg[text_fill_opacity]}|g" \
          -e "s|TPL:TEXT_STROKE_OPACITY|${icon_cfg[text_stroke_opacity]}|g" \
          -e "s|TPL:CIRCLE_FILL|${icon_cfg[circle_fill]}|g" \
          -e "s|TPL:CIRCLE_STROKE|${icon_cfg[circle_stroke]}|g" \
          -e "s|TPL:TEXT_FILL|${icon_cfg[text_fill]}|g" \
          -e "s|TPL:TEXT_STROKE|${icon_cfg[text_stroke]}|g" \
          -e "s|TPL:TEXT_CONTENT|${icons[$idx_icon]}|g" \
          "${SCRIPTPATH}/template.svg" > "${SCRIPTPATH}/${output_filename}"

      done
    done
  done
}

main "$@"
