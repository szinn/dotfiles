# Virtual Machine Playgrounds

A great test environment (if you have [Parallels](https://www.parallels.com)) is to create a MacVM to try things out in.

It lets you blow it away and start fresh as many times as you want to ensure you have a repeatable environment without destroying your current working environment,

On my network, I configure the machines with specific MAC addresses to pick up DHCP configuration.

## Darwin

For a Darwin VM, create the Apple MacOS VM as you normally would.
Once the VM is created, shut it down, and run

```sh
prlctl set macOS --device-set net0 --type bridged
prlctl set macOS --device-set net0 --mac DECAFF200028
prlctl set macOS --memsize 16384
prlctl set macOS --cpus 4
```

Start the VM up again, install Parallels VMTools (which requires a reboot), enable remote login and ensure Terminal has full disk access. Also can change the machine name to `macvm`.
