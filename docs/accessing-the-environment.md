# Accessing the environment

Users have to use the Linux bastion host `irbbastion.eastus.cloudapp.azure.com` to connect to IRB virtual machines in the environment. Users also need to be assigned with `Virtual Machine User Login` role to be able to access the bastion host using SSH. To get access, please [create a new GitHub issue](https://github.dxc.com/ayusmadi/crispy-umbrella/issues/new?assignees=ayusmadi&labels=&template=access-request.md&title=Access+request) or [make a pull request](https://github.dxc.com/ayusmadi/crispy-umbrella/blob/master/roles/assignments.tf).

```
$ ssh irbbastion.eastus.cloudapp.azure.com -l abdul-rahman.yusmadi@dxc.com
This preview capability is not for production use. When you sign in, verify the name of the app on the sign-in screen is "Azure Linux VM Sign-in" and the IP address of the target VM is correct.

To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code AW6R4JPNN to authenticate. Press ENTER when ready.
```

![image](https://github.dxc.com/storage/user/9134/files/2f3bf400-38d1-11ea-8d55-bfd32691fc2e)

![image](https://github.dxc.com/storage/user/9134/files/4c70c280-38d1-11ea-9285-f709a0372071)

![image](https://github.dxc.com/storage/user/9134/files/67dbcd80-38d1-11ea-9f66-807005cb201e)

```
$ ssh irbbastion.eastus.cloudapp.azure.com -l abdul-rahman.yusmadi@dxc.com
This preview capability is not for production use. When you sign in, verify the name of the app on the sign-in screen is "Azure Linux VM Sign-in" and the IP address of the target VM is correct.

To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code AW6R4JPNN to authenticate. Press ENTER when ready.
Last login: Thu Jan 16 16:40:17 2020 from 115.132.38.245
[abdul-rahman.yusmadi@dxc.com@Bastion-vm ~]$
```

### Accessing IRB virtual machines

Once you are logged into the Bastion, you are inside the network and able to connect to any virtual machine.

```
[abdul-rahman.yusmadi@dxc.com@Bastion-vm ~]$ ssh -l irbadmin irbkafka-vm0.irb.test
Last login: Thu Jan 16 18:14:00 2020 from 10.2.1.4
[irbadmin@IRBKafka-vm0 ~]$
```