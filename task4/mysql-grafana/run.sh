#!bin/bash

RED=`tput setaf 1`
GREEN=`tput setaf 2`
BLUE=`tput setaf 4`
RESET=`tput sgr0`
BOLD=`tput bold`
CHECKMARK="\xE2\x9C\x94"

cat << "EOF"

  _____  ____  _   ___     __  __  __        _____  ____  _      
 / ____|/ __ \| \ | \ \   / / |  \/  |      / ____|/ __ \| |     
| (___ | |  | |  \| |\ \_/ /  | \  / |_   _| (___ | |  | | |     
 \___ \| |  | | . ` | \   /   | |\/| | | | |\___ \| |  | | |     
 ____) | |__| | |\  |  | |    | |  | | |_| |____) | |__| | |____ 
|_____/ \____/|_| \_|  |_|    |_|  |_|\__, |_____/ \___\_\______|
                                       __/ |                     
                                      |___/                      
EOF


function main() {
  # Check if software installed. In this case, only helm
  software 

  # Output dry run manifest
  # dry_run -> not going to run this for now... too many words

  # Deploy helm chart
  deploy

  exit 0
}

function software() {
  # Check if helm is installed. If not, exit 0
  software="helm"
  printf "${BLUE}Running environment and software check...\n${RESET}"
  if command -v $software &> /dev/null; then
    printf "${GREEN}$software installed ${CHECKMARK}${RESET}\n"
  else
    echo "${RED}${BOLD}$software could not be found"
    exit 0
  fi
}

function dry_run() {
  # Dry run
  helm install --debug --dry-run mysql-grafana-0.1.0 .
}

function deploy() {
  # Check minikube running
  minikube status
  # If above command return exit status 0, do nothing; 
  # If not, ask user if want to start minikube
  if [ $? -eq 0 ]; then
    echo 'Checking require environment...'
    printf "${GREEN}minikube running... ${CHECKMARK}${RESET}\n"
  else
    read -e -p "minikube not running. You want to run it? (y/n): " -i "y" MINIKUBE_CHOICE
    if [ MINIKUBE_CHOICE = 'y' ]; then
      minikube start
    else
      echo 'byebye!'
      exit 0
    fi
  fi

  # Deploy
  helm install mysql-grafana-0.1.0 .
  echo 'Waiting for service... Grafana will come soon'
  sleep 5
  kubectl rollout status deployment grafana -n grafana && minikube service grafana -n grafana
}


#If no parameter pass into this script, run main function by default
if [[ $# -eq 0 ]]; then main; fi

"$@"