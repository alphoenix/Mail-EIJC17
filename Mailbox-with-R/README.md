# mailbox-with-R
Analyzing email boxes with R - May 2017

Simple R script that would extract data from a directory containing emails.
For the moment, this script reads emails in the emails directory, parses Sender, Receivers, Subjects, Body and Timestamps.
It then creates a gexf files, allowing you to display and post a network in Gephi, for instance.

Tested on OSX and Linux. May not work on Windows due to some encoding issues.

A subdirectory "mails" contains a sample dataset of 66 eml files, mostly spam, from my own old spammed mailbox.
A subdirectory "Output" contains the generated fils and graphs.

# How to use it : 

 - Install R packages by uncommenting the first lines of the script.
 - Modify the mail directory in the script
 - Execute the script.

Successfully tested on more than 2000 mails, on a decent computer.

# Example of generated graphs

Graph exported to Gephi
![](https://framapic.org/1GuGVF6DD7Gw/3ObZ5oMeD2Eb)

Stats on From: field
![](https://framapic.org/3xlIo9Faqpgz/Vl7xc3pidkpF)


- Text-mining of the mail content
- Wordcloud

# Todo

- IP parsing and analysis

# Known issues

 - Due to some misinterpretation of the filepath by Windows, the script doesn't appear to work for the moment on this configuration. (You shouldn't be working with Windows computer anyway, so it's no big deal...)
 - sna and network libraries may badly interfere with igraph during graph generation. Don't hesitate to unload these libraries when necessary.


