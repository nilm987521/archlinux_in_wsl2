FROM archlinux

# 開啟下載套件的man-page
RUN sed -i 's/NoProgressBar//' /etc/pacman.conf
RUN sed -i '100d' /etc/pacman.conf
RUN sed -i 's/#Color/Color/' /etc/pacman.conf

# 設定wslu
RUN curl -O https://pkg.wslutiliti.es/public.key && pacman-key --add public.key && rm public.key
RUN pacman-key --init && pacman-key --lsign-key 2D4C887EB08424F157151C493DD50AA7E055D853
RUN echo -e "\
[wslutilities]\n\
Server = https://pkg.wslutiliti.es/arch/" | tee -a /etc/pacman.conf
RUN pacman -Syu --noconfirm && pacman -S --noconfirm zsh exa direnv vim man-db man-pages docker docker-buildx docker-compose fcitx5 fcitx5-chewing fcitx5-gtk fcitx5-config-qt glibc tmux sudo jdk8-openjdk jdk17-openjdk nodejs-lts-hydrogen npm btop git zoxide openssh bat net-tools openbsd-netcat maven noto-fonts-cjk wqy-microhei make gcc wslu neovim
RUN systemctl enable docker docker.socket
RUN echo 'en_US.UTF-8 UTF-8' | tee -a /etc/locale.gen && locale-gen
RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' | tee -a /etc/sudoers
RUN echo -e "GTK_IM_MODULE=fcitx\n\
QT_IM_MODULE=fcitx\n\
XMODIFIERS=@im=fcitx\n\
SDL_IM_MODULE=fcitx\n\
GLFW_IM_MODULE=ibus" | tee -a ~/.xprofile

# 比較快的系統資訊顯示
RUN cd ~ && git clone https://github.com/alba4k/albafetch && cd albafetch && make && make install
RUN touch /etc/machine-id
RUN rm -f /.dockerenv

ARG USER="daniel"
RUN usermod -aG docker $USER
# 設定WSL相關參數
RUN echo -e "\
[boot]\n\
systemd = true\n\
command = mount --make-shared /\n\
mountFsTab = true\n\
\n\
[user]\n\
default = $USER\n\
\n\
[network]\n\
hostname = WSL-"$(cat /etc/*release | grep '^NAME=' | awk -F'=' '{print $2}' | tr -d ' ' | sed 's/\"//g')"\n\
generateHosts = false \n\
" | sudo tee /etc/wsl.conf

RUN useradd -m -s /usr/sbin/zsh -G wheel $USER

USER $USER
COPY --chown=$USER:$USER tmux.conf /home/$USER/.tmux.conf
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sed -i 's/robbyrussell/itchy/' ~/.zshrc
RUN sed -i '73s/git/git mvn docker sudo systemd zoxide tmux/' ~/.zshrc
RUN echo 'source $HOME/.userrc' | tee -a ~/.zshrc
COPY --chown=$USER:$USER .userrc /home/$USER/.userrc
COPY --chown=$USER:$USER .vimrc /home/$USER/.vimrc
RUN mkdir -p /home/$USER/.vim/colors && curl -o /home/$USER/.vim/colors/jellybeans.vim https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim
