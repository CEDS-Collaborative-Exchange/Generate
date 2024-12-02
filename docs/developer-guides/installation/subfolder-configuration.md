# Subfolder configuration

### Step 1: Update HTML Base Tag

1. In the index.html file, which is located under the `wwwroot` folder of your Angular project, find the `<base>` tag.
2. Modify the `href` attribute to match your subfolder path. For example, if your subfolder is named `Test`, update the tag like this:

```html
<base href="/Test/">
```

<figure><img src="../../.gitbook/assets/Screenshot 2024-09-18 151411.jpg" alt="Screenshot of a Notepad++ editor displaying an index.html file with an updated <base href=&#x22;/Test/&#x22;> tag. The HTML file includes meta tags, viewport settings, and linked resources. It shows the modification step for running the Generate application from a subfolder."><figcaption><p>HTML configuration for running Generate from a subfolder. The index.html file's <code>&#x3C;base></code> tag is updated to reference the subfolder named 'Test' for proper path handling when running Generate from a subdirectory.</p></figcaption></figure>

3. Save the changes.

### Step 2: Create a Subfolder

1. Navigate to the web folder where Generate is installed, usually located in the root of your website.
2. Create a new subfolder, for example, `Test`, under the main site directory.

### Step 3: Update IIS Settings

1. Open IIS Manager on your server.
2. Expand the left-hand tree and locate the website where Generate is hosted.
3. Select the newly created subfolder (e.g., `Test`), right-click, and choose Convert to Application.
4. Follow the prompts to complete the conversion. Ensure that the subfolder has the appropriate permissions and points to the correct application pool.
