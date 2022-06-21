#!/usr/bin/env bash
#
# ps-install.sh - Instalacao de programas pos formatacao.
#
# Autor: Paulo Fernando
# LinkedIn: www.linkedin.com/in/-paulof
#
# ------------------------------------------------------------- #
#
# Descricao:
#  Esse script tem como objetivo automatizar a instalacao de programas pos-formatacao da maquina.
#  
# Testado no Kubuntu 22.04
# Kernel 5.15.0-37-generic
# 
# ------------------------ VARIAVEIS -------------------------- #

LST_SNP=(
    spotify   
)

LST_APT=(
    youtube-dl
    simplescreenrecorder
    qbittorrent
    vlc
    plank
    htop
    vim
    cheese
    telegram-desktop
    gcc 
    make
    perl
)

# OBS: Também existe um arquivo chamado LST_DEB_URL contendo urls para arquivos .deb.

# ------------------------- TESTE ---------------------------- #

[ ! $( which wget) ] && echo "Wget não instalado" && exit 1

# ---------------------- FUNCAO ----------------------------- #

brave-install () {
    
    sudo apt install apt-transport-https curl

    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

    sudo apt update

    sudo apt install brave-browser -y

}

# ---------------------- EXECUCAO ----------------------------- #

sudo apt update 
sudo apt upgrade -y

echo " 
 ----------------------------------- INSTALANDO PROGRAMAS VIA APT ---------------------------------------
"

for program_ap in "${LST_APT[@]}"
do
    if ! which "$program_ap"
        then
            echo "$program_ap não instalado. Aguarde um momento..."
            sudo apt install "$program_ap" -y
        else
            echo "$program_ap já instalado!"
    fi
done 

[ ! "$(dpkg -l brave-browser)" ] && echo "Instalando navegador Brave..." && brave-install 

echo " 
  ----------------------------------- INSTALANDO PROGRAMAS VIA SNAP ---------------------------------------
"

for program_snp in "${LST_SNP[@]}"
do 
   if ! snap list "$program_snp"
        then
            echo "$program_snp não instalado. Aguarde um momento..."
            sudo snap install "$program_snp"
        else 
            echo "$program_snp já instalado!"
    fi
done

echo "
  ----------------------------------- INSTALANDO PROGRAMAS .DEB ---------------------------------------
"

for i in "$(cat LST_DEB_URL)"
do
    echo "$i" | cut -d " " -f 2 | xargs wget
    sudo dpkg -i *.deb
    sudo apt-get install -f 
done

echo " 
   ----------------------------------- FINALIZANDO ---------------------------------------
"

sudo apt autoclean -y && sudo apt autoremove -y

sudo ufw enable 
#Ativacao do firewall nativo do ubuntu. 