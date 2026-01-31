#!/bin/zsh
# An oh-my-zsh plugin that provides enhancement to the Node.js version manager `fnm`
# Author: Sukka (https://skk.moe)
# Homepage: https://github.com/SukkaW/zsh-fnm
# License: MIT

function zsh_fnm() {

# detect if fnm is installed
if (( $+commands[fnm] )); then
  # clear fnm per-session folders
  trap "[[ -v FNM_MULTISHELL_PATH && ${#FNM_MULTISHELL_PATH} -gt 0 ]] && rm -rf ${FNM_MULTISHELL_PATH}" EXIT

  # fnm upgrade commands
  function fnm() {
    if [[ $1 == "upgrade" ]]; then
      # Show help if requested
      if [[ $2 == "help" || $2 == "-h" || $2 == "--help" ]]; then
        cat <<'EOF'
Usage:
  fnm upgrade [MAJOR]
  fnm upgrade help
  fnm upgrade [-h|--help]

Upgrade installed Node.js major versions managed by fnm.

If MAJOR is provided, upgrade only specified major (e.g., 24).
If no MAJOR is provided, upgrade all installed majors.

Examples:
  fnm upgrade        # upgrade all installed majors to their latest versions
  fnm upgrade 24     # upgrade v24 to latest
  fnm upgrade help   # show this help
  fnm upgrade --help # show this help

---------------------
zsh-fnm (https://github.com/SukkaW/zsh-fnm), An oh-my-zsh plugin that provides enhancement to the Node.js version manager "fnm".
EOF
        return 0
      fi

      # If no argument provided, collect all installed major versions and upgrade each
      if [[ -z $2 ]]; then
        local -aU majors

        local fnm_ls_output_lines=("${(f)$(command fnm ls)}")
        local pattern_match_version_all="* v*"

        local line=""
        for LINE in "${fnm_ls_output_lines[@]}"; do
          line=${LINE}
          if (( $line[(I)$pattern_match_version_all] )); then
            local ver=${${${line#* v}%% *}%% default}
            local major=${ver%%.*}
            (( ${#major} )) && majors+=${major}
          fi
        done

        if (( ${#majors} == 0 )); then
          echo "[!] No upgradable versions found."
          return 1
        fi

        for major in ${majors[@]}; do
          _sukka_fnm_upgrade_single_major $major
          echo "" # newline between majors
        done

        command fnm use
      else
        _sukka_fnm_upgrade_single_major $2
        command fnm use
      fi
    else
      command fnm "$@"
    fi
  }

  # Local helper to upgrade a single major version (reuses logic)
  function _sukka_fnm_upgrade_single_major() {
    local major="$1"
    echo "[*] Upgrading major: $major"

    local matched_versions=()
    local pattern_match_version="* v$major"
    local pattern_match_system="system"
    local pattern_match_default="default"

    local is_system=0
    local is_default=0

    # Collect installed versions reliably
    local fnm_ls_output_lines=("${(f)$(command fnm ls)}")

    local line=""
    for LINE in "${lines[@]}"; do
      line=${LINE}

      if (( $line[(I)$pattern_match_version] )); then
        local version=${${${line#* v}%% *}%% default}

        echo "[+] Found locally installed version: ${version}"
        matched_versions+=${version}

        if (( $line[(I)$pattern_match_system] )); then
            is_system=1
        fi
        if (( $line[(I)$pattern_match_default] )); then
            is_default=1
        fi
      fi
    done

    if (( ${#matched_versions} == 0 )); then
      echo "[!] No installed versions for major $major found locally, skipping."
      return 1
    fi

    # Get latest remote version for this major (eg: 24 -> 24.13.0)
    local remote_latest_version=""
    local remote_latest_line=""

    read -r remote_latest_line < <(command fnm list-remote --latest --filter="$major" 2>/dev/null)

    if [[ -n $remote_latest_line ]]; then
      remote_latest_version=${${remote_latest_line#v}%% *}
      echo "[+] Latest available remote version for $major: ${remote_latest_version}"
    fi

    # If latest version is already installed, keep it and skip uninstalling/reinstalling it
    local keep_latest=0
    local remaining_versions=()
    if [[ -n $remote_latest_version ]]; then
      for v in ${matched_versions[@]}; do
        if [[ "$v" == "$remote_latest_version" ]]; then
          echo "[*] Latest version $v is already installed, skipping"
          keep_latest=1
        else
          remaining_versions+=${v}
        fi
      done
    else
      remaining_versions=(${matched_versions[@]})
    fi

    for version in ${remaining_versions[@]}; do
      command fnm uninstall $version
    done

    if [[ -z $remote_latest_version ]] || (( ! $keep_latest )); then
      command fnm install "$major"
    else
      echo "[*] Skipping install: latest version $remote_latest_version already installed"
    fi

    local alias_target
    if (( keep_latest )); then
      alias_target=$remote_latest_version
    else
      # Prefer remote latest if available, otherwise fall back to major
      alias_target=${remote_latest_version:-$major}
    fi

    if (( is_system )); then
      echo "[*] Re-alias system version"
      command fnm alias $alias_target system
    fi
    if (( is_default )); then
      echo "[*] Re-alias default version"
      command fnm alias $alias_target default
    fi
  }

fi

}
