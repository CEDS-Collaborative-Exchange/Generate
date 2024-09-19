---
icon: square-plus
---

# Optional Installations

### Optional Installations <a href="#toc109377194" id="toc109377194"></a>

### Active Directory Lightweight Directory Services (AD LDS) <a href="#active_directory_lightweight_directory_s" id="active_directory_lightweight_directory_s"></a>

For those environments where Active Directory does not exist, Active Directory Lightweight Directory Services (AD LDS) can be used.

To install Active Directory Lightweight directory services (AD LDS) on a machine with Windows Server 2008 or higher, please use the following steps.

1. Click **Start**, and then click **Server Manager**.
2. In the console tree, right-click **Roles**, and then click **Add Roles**.
3. Review the information on the **Before You Begin** page of the Add Roles Wizard, and then click **Next.**
4. On the Select Server Roles page, in the Roles list, select the Active Directory Lightweight Directory Services checkbox, and then click Next.
5. Finish adding the AD LDS server role by following the instructions in the wizard.

Please use the following screen shots as a guide to install AD LDS.

![Graphical user interface, text, application, email](../../.gitbook/assets/0.jpeg)

![Graphical user interface, text, application, Word](<../../.gitbook/assets/1 (1).jpeg>)

![Graphical user interface, text, application, email](../../.gitbook/assets/2.png)

![Graphical user interface, text, application](../../.gitbook/assets/3.jpeg)

* Select AD LDS from the Roles and add the applicable features for the role.

![Graphical user interface, text, application, Word](../../.gitbook/assets/4.jpeg)

![Graphical user interface, text, application, email](../../.gitbook/assets/5.jpeg)

* Click Install.
* After AD LDS is installed, please follow the below steps to set up an active directory for Generate tool.
* From the Server Manager, click on AD LDS.

![Graphical user interface, text, application, email](<../../.gitbook/assets/6 (2).jpeg>)

* Click on the “Configuration required” task and click on the Action link from the Task Window to open up the Active Directory Setup Wizard.

![Graphical user interface, text, application](../../.gitbook/assets/7.png) ![Graphical user interface, text](../../.gitbook/assets/8.png)

* Click Next.

![Graphical user interface, text, application, email](../../.gitbook/assets/9.png)

* Select “Unique Instance” option and click Next.

![Graphical user interface, text, application, email](<../../.gitbook/assets/10 (1).png>)

![Graphical user interface, text, application, email](../../.gitbook/assets/11.png)

![Graphical user interface, text, application, email](../../.gitbook/assets/12.png)

![Graphical user interface, text, application, email](../../.gitbook/assets/13.png)

![Graphical user interface, text, application, email](../../.gitbook/assets/14.png)

![Graphical user interface, text, application, email](../../.gitbook/assets/15.png)

![Graphical user interface, text, application, email](<../../.gitbook/assets/16 (1).png>)

![Graphical user interface, text, application](../../.gitbook/assets/17.png)

![Graphical user interface, text, application, email](../../.gitbook/assets/18.png)

![Graphical user interface](../../.gitbook/assets/19.png)

### Active Directory Service Interfaces (ADSI) Editor <a href="#toc109377196" id="toc109377196"></a>

ADSI Edit is a tool used to connect to an active directory instance. It gets installed when AD LDS server role is installed.

Please use the following screenshots to connect to the AD LDS instance and set up the various roles and users for the Generate application.

![Graphical user interface, text, application](../../.gitbook/assets/20.png)

After connecting to the AD instance, a user should see 3 roles by default:&#x20;

> Admin
>
> Readers
>
> Users

{% hint style="info" %}
A new “**Reviewers**” role will need to be added to the existing roles. The Generate tool has been configured to use Admin and Reviewers roles.
{% endhint %}

Please use the following steps to create a user for the generate tool in ADSI Edit.

1. Right click on the Generate active directory in ADSI Edit and select New object.
2. Click Next.
3. Enter the user name and click Next.
4. Click on the “More Attributes” button and set the following properties on the user object.

> distinguishedName: **CN=svuyuru, CN=Generate, DC=CIID, DC=COM**
>
> displayName : **Sumanth Vuyuru**
>
> givenName : **Sumanth**
>
> msDS-UserAccountDisabled : **False**
>
> userPrincipalName : **svuyuru**
>
> msDS-UserDontExpirePassword: **True** 🚨_Set this property if you don’t want to expire user’s password._

5. Go back and set “`ms-DS-UserPasswordNotRequired`” to **False**.

To add a user to a specific role, please add the user to member property of the role. Please use the following instructions.

1. Right click on the role and select **Properties**.
2. Go to member property and **Edit** it.
3. You should be able to add the user to that role using Distinguished Name (DN). Following is a sample DN that was added.

> CN=svuyuru,CN=Generate,DC=CIID,DC=COM
