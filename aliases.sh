#!/bin/bash

# ====================================================================
# Docker Compose Aliases and Functions
# Streamline your Docker Compose workflow with helpful aliases and 
# flexible dynamic functions.
# ====================================================================

# --------------------------------------------------------------------
# Static Aliases
# These are straightforward shortcuts for common Docker Compose commands.
# --------------------------------------------------------------------
alias dcup="docker-compose up"
alias dcupd="docker-compose up -d"
alias dcdown="docker-compose down"
alias dcb="docker-compose build"
alias dclogs="docker-compose logs"
alias dclogsf="docker-compose logs -f"
alias dcps="docker-compose ps"
alias dcstop="docker-compose stop"
alias dcstart="docker-compose start"
alias dcrestart="docker-compose restart"
alias dcrmi="docker-compose down --rmi all"
alias dcbuild="docker-compose build --no-cache"
alias dcprune="docker-compose down --volumes"
alias dcnetworks="docker network ls"
alias dcimages="docker images"
alias dcremove="docker-compose rm -f"
alias dclist="docker ps -a"
alias dcpurge="docker system prune -af --volumes"
alias dcvolumes="docker volume ls"
alias dcvolumeprune="docker volume prune -f"

# --------------------------------------------------------------------
# Dynamic Aliases (Functions)
# Flexible commands that adapt to user inputs for service-specific
# or parameterized operations.
# --------------------------------------------------------------------

# Scale a specific service to the desired number of containers
dcscale() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: dcscale [service] [count]"
    return 1
  fi
  docker-compose up --scale "$1=$2"
}

# Pull the latest images for specific services
dcpull() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: dcpull [services...]"
    return 1
  fi
  docker-compose pull "$@"
}

# Run a command in a new container for a specific service
dcrun() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: dcrun [service] [command] [args...]"
    return 1
  fi
  local service="$1"
  shift
  docker-compose run "$service" "$@"
}

# Execute a command in a running container for a specific service
dcexec() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: dcexec [service] [command] [args...]"
    return 1
  fi
  local service="$1"
  shift
  docker-compose exec "$service" "$@"
}

# Inspect a container, image, or network
dcinspect() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: dcinspect [target]"
    return 1
  fi
  docker inspect "$1"
}

# Kill specific running containers
dckill() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: dckill [services...]"
    return 1
  fi
  docker-compose kill "$@"
}

# Restart specific services
dcrestart() {
  if [[ $# -eq 0 ]]; then
    docker-compose restart
  else
    docker-compose restart "$@"
  fi
}

# --------------------------------------------------------------------
# Help Command
# Provides an overview of available aliases and functions.
# --------------------------------------------------------------------
dchelp() {
  echo -e "\033[1;34m===============================\033[0m"
  echo -e "\033[1;34m Docker Compose Aliases Help \033[0m"
  echo -e "\033[1;34m===============================\033[0m\n"

  echo -e "\033[1;33mStatic Aliases:\033[0m"
  echo -e "  \033[1;32mdcup\033[0m               - Start all services."
  echo -e "  \033[1;32mdcupd\033[0m              - Start all services in detached mode."
  echo -e "  \033[1;32mdcdown\033[0m             - Stop and remove containers, networks, and volumes."
  echo -e "  \033[1;32mdcb\033[0m                - Build or rebuild services."
  echo -e "  \033[1;32mdclogs\033[0m             - Show logs for all services."
  echo -e "  \033[1;32mdclogsf\033[0m            - Follow logs for all services."
  echo -e "  \033[1;32mdcps\033[0m               - List running containers."
  echo -e "  \033[1;32mdcstop\033[0m             - Stop all services."
  echo -e "  \033[1;32mdcstart\033[0m            - Start stopped services."
  echo -e "  \033[1;32mdcrestart\033[0m          - Restart all services."
  echo -e "  \033[1;32mdcrmi\033[0m              - Remove all images created by docker-compose."
  echo -e "  \033[1;32mdcbuild\033[0m            - Build containers without cache."
  echo -e "  \033[1;32mdcprune\033[0m            - Stop containers and remove volumes."
  echo -e "  \033[1;32mdcnetworks\033[0m         - List Docker networks."
  echo -e "  \033[1;32mdcimages\033[0m           - List Docker images."
  echo -e "  \033[1;32mdcremove\033[0m           - Remove stopped service containers."
  echo -e "  \033[1;32mdclist\033[0m             - List all containers (running and stopped)."
  echo -e "  \033[1;32mdcpurge\033[0m            - Remove unused data, including volumes."
  echo -e "  \033[1;32mdcvolumes\033[0m          - List all Docker volumes."
  echo -e "  \033[1;32mdcvolumeprune\033[0m      - Remove all unused volumes."
  echo -e "\n"

  echo -e "\033[1;33mDynamic Functions:\033[0m"
  echo -e "  \033[1;32mdcscale [service] [count]\033[0m      - Scale a service to [count] containers."
  echo -e "  \033[1;32mdcpull [services...]\033[0m           - Pull the latest images for services."
  echo -e "  \033[1;32mdcrun [service] [command]...\033[0m   - Run a command in a new container."
  echo -e "  \033[1;32mdcexec [service] [command]...\033[0m  - Execute a command in a running container."
  echo -e "  \033[1;32mdcinspect [target]\033[0m             - Inspect a container, image, or network."
  echo -e "  \033[1;32mdckill [services...]\033[0m           - Kill running containers for services."
  echo -e "  \033[1;32mdcrestart [services...]\033[0m        - Restart specific services."
  echo -e "\n"

  echo -e "\033[1;34m===============================\033[0m"
  echo -e "\033[1;34m For more details, refer to the README. \033[0m"
  echo -e "\033[1;34m===============================\033[0m\n"
}

# --------------------------------------------------------------------
# Export Functions for Shell Compatibility
# Export dynamic functions for use in child shell processes.
# --------------------------------------------------------------------
export -f dcscale dcpull dcrun dcexec dcinspect dckill dcrestart dchelp
