#!/usr/bin/env bash
# Test file for GynColors theme - Shell/Bash syntax.
# Comment: should be bright green (#00ff00)

set -euo pipefail

# Variables
NAME="GynColors"
VERSION="2.0.0"
DEBUG=${DEBUG:-false}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Constants (readonly)
readonly CONFIG_FILE="/etc/app/config.yml"
readonly LOG_DIR="/var/log/app"
readonly MAX_RETRIES=5

# Numeric
COUNT=0
HEX_VALUE=0xFF
OCTAL_VALUE=0755
PORT=8080

# Arrays
LANGUAGES=("Python" "JavaScript" "Rust" "Go" "Ruby" "C")
declare -A COLORS=(
    ["comment"]="#00ff00"
    ["keyword"]="#B7B7F7"
    ["string"]="#f0ad6d"
    ["type"]="#ff8bff"
)

# Functions
log() {
    local level="$1"
    shift
    echo "[$(date '+%H:%M:%S')] [$level] $*" >&2
}

die() {
    log "ERROR" "$@"
    exit 1
}

check_dependencies() {
    local deps=("git" "curl" "jq" "sed")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            die "Missing dependency: $dep"
        fi
    done
    log "INFO" "All dependencies found"
}

# String operations
process_string() {
    local input="$1"
    local upper="${input^^}"
    local lower="${input,,}"
    local length=${#input}
    local substring="${input:0:5}"
    local replaced="${input//old/new}"

    echo "Input: $input"
    echo "Upper: $upper, Lower: $lower"
    echo "Length: $length, Sub: $substring"
    echo "Replaced: $replaced"
}

# Heredoc
generate_config() {
    cat <<EOF
{
    "name": "${NAME}",
    "version": "${VERSION}",
    "debug": ${DEBUG},
    "timestamp": "${TIMESTAMP}"
}
EOF
}

# Heredoc with no interpolation
print_usage() {
    cat <<'USAGE'
Usage: test.sh [OPTIONS] [ARGS...]

Options:
    -h, --help      Show this help message
    -v, --verbose   Enable verbose output
    -d, --debug     Enable debug mode
    -n, --dry-run   Run without making changes

Examples:
    test.sh --verbose build
    test.sh -d -n deploy
USAGE
}

# Conditionals
check_file() {
    local file="$1"

    if [[ -f "$file" ]]; then
        echo "File exists: $file"
        if [[ -r "$file" ]]; then
            echo "  Readable: yes"
        fi
        if [[ -w "$file" ]]; then
            echo "  Writable: yes"
        fi
        if [[ -x "$file" ]]; then
            echo "  Executable: yes"
        fi
        echo "  Size: $(stat -f%z "$file" 2>/dev/null || stat -c%s "$file") bytes"
    elif [[ -d "$file" ]]; then
        echo "Directory exists: $file"
    else
        echo "Not found: $file"
        return 1
    fi
}

# Loops
iterate_examples() {
    # For loop with range
    for i in {1..10}; do
        echo "Number: $i"
    done

    # C-style for loop
    for ((i = 0; i < ${#LANGUAGES[@]}; i++)); do
        echo "Language $i: ${LANGUAGES[$i]}"
    done

    # While loop
    local count=0
    while [[ $count -lt $MAX_RETRIES ]]; do
        echo "Attempt: $((count + 1))"
        ((count++))
    done

    # Until loop
    local n=0
    until [[ $n -ge 5 ]]; do
        ((n++))
    done

    # Iterate associative array
    for key in "${!COLORS[@]}"; do
        echo "$key = ${COLORS[$key]}"
    done
}

# Case statement
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                print_usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--debug)
                DEBUG=true
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            --)
                shift
                break
                ;;
            -*)
                die "Unknown option: $1"
                ;;
            *)
                break
                ;;
        esac
    done
}

# Process substitution and pipes
pipeline_example() {
    # Pipe chain
    find . -name "*.sh" -type f |
        xargs grep -l "TODO" |
        sort |
        uniq -c |
        sort -rn |
        head -10

    # Process substitution
    diff <(sort file1.txt) <(sort file2.txt)

    # Command substitution
    local git_branch
    git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
    echo "Branch: $git_branch"
}

# Arithmetic
math_examples() {
    local a=10 b=3
    echo "Add: $((a + b))"
    echo "Sub: $((a - b))"
    echo "Mul: $((a * b))"
    echo "Div: $((a / b))"
    echo "Mod: $((a % b))"
    echo "Pow: $((a ** b))"
    echo "Bit AND: $((a & b))"
    echo "Bit OR: $((a | b))"
    echo "Bit XOR: $((a ^ b))"
}

# Trap and cleanup
cleanup() {
    local exit_code=$?
    log "INFO" "Cleaning up (exit code: $exit_code)"
    rm -f /tmp/app_*.tmp
    exit "$exit_code"
}
trap cleanup EXIT
trap 'die "Interrupted"' INT TERM

# Regex matching
validate_email() {
    local email="$1"
    if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        echo "Valid email: $email"
        return 0
    else
        echo "Invalid email: $email"
        return 1
    fi
}

# Main
main() {
    parse_args "$@"
    check_dependencies

    log "INFO" "Starting $NAME v$VERSION"
    log "INFO" "Script dir: $SCRIPT_DIR"

    process_string "Hello World"
    generate_config > /tmp/app_config.json

    check_file "$0"
    iterate_examples
    math_examples
    validate_email "user@example.com"

    log "INFO" "Done"
}

main "$@"
