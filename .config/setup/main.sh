#!/usr/bin/env bash

# TODO figure out how to do this with the bare repo
# OLD WAY: Run this script using with:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aidanhmiles/dotfiles/master/setup/main.sh)"

# Now we for sure have Git
# TODO how to make this idempotent
# Step 2: Clone dotfiles
# https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html
git clone --bare https://github.com/aidanhmiles/dotfiles.git $HOME/.config/.git/


# ansible pre-reqs:
#   xcode CLI utils
#   homebrew
#   python
#   - jmespath (for some modules)
#   ansible

# Step 0: Idiot-check
read -p "Have you read the instructions? (only 'yes' is accepted)" idiotcheck
case $idiotcheck in
  yes ) pass=true; break;;
  * ) pass=false; break;;
esac

[[ $pass != true ]] && echo "Read the instructions first!" && exit 1;

# Step 1: XCODE
echo "checking xcode (xcode-select -p)"

xcode_status="$(xcode-select -p && echo $?)"
if [[ $xcode_status -eq 0 ]]; then
  echo "XCode is fine"
else
  echo "Need to install xcode CLI tools"
  echo "xcode-select --install"
  xcode-select --install
fi


exit 0

cd ~/dotfiles

# Step 3: Homebrew
which brew
brew_status=$?
if [[ ! $brew_status -eq 0 ]]; then
  echo ""
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  echo ""
  echo "Updating Homebrew (brew update)"
  brew update
fi

echo "Installing everything in Brewfile (brew bundle)"
brew bundle --file="~/dotfiles/Brewfile"
# We now have pyenv, updated bash, our favorite shell utils, and more
# TODO do we need to reload the shell here?
# source ~/.bashrc
# etc

# Step 4: Python
echo "pyenv install 3.8.1"
pyenv install 3.8.1
echo "pyenv global 3.8.1"
pyenv global 3.8.1

. ~/dotfiles/setup/link_dotfiles.sh

# need .bash_profile ready
# source .bash_profile

pip install --upgrade pip
echo "pip install --upgrade pip"

# Step 5: Install ansible
which ansible
ansible_status=$?
if [[ ! $ansible_status -eq 0 ]]; then
  echo ""
  echo "pip install ansible"
  pip install ansible
fi

# Step 6: Run ansible
echo "ansible macos_playbook.yml"

ANSIBLE_CFG="./ansible.cfg" \
ansible-playbook \
playbooks/macos_playbook.yml
