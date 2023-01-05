# Base devel package
sudo pacman -S base-devel

# Python
read -p "[*]Getting python, y/n?" yn
	case $yn in 
		y ) sudo pacman -S python3 python-pip; python3 -m pip install --upgrade pip;;
		* ) echo "Not installed";;
	esac

## Rust
read -p "[*]Getting rust? y/n" yn
	case $yn in 
		y) curl https://sh.rustup.rs -sSf | sh; sudo pacman -S libssl-dev pkg-config clang; export PATH=$PATH:/home/cargo/bin; source $HOME/.cargo/env; rustup component add rustfmt;;
		* ) echo "Not installed";;
	esac
