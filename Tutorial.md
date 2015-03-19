# Introduction #

**ProtNet** is a graph visualization tool for Cancer Proteomic Networks.

Currently, there are 3 main visualization options: **Default**, **Custom**, and **Upload**. You can switch between the options via the tabbed panel on the right hand side.

# Visualizing A Network Under The Default Tab #

  * Select a **Cancer Study** via the corresponding drop down menu.
![http://wiki.captonviz.googlecode.com/hg/images/101-default_cancer_study.png](http://wiki.captonviz.googlecode.com/hg/images/101-default_cancer_study.png)
  * Select a **Method**
![http://wiki.captonviz.googlecode.com/hg/images/102-default_method.png](http://wiki.captonviz.googlecode.com/hg/images/102-default_method.png)
  * Set the desired **Number of Edges** by using the slider.
  * Press the **Visualize** button. This will generate a network for selected options.
  * Once the visualization is complete, you can change edge coloring and node labels by using the corresponding drop down menus. ![http://wiki.captonviz.googlecode.com/hg/images/103-edge_sign.png](http://wiki.captonviz.googlecode.com/hg/images/103-edge_sign.png) ![http://wiki.captonviz.googlecode.com/hg/images/104-node_label.png](http://wiki.captonviz.googlecode.com/hg/images/104-node_label.png)

# Visualizing A Network Under The Custom Tab #

  * First you have to specify a list of **Samples**. Easiest way to obtain a custom list of samples is to get it from cBio Portal web page.
    * Go to www.cbioportal.org
    * Select a cancer study, and then a patient/case set and enter a list of genes. ![http://wiki.captonviz.googlecode.com/hg/images/202-submit_query.png](http://wiki.captonviz.googlecode.com/hg/images/202-submit_query.png)
    * After you submit the query you can find the list of samples under the download tab. ![http://wiki.captonviz.googlecode.com/hg/images/203-download_tab.png](http://wiki.captonviz.googlecode.com/hg/images/203-download_tab.png)
    * Alternatively you can query all cancer studies by just entering a list of genes. In this case, you may find the list of samples under mutations tab.
  * Once you enter a list of samples, select a **Method** and set the **Number of Edges**.
![http://wiki.captonviz.googlecode.com/hg/images/204-custom_samples%26method.png](http://wiki.captonviz.googlecode.com/hg/images/204-custom_samples%26method.png)
  * Press the **Visualize** button. This will generate the custom network for the specified list of samples and the method.
  * Similar to the default tab, you can change edge coloring and node labels by using the corresponding menus.

# Visualizing A Network Under The Upload Tab #

  * First you have to select a tab delimited data matrix file to upload. See DataMatrixFileFormat for details.
![http://wiki.captonviz.googlecode.com/hg/images/301-upload_tab.png](http://wiki.captonviz.googlecode.com/hg/images/301-upload_tab.png)
  * Once you select the data matrix file to upload, select a **Method** and set the **Number of Edges**.
  * Press the **Visualize** button. This will generate the network for the provided data matrix.