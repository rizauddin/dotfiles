#!/usr/bin/env bash
# Minimal, robust scope.sh focused on text previews (no inline images)

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

FILE_PATH="$1"
PV_WIDTH="$2"
PV_HEIGHT="$3"
IMAGE_CACHE_PATH="$4"
PV_IMAGE_ENABLED="$5"

FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_PATH##*.}" | tr '[:upper:]' '[:lower:]')"

HIGHLIGHT_SIZE_MAX=262143
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE=${HIGHLIGHT_STYLE:-pablo}
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE=${PYGMENTIZE_STYLE:-autumn}

handle_extension() {
  case "${FILE_EXTENSION_LOWER}" in
    pdf)
      pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | fmt -w "${PV_WIDTH}" && exit 5
      mutool draw -F txt -i -- "${FILE_PATH}" 1-10 | fmt -w "${PV_WIDTH}" && exit 5
      exiftool "${FILE_PATH}" && exit 5
      exit 1;;
    torrent)
      transmission-show -- "${FILE_PATH}" && exit 5; exit 1;;
    odt|ods|odp|sxw)
      odt2txt "${FILE_PATH}" && exit 5
      pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
      exit 1;;
    xlsx)
      xlsx2csv -- "${FILE_PATH}" && exit 5; exit 1;;
    json)
      jq --color-output . "${FILE_PATH}" && exit 5
      python -m json.tool -- "${FILE_PATH}" && exit 5
      ;;
  esac
}

handle_mime() {
  local mimetype; mimetype="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
  case "${mimetype}" in
    text/*|*/xml)
      # Large files: avoid expensive highlighting
      if [ "$(stat -f '%z' -- "${FILE_PATH}" 2>/dev/null || stat -c '%s' -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]; then
        exit 2
      fi
      if command -v highlight >/dev/null 2>&1; then
        env HIGHLIGHT_OPTIONS="${HIGHLIGHT_OPTIONS}" highlight --out-format=xterm256 --force -- "${FILE_PATH}" && exit 5
      fi
      if command -v bat >/dev/null 2>&1; then
        env COLORTERM=8bit bat --color=always --style=plain -- "${FILE_PATH}" && exit 5
      fi
      if command -v pygmentize >/dev/null 2>&1; then
        pygmentize -f terminal256 -O "style=${PYGMENTIZE_STYLE}" -- "${FILE_PATH}" && exit 5
      fi
      exit 2;;
    image/*)
      # Don’t attempt inline image rendering here; let Ranger handle it (we disabled it).
      exiftool "${FILE_PATH}" && exit 5
      exit 1;;
    video/*|audio/*)
      mediainfo "${FILE_PATH}" && exit 5
      exiftool "${FILE_PATH}" && exit 5
      exit 1;;
  esac
}

# Workflow
handle_extension
handle_mime
# Fallback: brief file(1) summary
echo '----- File Type Classification -----'
file --dereference --brief -- "${FILE_PATH}"
exit 5
