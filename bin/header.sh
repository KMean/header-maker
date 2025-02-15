#!/bin/bash
# Extended header generator with timestamp, footer, alignment, multiline, and template support

# Default values
TOTAL_WIDTH=74
CUSTOM_PADDING=-1  # -1 means auto-calculate padding
UPPERCASE=false
BORDER_CHAR="-"    # Default border character
ALIGN="center"     # Alignment options: left, center, right
TIMESTAMP=false
FOOTER=""          # Footer text (optional)
TEMPLATE=""        # Template text (optional)

# Flags to indicate next parameter value
NEXT_IS_CHAR=0
NEXT_IS_WIDTH=0
NEXT_IS_PADDING=0
NEXT_IS_FOOTER=0
NEXT_IS_ALIGN=0
NEXT_IS_TEMPLATE=0

# Array to hold one or more title lines
declare -a TITLE_LINES=()

usage() {
  echo "Usage: header [--py | --html | --sql | --js | --c | --java | --sh | --css | --php | --go | --rs | --lua | --sol] [options] <title lines>"
  echo ""
  echo "Options:"
  echo "  --py                 Python header (#)"
  echo "  --sql                SQL header (--)"
  echo "  --html               HTML header (<!-- -->)"
  echo "  --js                 JavaScript header (//)"
  echo "  --c                  C/C++ header (//)"
  echo "  --java               Java header (//)"
  echo "  --sh                 Shell/Bash header (#)"
  echo "  --css                CSS header (/* */)"
  echo "  --php                PHP header (//)"
  echo "  --go                 Go header (//)"
  echo "  --rs                 Rust header (//)"
  echo "  --lua                Lua header (--)"
  echo "  --sol                Solidity header (// or /* */)"
  echo "  --width              Set custom total width (default: 74)"
  echo "  --padding            Set custom padding width (default: auto)"
  echo "  --char               Set custom border character (default: '-')"
  echo "  --align              Set alignment: left, center, or right (default: center)"
  echo "  --timestamp          Insert current timestamp in the border lines"
  echo "  --template           Add a template line (supports shell variables, e.g. \$USER, \$(date))"
  echo "  --footer             Add a footer block below the header"
  echo "  --uppercase or --uc  Convert title (and template/footer) to uppercase"
  echo "  --help or -h         Show this help message"
  exit 0
}

# If no arguments or help flag, display usage.
if [ "$#" -eq 0 ] || [[ "$1" == "--help" || "$1" == "--h" ]]; then
  usage
fi

# Initialize variables for comment style.
COMMENT_CHAR=""
COMMENT_START=""
COMMENT_END=""
LANGUAGE_FLAG=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --py|--sh)
      COMMENT_CHAR="#"
      LANGUAGE_FLAG="$1"
      ;;
    --sql|--lua)
      COMMENT_CHAR="--"
      LANGUAGE_FLAG="$1"
      ;;
    --html)
      COMMENT_START="<!--"
      COMMENT_END="-->"
      LANGUAGE_FLAG="$1"
      ;;
    --js|--c|--java|--php|--go|--rs|--sol)
      COMMENT_CHAR="//"
      LANGUAGE_FLAG="$1"
      ;;
    --css|--sol-block)
      COMMENT_START="/*"
      COMMENT_END="*/"
      LANGUAGE_FLAG="$1"
      ;;
    --width)
      NEXT_IS_WIDTH=1
      ;;
    --padding)
      NEXT_IS_PADDING=1
      ;;
    --char)
      NEXT_IS_CHAR=1
      ;;
    --align)
      NEXT_IS_ALIGN=1
      ;;
    --timestamp)
      TIMESTAMP=true
      ;;
    --template)
      NEXT_IS_TEMPLATE=1
      ;;
    --footer)
      NEXT_IS_FOOTER=1
      ;;
    --uppercase|--uc)
      UPPERCASE=true
      ;;
    *)
      if [ "$NEXT_IS_WIDTH" -eq 1 ]; then
        if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -gt 10 ]; then
          TOTAL_WIDTH="$1"
          NEXT_IS_WIDTH=0
        else
          echo "Error: Invalid width. Must be a number greater than 10."
          exit 1
        fi
      elif [ "$NEXT_IS_PADDING" -eq 1 ]; then
        if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -ge 0 ]; then
          CUSTOM_PADDING="$1"
          NEXT_IS_PADDING=0
        else
          echo "Error: Invalid padding. Must be a non-negative number."
          exit 1
        fi
      elif [ "$NEXT_IS_CHAR" -eq 1 ]; then
        BORDER_CHAR="${1:0:1}"
        NEXT_IS_CHAR=0
      elif [ "$NEXT_IS_ALIGN" -eq 1 ]; then
        case "$1" in
          left|center|right)
            ALIGN="$1"
            ;;
          *)
            echo "Error: Alignment must be one of: left, center, right."
            exit 1
            ;;
        esac
        NEXT_IS_ALIGN=0
      elif [ "$NEXT_IS_TEMPLATE" -eq 1 ]; then
        TEMPLATE="$1"
        NEXT_IS_TEMPLATE=0
      elif [ "$NEXT_IS_FOOTER" -eq 1 ]; then
        FOOTER="$1"
        NEXT_IS_FOOTER=0
      else
        # Accumulate each non-flag argument as a separate title line.
        TITLE_LINES+=( "$1" )
      fi
      ;;
  esac
  shift
done

# If no title lines were provided, show usage.
if [ ${#TITLE_LINES[@]} -eq 0 ]; then
  echo "Error: No title provided."
  usage
fi

# Optionally convert title lines, template, and footer to uppercase.
if $UPPERCASE; then
  for i in "${!TITLE_LINES[@]}"; do
    TITLE_LINES[$i]=$(echo "${TITLE_LINES[$i]}" | tr '[:lower:]' '[:upper:]')
  done
  TEMPLATE=$(echo "$TEMPLATE" | tr '[:lower:]' '[:upper:]')
  FOOTER=$(echo "$FOOTER" | tr '[:lower:]' '[:upper:]')
fi

# Ensure a language flag was selected.
if [ -z "$LANGUAGE_FLAG" ]; then
  echo "Error: You must specify a language flag (e.g., --py, --sql, --sol)."
  usage
fi

# ---------------------------
# Function to create a repeated string of a given character
repeat_char() {
  local count="$1"
  local char="$2"
  printf "%*s" "$count" "" | tr ' ' "$char"
}

# ---------------------------
# Function to print a formatted line for block comment styles.
# It calculates left/right padding based on dash_length (global variable in block section).
print_text_line_block() {
  local text="$1"
  local text_length=${#text}
  local left_spaces=0
  local right_spaces=0
  if [ "$CUSTOM_PADDING" -ge 0 ]; then
    left_spaces="$CUSTOM_PADDING"
    right_spaces=$(( dash_length - text_length - left_spaces ))
    [ "$right_spaces" -lt 0 ] && right_spaces=0
  else
    case "$ALIGN" in
      left)
        left_spaces=0
        right_spaces=$(( dash_length - text_length ))
        ;;
      right)
        left_spaces=$(( dash_length - text_length ))
        right_spaces=0
        ;;
      center)
        left_spaces=$(( (dash_length - text_length) / 2 ))
        right_spaces=$(( dash_length - text_length - left_spaces ))
        ;;
    esac
  fi
  left_pad=$(repeat_char "$left_spaces" " ")
  right_pad=$(repeat_char "$right_spaces" " ")
  printf "%s %s%s%s %s\n" "$COMMENT_START" "$left_pad" "$text" "$right_pad" "$COMMENT_END"
}

# ---------------------------
# Print header for single-line comment markers (e.g. #, //, --)
if [[ "$COMMENT_CHAR" ]]; then
  comment_len=${#COMMENT_CHAR}
  avail_width=$(( TOTAL_WIDTH - 2 * comment_len ))

  # Function to build a border line.
  build_border_line() {
    local bw="$1"  # available width
    if $TIMESTAMP; then
      local ts
      ts=$(date '+%Y-%m-%d %H:%M:%S')
      local ts_length=${#ts}
      # Total space taken by timestamp including one space on each side.
      local ts_total=$(( ts_length + 2 ))
      # Calculate left and right border lengths
      local left_len=$(( (bw - ts_total) / 2 ))
      local right_len=$(( bw - ts_total - left_len ))
      echo "$(repeat_char "$left_len" "$BORDER_CHAR") $ts $(repeat_char "$right_len" "$BORDER_CHAR")"
    else
      echo "$(repeat_char "$bw" "$BORDER_CHAR")"
    fi
  }

  BORDER_LINE=$(build_border_line "$avail_width")

  # Print top border
  echo "${COMMENT_CHAR}${BORDER_LINE}${COMMENT_CHAR}"

  # Function to print a formatted line for single-line comments.
  print_text_line() {
    local text="$1"
    local text_length=${#text}
    local left_spaces=0
    local right_spaces=0
    if [ "$CUSTOM_PADDING" -ge 0 ]; then
      left_spaces="$CUSTOM_PADDING"
      right_spaces=$(( avail_width - text_length - left_spaces ))
      [ "$right_spaces" -lt 0 ] && right_spaces=0
    else
      case "$ALIGN" in
        left)
          left_spaces=1
          right_spaces=$(( avail_width - text_length - left_spaces ))
          ;;
        right)
          left_spaces=$(( avail_width - text_length - 1 ))
          right_spaces=1
          ;;
        center)
          left_spaces=$(( (avail_width - text_length) / 2 ))
          right_spaces=$(( avail_width - text_length - left_spaces ))
          ;;
      esac
    fi
    left_pad=$(repeat_char "$left_spaces" " ")
    right_pad=$(repeat_char "$right_spaces" " ")
    printf "%s%s%s%s%s\n" "${COMMENT_CHAR}" "${left_pad}" "${text}" "${right_pad}" "${COMMENT_CHAR}"
  }

  # Print each title line.
  for line in "${TITLE_LINES[@]}"; do
    print_text_line "$line"
  done

  # If a template is provided, evaluate it and print.
  if [ -n "$TEMPLATE" ]; then
    eval_template=$(eval "echo \"$TEMPLATE\"")
    print_text_line "$eval_template"
  fi

  # Print bottom border (same as top)
  echo "${COMMENT_CHAR}${BORDER_LINE}${COMMENT_CHAR}"

  # If footer text is provided, print a footer block.
  if [ -n "$FOOTER" ]; then
    echo ""  # blank line between header and footer
    footer_border=$(repeat_char "$avail_width" "$BORDER_CHAR")
    echo "${COMMENT_CHAR}${footer_border}${COMMENT_CHAR}"
    print_text_line "$FOOTER"
    echo "${COMMENT_CHAR}${footer_border}${COMMENT_CHAR}"
  fi

# ---------------------------
# For languages using block comments (HTML, CSS, etc.)
elif [[ "$COMMENT_START" && "$COMMENT_END" ]]; then
  dash_length=$(( TOTAL_WIDTH - ${#COMMENT_START} - ${#COMMENT_END} - 2 ))
  DASHES=$(repeat_char "$dash_length" "$BORDER_CHAR")
  echo "$COMMENT_START $DASHES $COMMENT_END"
  
  # Print each title line using the block comment alignment function.
  for line in "${TITLE_LINES[@]}"; do
    print_text_line_block "$line"
  done
  
  if [ -n "$TEMPLATE" ]; then
    eval_template=$(eval "echo \"$TEMPLATE\"")
    print_text_line_block "$eval_template"
  fi
  
  echo "$COMMENT_START $DASHES $COMMENT_END"
  
  if [ -n "$FOOTER" ]; then
    echo ""  # blank line
    echo "$COMMENT_START $DASHES $COMMENT_END"
    print_text_line_block "$FOOTER"
    echo "$COMMENT_START $DASHES $COMMENT_END"
  fi
fi
