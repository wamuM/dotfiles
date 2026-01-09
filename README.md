Dotfiles Repository
===================

## Stow vs Bare repo: my usecase 
My previous config used to be managed via a [bare git repo](https://www.atlassian.com/git/tutorials/dotfiles) 
and it was a great experience, I would definitively recommend it. 

But after learning about [Nix](nix)'s [home-manager](hm)
my needs have changed drastically. 

For anyone unfamiliar [home-manager](hm) is a way to manager your user configuration. 
Using it you get a bunch of "super" config files, **all written on the same language**, 
that generate the actual configuration files where you would expect them to be (`~/.config/`, etc.). 

One of it's advantages is that in the same file you are configuring an application you can also state which version
you want installed, so when it generates the actual config it also instals the applications, making for a more 
robust config. 

But here is my problem, some of my configuration in some of my machines really shouldn't have [home-manager](hm),
either because they are not using NixOS, or specially because they are minimal virtual machines.

Which is why I needed a more hybrid approach that would let me do the following:
- Modular opt-in/opt-out config for some applications
- Requires few, minimal dependencies
- Works well with [home-manager](hm)
- Works well without [home-manager](hm) 
- It's not a pain to mantain 

After some research I found that the best way to match those needs was using [stow](https://www.youtube.com/watch?v=y6XCebnB9gs)

## How it works 

## Complementary configuration systems
As I explained before, I have various kinds of machines with different configuration needs. 
They can be grouped into the following categories:
- Bare Linux: These computers only use this repository for configuration 
- [QubesOS](qubes): dom0 uses [my saltstack](https://github.com/wamuM/qubes-salt) config 
  which interally uses this repo for the VMs as if they were bare linux machines.
- [NixOS](nix): they use my [nixos-config repo](https://github.com/nixos-config) which interally uses this repo and
  [home-manager](hm) 
## Dependencies 
For this to work you need to have the following programs installed:
- stow
- bash 
- git

   [hm]: https://github.com/nix-community/home-manager
  [nix]: https://nixos.org/
[qubes]: https://www.qubes-os.org/

