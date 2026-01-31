#!/usr/bin/env bash
set -euo pipefail

REQUIRED_CMDS=(kind kubectl kustomize tilt go)

missing=()
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
done

if [ ${#missing[@]} -eq 0 ]; then
  echo "All prerequisites are installed: ${REQUIRED_CMDS[*]}"
  exit 0
fi

echo "Missing tools: ${missing[*]}"

echo "Select your package manager:"
PS3="Enter choice: "
options=("brew" "apt" "dnf" "yum" "pacman" "cancel")
select opt in "${options[@]}"; do
  case "$opt" in
    brew|apt|dnf|yum|pacman)
      PM="$opt"
      break
      ;;
    cancel)
      echo "Cancelled. Install manually, then re-run."
      exit 1
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
done

if ! command -v "$PM" >/dev/null 2>&1; then
  echo "Package manager '$PM' not found. Install it or choose another." >&2
  exit 1
fi

install_cmds=()
case "$PM" in
  brew)
    install_cmds+=("brew install kind kubernetes-cli kustomize tilt-dev/tap/tilt go")
    ;;
  apt)
    install_cmds+=("sudo apt-get update")
    install_cmds+=("sudo apt-get install -y curl ca-certificates")
    install_cmds+=("sudo apt-get install -y golang")
    install_cmds+=("sudo apt-get install -y kubectl kustomize")
    install_cmds+=("curl -fsSL https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64 -o /tmp/kind && chmod +x /tmp/kind && sudo mv /tmp/kind /usr/local/bin/kind")
    install_cmds+=("curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash")
    ;;
  dnf)
    install_cmds+=("sudo dnf install -y curl ca-certificates")
    install_cmds+=("sudo dnf install -y golang kubectl kustomize")
    install_cmds+=("curl -fsSL https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64 -o /tmp/kind && chmod +x /tmp/kind && sudo mv /tmp/kind /usr/local/bin/kind")
    install_cmds+=("curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash")
    ;;
  yum)
    install_cmds+=("sudo yum install -y curl ca-certificates")
    install_cmds+=("sudo yum install -y golang kubectl kustomize")
    install_cmds+=("curl -fsSL https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64 -o /tmp/kind && chmod +x /tmp/kind && sudo mv /tmp/kind /usr/local/bin/kind")
    install_cmds+=("curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash")
    ;;
  pacman)
    install_cmds+=("sudo pacman -Sy --noconfirm")
    install_cmds+=("sudo pacman -S --noconfirm go kubectl kustomize kind")
    install_cmds+=("curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash")
    ;;
esac

echo "Installing missing tools using $PM..."
for cmd in "${install_cmds[@]}"; do
  echo "> $cmd"
  /bin/sh -c "$cmd"
done

echo "Re-checking prerequisites..."
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Still missing: $cmd" >&2
    exit 1
  fi
done

echo "All prerequisites installed."
