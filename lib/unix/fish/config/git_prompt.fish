

function set_fish_git_prompt_options
  #Options
  set -g __fish_git_prompt_show_informative_status
  set -g __fish_git_prompt_showcolorhints
  set -g __fish_git_prompt_showupstream git
  # Colors
  set green (set_color green)
  set magenta (set_color magenta)
  set normal (set_color normal)
  set red (set_color red)
  set yellow (set_color yellow)
  set -g __fish_git_prompt_color_branch magenta --bold
  set -g __fish_git_prompt_color_dirtystate white
  set -g __fish_git_prompt_color_invalidstate red
  set -g __fish_git_prompt_color_merging yellow
  set -g __fish_git_prompt_color_stagedstate yellow
  set -g __fish_git_prompt_color_upstream_ahead green
  set -g __fish_git_prompt_color_upstream_behind red
  # Icons
  set -g __fish_git_prompt_char_cleanstate ' 👍 '
  set -g __fish_git_prompt_char_conflictedstate ' ⚠️ '
  set -g __fish_git_prompt_char_dirtystate ' 💩 '
  set -g __fish_git_prompt_char_invalidstate ' 🤮 '
  set -g __fish_git_prompt_char_stagedstate ' 🚥 '
  set -g __fish_git_prompt_char_stashstate ' 📦 '
  set -g __fish_git_prompt_char_stateseparator ' |'
  set -g __fish_git_prompt_char_untrackedfiles ' 🔍 '
  set -g __fish_git_prompt_char_upstream_ahead ' ☝️ '
  set -g  __fish_git_prompt_char_upstream_behind ' 👇 '
  set -g __fish_git_prompt_char_upstream_diverged ' 🚧 '
  set -g __fish_git_prompt_char_upstream_equal ' 💯 ' 

end 

function fish_status_info --description "send last status info"
  set known_exit_status $argv[1]
  set opening_bracket '['
  set closing_bracket ']'
  set status_ok ✔️
  set status_not_ok 💀
  if test $known_exit_status -eq 0
    printf '%s%s %s' $opening_bracket $status_ok $closing_bracket
  else
    printf '%s%s' $opening_bracket $status_not_ok
    set_color red
    printf ':%s' $known_exit_status
    set_color normal
    printf '%s' $closing_bracket
  end

end

function fish_prompt

  fish_status_info $status

  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s' (__fish_git_prompt)
  printf '>'
  set_color normal
end

set_fish_git_prompt_options