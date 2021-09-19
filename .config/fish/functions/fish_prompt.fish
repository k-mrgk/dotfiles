# 区切り文字やアイコン（一目でなにか分かる名前にしておく）
set -l separator_triangle           \ue0b0
set -l icon_cross                   \uf00d
set -l icon_plus                    \uf067  # 追加
set -l icon_three_point_reader      \uf6d7  # 追加
set -l icon_octocat                 \uf113  # 追加

# 区切り文字などを、少し抽象的な名前で登録する
set segment_separator               $separator_triangle         # 追加
set icon_miss                       $icon_cross                 # 追加
set icon_untracked                  $icon_three_point_reader    # 追加
set icon_git_symbol                 $icon_octocat               # 追加
set icon_git_dirty                  $icon_plus                  # 追加

set icon_home                       \uf7db  # 追加
set icon_folder                     \uf07c  # 追加

set gopher                          0xe627


set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch green
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind green

# Status Chars
set __fish_git_prompt_char_untrackedfiles "?"
set __fish_git_prompt_char_upstream_equal ""
set __fish_git_prompt_char_stagedstate "+"
set __fish_git_prompt_char_dirtystate "!"
set __fish_git_prompt_char_stateseparator " "



function kubectl_status
#  [ -z "$KUBECTL_PROMPT_ICON" ]; and set -l KUBECTL_PROMPT_ICON "⎈"
  [ -z "$KUBECTL_PROMPT_ICON" ]; and set -l KUBECTL_PROMPT_ICON " "

  [ -z "$KUBECTL_PROMPT_SEPARATOR" ]; and set -l KUBECTL_PROMPT_SEPARATOR ":"
  set -l config $KUBECONFIG
  [ -z "$config" ]; and set -l config "$HOME/.kube/config"
  if [ ! -f $config ]
    echo (set_color red)$KUBECTL_PROMPT_ICON" "(set_color white)"no config"
    return
  end

  set -l c (kubectl config current-context 2>/dev/null)
  if [ $status -ne 0 ]
    echo (set_color red)$KUBECTL_PROMPT_ICON" "(set_color white)"no context"
    return
  end

  set -l ctx (string split "_" -- $c)


  set -l ns (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$c\")].context.namespace}")
  [ -z $ns ]; and set -l ns 'default'

  if test -n "$ctx[4]"
    echo (set_color cyan)$KUBECTL_PROMPT_ICON" "(set_color brcyan)$ctx[4](set_color white)$KUBECTL_PROMPT_SEPARATOR(set_color brcyan)$ns
  else
    echo (set_color cyan)$KUBECTL_PROMPT_ICON" "(set_color brcyan)$ctx[1](set_color white)$KUBECTL_PROMPT_SEPARATOR(set_color brcyan)$ns
  end
end


function gcp_status
  set -l GCP_PROMPT_SEPARATOR ""

  if test -e "$HOME/.config/gcloud/active_config"
    set gcp_profile (command cat $HOME/.config/gcloud/active_config)
    set gcp_project (command awk '/project/{print $3}' $HOME/.config/gcloud/configurations/config_$gcp_profile)
    #if test -n "$gcp_project"
    echo (set_color brblue)"$GCP_PROMPT_SEPARATOR  $gcp_project"
    #end
  end
end



function fish_prompt
  set exit_status $status
  #set -l time (set_color yellow)(date "+(%H:%M:%S)")
  set -l dir (set_color brmagenta)"[$icon_folder :"(prompt_pwd)"]"

  ## git
  set -l g (__fish_git_prompt "%s")
  if test -n "$g"
    set -l gg (string split " " -- $g)
    set -l ggg $gg[2]
    if test -n "$ggg"
      set git (set_color green)"("$icon_git_symbol" :"$gg[1]":"(set_color red)$ggg(set_color green)")"
    else
      set git (set_color green)"("$icon_git_symbol" :"$gg[1](set_color green)")"
    end
  end

  ## cursor
  if test "$exit_status" -eq 0
    set cursor (set_color yellow)"✘ ╹◡╹✘"(set_color green)" < "
  else
    set cursor (set_color red)"✘ >﹏<✘"(set_color green)" < "
  end

  ## output
  echo $dir $git (gcp_status) (kubectl_status)
  echo $cursor
end
