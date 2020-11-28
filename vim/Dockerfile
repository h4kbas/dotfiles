FROM ubuntu:latest

ADD ./.vimrc /root/.config/nvim/init.vim 
ADD ./.vimrc /root/.vimrc
ADD ./aubervim.vim /root/.config/nvim/colors/aubervim.vim

WORKDIR /src

# Do necessary installs
RUN apt-get update && \ 
    apt-get install -y curl git neovim 

# Install vimplug
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# Install everything
RUN nvim +PlugInstall +qall 

ENTRYPOINT nvim .
