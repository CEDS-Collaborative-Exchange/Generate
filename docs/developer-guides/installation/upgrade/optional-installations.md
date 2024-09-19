# Optional Installations

#### Install Active Directory Lightweight Directory Services (AD LDS)

AD LDS is suitable for environments without Active Directory. Follow these steps to install AD LDS on Windows Server 2008 or higher:

1. **Open Server Manager**: Click **Start** > **Server Manager**.
2. **Adding Roles**: Right-click on **Roles** > **Add Roles**.
3. **Beginning the Add Roles Wizard**: On the **Before You Begin** page, click **Next**.
4. **Selecting Server Roles**: Choose **Active Directory Lightweight Directory Services** from the list and click **Next**.
5. **Finish the Installation**: Follow the wizard's instructions to complete the addition of the AD LDS server role.

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image6.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image2.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image3.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image4.png" alt=""><figcaption></figcaption></figure>

* Select AD LDS from the Roles and add the applicable features for the role.

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image5 (1).png" alt=""><figcaption></figcaption></figure>



<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image6 (2).png" alt=""><figcaption></figcaption></figure>

* Click Install.
* After AD LDS is installed, please follow the below steps to set up an active directory for Generate tool.
* From the Server Manager, click on AD LDS.

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image7 (1).png" alt=""><figcaption></figcaption></figure>

* Click on the “Configuration required” task and click on the Action link from the Task Window to open up the Active Directory Setup Wizard.

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image8.png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image9.png" alt=""><figcaption></figcaption></figure>

* Click Next.

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image10.png" alt=""><figcaption></figcaption></figure>

* Select “Unique Instance” option and click Next.

<figure><img src="../../../.gitbook/assets/Developer Guide_Upgrade_image11.png" alt=""><figcaption></figcaption></figure>

#### Adding a User to an Active Directory Role using ADSI Edit

To add a user to a specific role in Active Directory, follow these steps using ADSI Edit, a tool that comes with the AD LDS server role installation.

1. **Open ADSI Edit** and connect to your AD instance. You should see default roles: Admin, Readers, and Users. Add a "Reviewers" role if it's not present.
2. **Right-click on the Generate directory** within ADSI Edit, and choose **New > Object** to create a new user.
3. For the new user, enter the following distinguished name (DN):\
   `CN=svuyuru, CN=Generate, DC=CIID, DC=COM`
4. **Configure the user's attributes** by right-clicking on the user and selecting **Properties**. Then click on **More Attributes** and set the following properties:
   * `ms-DS-UserPasswordNotRequired: True`\
     After creation, reset the user’s password by right-clicking on the user.
   * `msDS-UserDontExpirePassword: True`\
     Enable this if the user’s password should never expire.
   * `userPrincipalName: svuyurums`
   * `msDS-UserAccountDisabled: False`
   * `givenName: Sumanth`
   * `displayName: Sumanth Vuyuru`
   * `distinguishedName: CN=svuyuru, CN=Generate, DC=CIID, DC=COM`
5. To add the user to a role, navigate to the role under ADSI Edit. Right-click the role, choose **Properties**, and then add the user to the **member** property.
6. Remember to **disable "ms-DS-UserPasswordNotRequired"** by setting it to False after the user has been added.

By following these instructions, you can easily manage roles and users for the Generate tool in an Active Directory environment using ADSI Edit.
