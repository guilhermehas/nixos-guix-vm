# Purpose

This is a repository to make it easier to run NixOS with Guix inside a VM.

# Instructions

## Virtual Machine image

First, it is necessary to create a `cqow2` virtual machine image. For that, run this command:

``` sh
    nix-build -A mkVmImg --out-link --no-out-link | sh
```

## Run the virtual machine

Build the VM with the command:

``` sh
    nix-build -A vm
```

To run the VM:

``` sh
    ./result/bin/run-nixos-vm
```

## SSH

To enter in the VM using ssh:

``` sh
    ssh -p 2222 test@localhost
```

The password will be `test`.
