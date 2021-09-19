### change gcp project
function gcloud_change_project
  commandline | read -l buffer
  gcloud projects list | fzf --header-lines=1 | awk '{print $1}' | read -l proj
  if test -n $proj
    commandline "gcloud config set project $proj"
    commandline -f execute
  else
    commandline ''
  end
end
